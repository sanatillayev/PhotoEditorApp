//
//  Modules.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import Foundation
import Combine

protocol AnyModules {
    var appStateManager: AppStateManager { get }
    var authManager: AnyAuthManager { get }
}

final class Modules: AnyModules {
    
    // MARK: - All Services
    var appStateManager: AppStateManager
    lazy var authManager: AnyAuthManager = AuthManager(authStateManager: appStateManager)

    // MARK: - Life Cycle
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.appStateManager = AppStateManager()
        
        appStateManager.$authState
            .sink { authState in
                print("did change authState: \(authState)")
            }
            .store(in: &cancellables)
    }
    
    deinit {
        
    }
}

