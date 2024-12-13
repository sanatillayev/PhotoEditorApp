//
//  AuthWorker.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

protocol AnyAuthWorker {
    var authState: AuthState { get }
    func authorizeWithGoogle() async throws
    func authorizeWithEmail(email: String, password: String) async throws
    func signInWithEmail(email: String, password: String) async throws
    func resetPassword(email: String) async throws
}

final class AuthWorker: AnyAuthWorker {

    // MARK: - Public Properties
    var authState: AuthState {
        appStateManager.authState.state
    }
    
    // MARK: - Private Properties
    private let authManager: AnyAuthManager
    private let appStateManager: AppStateManager

    init(modules: AnyModules) {
        self.appStateManager = modules.appStateManager
        self.authManager = modules.authManager
    }

    func authorizeWithGoogle() async throws {
        try await authManager.authorize()
    }
    
    func authorizeWithEmail(email: String, password: String) async throws {
        try await authManager.register(with: email, password: password)
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        try await authManager.signIn(with: email, password: password)
    }
    
    func resetPassword(email: String) async throws {
        try await authManager.resetPassword(email: email)
    }

}
