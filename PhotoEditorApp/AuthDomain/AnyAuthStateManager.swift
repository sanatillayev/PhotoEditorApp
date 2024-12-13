//
//  AnyAuthStateManager.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

protocol AnyAuthStateManager: AnyObject {
    @MainActor func authorizationInProgress()
    @MainActor func authorizationRestored(authType: AuthType)
    @MainActor func notAuthorized()
    @MainActor func startSession(user: User, with authType: AuthType)
    @MainActor func performLogout()
    @MainActor func setAuthType(_ type: AuthType)
}
