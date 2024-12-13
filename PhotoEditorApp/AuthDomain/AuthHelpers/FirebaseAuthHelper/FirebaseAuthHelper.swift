//
//  FirebaseAuthHelper.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation
import FirebaseAuth

// MARK: - SignInWithFirebaseError
enum SignInWithFirebaseError: LocalizedError {
    case noPreviousSignIn
    case emptyEmailOrPassword
    case invalidAuth(String)
    case passwordResetFailed(String)
}

// MARK: - FirebaseAuthHelper
final class FirebaseAuthHelper {

    // MARK: - Initialization

    init() { }

    // MARK: - Public Methods

    func restoreAuthorization() async throws -> User? {
        guard let user = Auth.auth().currentUser else {
            throw SignInWithFirebaseError.noPreviousSignIn
        }
        
        return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
    }
    
    func restoreAuthorization() async throws -> BearerToken? {
        guard let user = Auth.auth().currentUser else {
            throw SignInWithFirebaseError.noPreviousSignIn
        }
        
        do {
            let idToken = try await user.getIDToken()
            return idToken
        } catch {
            throw SignInWithFirebaseError.invalidAuth(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) async throws -> User {
        guard !email.isEmpty, !password.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }

        let user = try await Auth.auth().signIn(withEmail: email, password: password).user
        return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
    }

    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw SignInWithFirebaseError.invalidAuth("Failed to sign out")
        }
    }

    func register(email: String, password: String) async throws -> User {
        guard !email.isEmpty, !password.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user
            return User(id: user.uid, email: user.email, name: user.displayName, picture: user.photoURL?.absoluteString)
        } catch {
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        guard !email.isEmpty else {
            throw SignInWithFirebaseError.emptyEmailOrPassword
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw SignInWithFirebaseError.passwordResetFailed("Failed to send password reset email \(error)")
        }
    }
}
