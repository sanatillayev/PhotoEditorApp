//
//  PhotoEditorApp.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAppCheck
import Firebase
import FirebaseAppCheckInterop

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        #if DEBUG
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif
        print("FirebaseAppCheck working ")
        return true
    }
}

@main
struct PhotoEditorApp: App {
    
    private let modules: AnyModules
    @ObservedObject private var appStateManager: AppStateManager
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        self.modules = Modules()
        self.appStateManager = modules.appStateManager
        
        Task.detached(priority: .high) { [self] in
            try await self.modules.authManager.restoreAuthorisation()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if appStateManager.authState.state == .loggedIn {
                    ImageEditBuilder.createImageEditorScreen(with: modules, presentationType: .constant(true))
                } else if appStateManager.authState.state == .notAuthorize {
                    AuthScreenBuilder.createSignInScreen(with: modules, presentationType: .constant(true))
                    .onOpenURL(perform: { url in
                        GIDSignIn.sharedInstance.handle(url)
                    })
                }
            }
            .overlay {
                appLoadingView
            }
        }
    }
    
    @ViewBuilder
    private var appLoadingView: some View {
        if appStateManager.authState.state == .loading {
            LinearGradient.baseGradient
                .blur(radius: 4)
                .overlay {
                    LoadingView(text: "Loading...")
                }
                .ignoresSafeArea()
        }
    }
}
