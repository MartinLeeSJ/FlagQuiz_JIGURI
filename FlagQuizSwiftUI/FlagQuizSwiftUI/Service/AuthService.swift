//
//  AuthService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine
import AuthenticationServices

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn


protocol AuthServiceType {
    func checkAuthenticationState() -> String?
    
    func checkIfAnonymousUser() -> Bool?
    func signInAnonymously() -> AnyPublisher<FQUser, AuthenticationServiceError>
    
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError>
    
    func requestSignInWithApple(_ request: ASAuthorizationAppleIDRequest) -> String
    func completeSignWithApple(_ authorization: ASAuthorization, isLinking: Bool, nonce: String) -> AnyPublisher<FQUser, AuthenticationServiceError>
    
   
    func signOut() throws
    func deleteAccount() async throws -> String
}

enum AuthenticationServiceError: Error {
    case cannotfoundRootViewController
    case invalidClientID
    case invalidUser
    case invalidCredential
    case invalidToken
    case invalidated
    case custom(Error)
}

final class AuthService: AuthServiceType {
    
    public func checkAuthenticationState() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return nil
    }
    
    func checkIfAnonymousUser() -> Bool? {
        if let user = Auth.auth().currentUser {
            return user.isAnonymous
        }
        
        return nil
    }
    
    func signInAnonymously() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Future { promise in
            Auth.auth().signInAnonymously { authResult, error in
                guard let user = authResult?.user else {
                    promise(.failure(AuthenticationServiceError.invalidUser))
                    return
                }
                
                if let error {
                    promise(.failure(AuthenticationServiceError.custom(error)))
                }
                
                let fqUser: FQUser = .init(
                    id: user.uid,
                    createdAt: Date.now,
                    email: user.email ?? "",
                    userName: user.displayName ?? ""
                )
                
                promise(.success(fqUser))
            }
        }
        .eraseToAnyPublisher()
    }
    
   
    
    public func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Future { [weak self] promise in
            self?.signInWithGoogle {
                promise($0)
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    public func requestSignInWithApple(_ request: ASAuthorizationAppleIDRequest) -> String {
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        return nonce
    }
    
    public func completeSignWithApple(
        _ authorization: ASAuthorization,
        isLinking: Bool = false,
        nonce: String
    ) -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Future { [weak self] promise in
            self?.completeSignInWithApple(authorization,
                                          nonce: nonce,
                                          isLinking: isLinking,
                                          completion: {
                promise($0)
            })
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationServiceError.invalidUser
        }
        
        // 여기서 발생하는 오류는 어떻게 관리하지?
        try await user.delete()
        return user.uid
    }
    
    
    
}

// MARK: - Sign In With Google
extension AuthService {
    private func signInWithGoogle(_ completion: @escaping ((Result<FQUser, AuthenticationServiceError>) -> Void)) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(.invalidClientID))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            completion(.failure(.cannotfoundRootViewController))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] (result, error) in
            guard error == nil else {
                completion(.failure(.custom(error!)))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                completion(.failure(.invalidUser))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            self?.linkUserWithFirebase(credetial: credential, completion: completion)
        }
    }
}

//MARK: - Sign In with Apple

extension AuthService {
    private func completeSignInWithApple(_ authorization: ASAuthorization,
                                         nonce: String,
                                         isLinking: Bool = false,
                                         completion: @escaping((Result<FQUser, AuthenticationServiceError>) -> Void)) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            completion(.failure(.invalidCredential))
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(.invalidToken))
            return
        }
        
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        if isLinking {
            linkUserWithFirebase(credetial: credential, completion: firebaseAuthResultHandler)
        } else {
            signInWithFirebase(credetial: credential, completion: firebaseAuthResultHandler)
        }
        
        func firebaseAuthResultHandler(_ result: Result<FQUser, AuthenticationServiceError>) -> Void {
            switch result {
            case .success(var user):
                let name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                user.email = appleIDCredential.email
                user.userName = name
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

//MARK: - Firestore
extension AuthService {
    private func linkUserWithFirebase(
        credetial: AuthCredential,
        completion: @escaping ((Result<FQUser, AuthenticationServiceError>) -> Void)
    ) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(.invalidUser))
            return
        }
        
        user.link(with: credetial) { result, error in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let result else {
                completion(.failure(.invalidated))
                return
            }
            
            let fqUser: FQUser = .init(
                id: result.user.uid,
                createdAt: .now,
                email: result.user.email ?? "",
                userName: result.user.displayName ?? ""
            )
            
            completion(.success(fqUser))
        }
    }
    
    private func signInWithFirebase(
        credetial: AuthCredential,
        completion: @escaping ((Result<FQUser, AuthenticationServiceError>) -> Void)
    ) {
        Auth.auth().signIn(with: credetial) { (result, error) in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let result else {
                completion(.failure(.invalidated))
                return
            }
            
            let firebaseUser: User = result.user
            let user: FQUser = .init(
                id: firebaseUser.uid,
                createdAt: Date.now,
                email: firebaseUser.email ?? "",
                userName: firebaseUser.displayName ?? ""
                )
            
                completion(.success(user))
        }
    }
}

// MARK: - Stub
final class StubAuthService: AuthServiceType {
    func checkAuthenticationState() -> String? {
        return "1"
    }
    
    func checkIfAnonymousUser() -> Bool? {
        return true
    }
    
    func signInAnonymously() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func linkAppleAccount(
        _ authorization: ASAuthorization,
        nonce: String
    ) -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func requestSignInWithApple(_ request: ASAuthorizationAppleIDRequest) -> String {
        ""
    }
    
    func completeSignWithApple(
        _ authorization: ASAuthorization,
        isLinking: Bool = false,
        nonce: String
    ) -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func signOut() throws {
        
    }
    
    func deleteAccount() async throws -> String {
        ""
    }
}
