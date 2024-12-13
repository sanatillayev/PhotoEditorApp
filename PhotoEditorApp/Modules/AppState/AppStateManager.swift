//
//  AppStateManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

final class AppStateManager: ObservableObject {
    
    // MARK: Public properties
    @Published private(set) var appState = AppState()
    @Published private(set) var authState = AuthorizationState()
    
}

// MARK: - AppState
extension AppStateManager {
    
    struct AppState {
        @AppStorage("PhotoEditorUserID")
        var userId: String?
        internal var bearerToken: String?
    }
    
    struct AuthorizationState {
        var state: AuthState = .loading
        var type: AuthType?
    }
}

// MARK: - AnyAuthStateManager
extension AppStateManager: AnyAuthStateManager {
    @MainActor
    func setAuthType(_ type: AuthType) {
        self.authState.type = type
    }
    
    @MainActor
    func authorizationInProgress() {
        self.authState.state = .loading
    }
    
    @MainActor
    func notAuthorized() {
        self.authState.state = .notAuthorize
    }
    
    @MainActor
    func authorizationRestored(authType: AuthType) {
        self.authState.type = authType
        self.authState.state = .loggedIn
    }
    
    @MainActor
    func startSession(user: User, with authType: AuthType) {
        appState.userId = user.id
        authState.state = .loggedIn
        authState.type = authType
    }
    
    @MainActor
    func performLogout() {
        appState.userId = nil
        authState.type = nil
        authState.state = .notAuthorize
    }
 
}
