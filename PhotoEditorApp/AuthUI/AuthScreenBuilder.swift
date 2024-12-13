//
//  AuthScreenBuilder.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import SwiftUI

final class AuthScreenBuilder {
    private static func getViewModel(with modules: AnyModules) -> AuthViewModel {
        let worker = AuthWorker(modules: modules)
        return AuthViewModel(worker: worker)
    }
    
    static func createSignInScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>
    ) -> SignInView {
        let viewModel = getViewModel(with: modules)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = SignInView(viewModel: viewModel, router: router)
        return scene
    }
    
    static func createSignUpScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> SignUpView {
        let viewModel = getViewModel(with: modules)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = SignUpView(viewModel: viewModel, router: router)
        return scene
    }
    
    static func createPasswordRecoveryScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> ResetPasswordView {
        let worker = AuthWorker(modules: modules)
        let viewModel = ResetPasswordViewModel(worker: worker)
        let router = AuthRouter(modules: modules, presentationType: presentationType)
        let scene = ResetPasswordView(viewModel: viewModel, router: router)
        return scene

    }
}
