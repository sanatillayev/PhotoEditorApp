//
//  SignUpView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel: AuthViewModel
    @StateObject var router: AuthRouter
    
    var body: some View {
        VStack {
            FieldView(
                title: "Email",
                text: emailBinding,
                placeholder: "Enter your email"
            )
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            
            SecureField("Password", text: passwordBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            ActionButton(title: "Sign Up", isEnabled: isButtonEnabledBinding) {
                viewModel.action.send(.registerWithEmail)
            }
            .padding(.vertical)
        }
        .navigationTitle("Sign Up")
        .onAppear(perform: {
            viewModel.action.send(.checkAppState)
        })
        .alert("Error", isPresented: didFailBinding, actions: {
        }, message: {
            Text(viewModel.state.alerMessage)
        })
        .onReceive(viewModel.$state) { state in
            if state.isSignedUp {
                router.closeView()
            }
        }
    }
}

extension SignUpView {
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
    
    var didFailBinding: Binding<Bool> {
        Binding {
            viewModel.state.didFail
        } set: { newValue in
            viewModel.action.send(.setDidFail(newValue))
        }
    }
    
    var isButtonEnabledBinding: Binding<Bool> {
        Binding {
            viewModel.state.isButtonEnabled
        } set: { newValue in
            viewModel.action.send(.setButtonEnabled(newValue))
        }
    }
    
    var errorMessageBinding: Binding<String> {
        Binding {
            viewModel.state.alerMessage
        } set: { newValue in
            viewModel.action.send(.setAlert(newValue))
        }
    }
    var isSignedUpBinding: Binding<Bool> {
        Binding {
            viewModel.state.isSignedUp
        } set: { newValue in
            viewModel.action.send(.setSignedUp(newValue))
        }
    }
}
