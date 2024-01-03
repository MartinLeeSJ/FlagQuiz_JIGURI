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
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError>
    func requestSignInWithApple(_ request: ASAuthorizationAppleIDRequest) -> String
    func completeSignInWithApple(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<FQUser, AuthenticationServiceError>
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
    
    public func completeSignInWithApple(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Future { [weak self] promise in
            self?.completeSignInWithApple(authorization, nonce: nonce, completion: { promise($0) })
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
            
            self?.authenticateUserWithFirebase(credetial: credential, completion: completion)
        }
    }
}

//MARK: - Sign In with Apple

extension AuthService {
    private func completeSignInWithApple(_ authorization: ASAuthorization,
                                         nonce: String,
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
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        
        authenticateUserWithFirebase(credetial: credential) { result in
            switch result {
            case .success(var user):
                let name = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
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
    private func authenticateUserWithFirebase(
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


final class StubAuthService: AuthServiceType {
    func checkAuthenticationState() -> String? {
        return "1"
    }
    
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func requestSignInWithApple(_ request: ASAuthorizationAppleIDRequest) -> String {
        ""
    }
    
    func completeSignInWithApple(_ authorization: ASAuthorization, nonce: String) -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func signOut() throws {
        
    }
    
    func deleteAccount() async throws -> String {
        ""
    }
}
