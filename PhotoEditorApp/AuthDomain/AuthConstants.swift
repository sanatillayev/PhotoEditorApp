//
//  AuthConstants.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation

// MARK: - AuthState
enum AuthState: Equatable {
    case loggedIn
    case loading
    case notAuthorize
}

// MARK: - AuthType
enum AuthType: String, Codable {
    case google
    case email
}

// MARK: - AuthError
enum AuthError: Error {
    case invalidAuth(String)
    case emptyGoogleToken
}

