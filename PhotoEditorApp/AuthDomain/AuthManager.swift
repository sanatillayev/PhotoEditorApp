//
//  AuthManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

typealias BearerToken = String

protocol AnyAuthManager {
    func restoreAuthorisation() async throws
    func register(with email: String, password: String) async throws
    func signIn(with email: String, password: String) async throws
    func authorize() async throws
    func resetPassword(email: String) async throws
    func logout() async
}

final class AuthManager: AnyAuthManager {
    //MARK: - Private properties
    
    private let authStateManager: AnyAuthStateManager
    private let googleAuthHelper = GoogleAuthHelper()
    private let firebaseAuthHelper = FirebaseAuthHelper()
    
    @CodableStorage(key: "LastAuthType", defaultValue: nil)
    private var lastAuthType: AuthType?
    //MARK: - Initialization
    
    init(authStateManager: AnyAuthStateManager) {
        self.authStateManager = authStateManager
    }
    
    //MARK: - Public methods
    func restoreAuthorisation() async {
        guard let lastAuthType else {
            await authStateManager.notAuthorized()
            return
        }
        await authStateManager.authorizationInProgress()
        
        let token: BearerToken?
        do {
            switch lastAuthType {
            case .google:
                token = try await googleAuthHelper.restoreAuthorization()
            case .email:
                token = try await firebaseAuthHelper.restoreAuthorization()
            }
            
            if let _ = token {
                await authStateManager.authorizationRestored(authType: lastAuthType)
            } else {
                await authStateManager.notAuthorized()
            }
        } catch {
            await authStateManager.notAuthorized()
        }
    }
    
    func authorize() async {
        await authStateManager.authorizationInProgress()
        await authStateManager.setAuthType(.google)
        
        do {
            let user = try await googleAuthHelper.authorizeUser()
            await authStateManager.startSession(user: user, with: .google)
            self.lastAuthType = .google
        } catch {
            await authStateManager.notAuthorized()
        }
    }
    
    func register(with email: String, password: String) async throws {
        await authStateManager.authorizationInProgress()
        await authStateManager.setAuthType(.email)

        do {
            let user = try await firebaseAuthHelper.register(email: email, password: password)
            await authStateManager.startSession(user: user, with: .email)
            self.lastAuthType = .email
        } catch {
            await authStateManager.notAuthorized()
            throw error
        }
    }
    
    func signIn(with email: String, password: String) async throws {
        await authStateManager.authorizationInProgress()
        await authStateManager.setAuthType(.email)

        do {
            let user = try await firebaseAuthHelper.signIn(email: email, password: password)
            await authStateManager.startSession(user: user, with: .email)
            self.lastAuthType = .email
        } catch {
            await authStateManager.notAuthorized()
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await firebaseAuthHelper.resetPassword(email: email)
        } catch {
            print("Failed to send password reset email: \(error.localizedDescription)")
            throw error
        }
    }
    
    func logout() async {
        await MainActor.run {
            authStateManager.performLogout()
        }
    }
}

