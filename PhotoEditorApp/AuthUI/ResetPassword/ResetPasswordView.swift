//
//  ResetPasswordView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel: ResetPasswordViewModel
    @StateObject var router: AuthRouter

    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Text("Reset Password")
                    .font(.title)
                    .padding(.all, 40)
                Spacer()
            }
            VStack {
                FieldView(
                    title: "Email",
                    text: emailBinding,
                    placeholder: "Enter your email"
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                
                ActionButton(title: "Reset Password", isEnabled: isButtonEnabledBinding) {
                    viewModel.action.send(.resetPassword)
                }
                .padding(.vertical, 40)
            }
        }
        .sheet(router)
        .onAppear(perform: {
            viewModel.action.send(.checkAppState)
        })
        .alert("Error", isPresented: didFailBinding, actions: {
            Button("OK") {
                router.closeView()
            }
        }, message: {
            Text(viewModel.state.alerMessage)
        })
        .alert("Reset Email Sent", isPresented: isSuccessResetBinding, actions: {
            Button("OK") {
                router.closeView()
            }
        }, message: {
            Text("We sent you an email with link to reset your password")
        })
    }
}

extension ResetPasswordView {
    var emailBinding: Binding<String> {
        Binding {
            viewModel.state.email
        } set: { newValue in
            viewModel.action.send(.setEmail(newValue))
        }
    }
    
    var passwordBinding: Binding<String> {
        Binding {
            viewModel.state.password
        } set: { newValue in
            viewModel.action.send(.setPassword(newValue))
        }
    }
    
    var isButtonEnabledBinding: Binding<Bool> {
        Binding {
            viewModel.state.isButtonEnabled
        } set: { newValue in
            viewModel.action.send(.setButtonEnabled(newValue))
        }
    }
    var didFailBinding: Binding<Bool> {
        Binding {
            viewModel.state.didFail
        } set: { newValue in
            viewModel.action.send(.setDidFail(newValue))
        }
    }
    var isSuccessResetBinding: Binding<Bool> {
        Binding {
            viewModel.state.isSuccessReset
        } set: { newValue in
            viewModel.action.send(.setIsSuccessReset(newValue))
        }
    }
}
