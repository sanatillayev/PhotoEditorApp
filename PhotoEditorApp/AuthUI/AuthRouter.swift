//
//  AuthRouter.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import Foundation
import SwiftUI

protocol AnyAuthRouter {
    func closeView()
}
final class AuthRouter: Router, AnyAuthRouter {
    
    private let modules: AnyModules

    init(modules: AnyModules, presentationType: Binding<Bool>) {
        self.modules = modules
        super.init(presentationType: presentationType)
    }

    // MARK: - Public Methods

    func openSignUp() {
        let scene = AuthScreenBuilder.createSignUpScreen(with: modules, presentationType: isNavigating) {
            
        }
        navigateTo(scene)
    }
    
    func openSignIn() {
        let scene = AuthScreenBuilder.createSignInScreen(with: modules, presentationType: isNavigating)
        navigateTo(scene)
    }
    
    func presentPasswordRecovery() {
        let scene = AuthScreenBuilder.createPasswordRecoveryScreen(with: modules, presentationType: isPresentingSheet) {
            
        }
        presentSheet(scene)
    }
    
    func closeView() {
//        onDissmiss()
        self.dismiss()
    }
}
