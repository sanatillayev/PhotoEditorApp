//
//  GoogleAuthHelper.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

// MARK: - SignInWithGoogleError
enum SignInWithGoogleError: LocalizedError {
    case noPreviousSignIn
    case emptyTokenError
    case invalidAuth(String)
}

// MARK: - SignInWithGoogleConstants
enum SignInWithGoogleConstants {
    static let googleClientId = "369442553132-80ikm8m61140efmh192k1870v53rf32l.apps.googleusercontent.com"
    static let googleServerClientId = "369442553132-80ikm8m61140efmh192k1870v53rf32l.apps.googleusercontent.com"
}


// MARK: - GoogleAuthHelper
final class GoogleAuthHelper {
    
    //MARK: - Initialization
    
    init() { }
    
    // MARK: - Public Methods
    
    func restoreAuthorization() async throws -> BearerToken? {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            throw SignInWithGoogleError.noPreviousSignIn
        }
        
        let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        return user.idToken?.tokenString
    }
    
    func authorizeUser() async throws -> User {
        let configuration = GIDConfiguration(clientID: SignInWithGoogleConstants.googleClientId)
        
        GIDSignIn.sharedInstance.configuration = configuration
        let gidUser = try await showGoogleWindow()
        guard let token = gidUser.idToken?.tokenString else {
            throw SignInWithGoogleError.emptyTokenError
        }
        let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: gidUser.accessToken.tokenString)
        let firebaseUser = try await Auth.auth().signIn(with: credential).user
        
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            picture: firebaseUser.photoURL?.absoluteString
        )
    }
    
    func authorize() async throws -> BearerToken {
        let configuration = GIDConfiguration(clientID: SignInWithGoogleConstants.googleClientId,
                                             serverClientID: SignInWithGoogleConstants.googleServerClientId)
        GIDSignIn.sharedInstance.configuration = configuration
        let gidUser = try await showGoogleWindow()
        guard let token = gidUser.idToken?.tokenString else {
            throw AuthError.emptyGoogleToken
        }
    
        return token
    }
    
    func signOut() async {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Private Methods
    
    @MainActor private func showGoogleWindow() async throws -> GIDGoogleUser {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let keyWindow = windowScene?.windows.first
        guard let controller = keyWindow?.rootViewController else {
            assert(false)
            throw SignInWithGoogleError.invalidAuth("Can't find key window")
        }
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: controller)
        return signInResult.user
    }
}
