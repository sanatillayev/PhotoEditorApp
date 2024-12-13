//
//  ResetPasswordViewModel.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 13/12/24.
//

import Foundation

import Foundation
import SwiftUI
import Combine

final class ResetPasswordViewModel: ObservableObject {
    
    // MARK: Public Properties
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties
    private let worker: AnyAuthWorker
    private var subscriptions = Set<AnyCancellable>()

    // MARK: Init

    init(worker: AnyAuthWorker) {
        self.worker = worker
        
        action
            .sink(receiveValue: { [unowned self] in
                didChange($0)
            })
            .store(in: &subscriptions)
    }

    // MARK: Private Methods

    private func didChange(_ action: Action) {
        switch action {
        case .checkAppState:
            state.isLoading = (worker.authState == .loading)
        case .setEmail(let newEmail):
            state.email = newEmail
            state.isButtonEnabled = isValidEmail(state.email)
        case .setPassword(let newPassword):
            state.password = newPassword
            validateForm()
        case .resetPassword:
            resetPasswordRequest()
        case .setAlert(let newAlert):
            state.alerMessage = newAlert
        case .setDidFail(let newDidFail):
            state.didFail = newDidFail
        case .setButtonEnabled(let newValue):
            state.isButtonEnabled = newValue
        case .setIsSuccessReset(let newValue):
            state.isSuccessReset = newValue
        }
    }

    private func validateForm() {
        let isEmailValid = isValidEmail(state.email)
        let isPasswordValid = state.password.count > 4
        state.isButtonEnabled = isEmailValid && isPasswordValid
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func resetPasswordRequest() {
        Task.detached(priority: .high) { [weak self] in
            guard let self else { return }
            do {
                let email = self.state.email
                try await self.worker.resetPassword(email: email)
                DispatchQueue.main.async {
                    self.state.isSuccessReset = true
                }
            } catch {
                self.handle(error)
            }
        }
    }
    
    private func handle(_ error: Error) {
        //TODO: - Show Alert
        DispatchQueue.main.async { [weak self] in
            self?.state.alerMessage = error.localizedDescription
            self?.state.didFail = true
        }
    }
}

// MARK: - ViewModel Actions & State
extension ResetPasswordViewModel {

    enum Action{
        case checkAppState
        case setEmail(String)
        case setPassword(String)
        case setAlert(String)
        case setDidFail(Bool)
        case resetPassword
        case setButtonEnabled(Bool)
        case setIsSuccessReset(Bool)
    }

    struct State {
        var isLoading = false
        var email: String = ""
        var password: String = ""
        var alerMessage: String = ""
        var isSignedUp: Bool = false
        var didFail: Bool = false
        var isButtonEnabled: Bool = false
        var isSuccessReset: Bool = false
    }
}
