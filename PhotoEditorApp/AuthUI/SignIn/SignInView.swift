//
//  SignInView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

private enum Constants {
    static let buttonTitle: String = "Sign In"
}
struct SignInView: View {
    @StateObject var viewModel: AuthViewModel
    @StateObject var router: AuthRouter
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        VStack {
            Spacer()
            
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
                
                ActionButton(title: Constants.buttonTitle, isEnabled: isButtonEnabledBinding) {
                    viewModel.action.send(.loginWithEmail)
                }
                .padding(.vertical)
            }
            .padding(.all)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 24) {
                GoogleSignInButton(action: {
                    viewModel.action.send(.openGoogleForm)
                })
                .padding(.horizontal)
                
                Text("Don't have an account? Sign Up")
                    .padding()
                    .onTapGesture {
                        router.openSignUp()
                    }
                Button("Forgot Password?") {
                    router.presentPasswordRecovery()
                }
                .padding()
            }
        }
        .navigationTitle(Constants.buttonTitle)
        .navigation(router)
        .sheet(router)
        .onAppear(perform: {
            viewModel.action.send(.checkAppState)
        })
        .alert("Error", isPresented: didFailBinding, actions: {
        }, message: {
            Text(viewModel.state.alerMessage)
        })
        .background(ignoresSafeAreaEdges: .all)
        .background(content: { Color.txtSecondary })
        .offset(y: keyboardResponder.currentHeight / 2)
    }
}

// MARK: - Bindings
extension SignInView {
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
}
