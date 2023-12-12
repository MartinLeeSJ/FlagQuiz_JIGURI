//
//  AuthService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn


protocol AuthServiceType {
    func checkAuthenticationState() -> String?
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError>
    
}

enum AuthenticationServiceError: Error {
    case invalidClientID
    case cannotfoundRootViewController
    case invalidUser
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
                createdAt: .init(date: Date.now),
                email: firebaseUser.email ?? "",
                userName: firebaseUser.displayName ?? ""
            )
            
            completion(.success(user))
        }
    }
}


final class StubAuthService: AuthServiceType {
    func checkAuthenticationState() -> String? {
        return nil
    }
    
    func signInWithGoogle() -> AnyPublisher<FQUser, AuthenticationServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
