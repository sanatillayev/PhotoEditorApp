//
//  NavigationModifier.swift
//  CleanSwiftUI
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

struct NavigationModifier: ViewModifier {

    @Binding var presentingView: AnyView?

    func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: isPresentedBinding, destination: {
                self.presentingView
            })
    }
    
    private var isPresentedBinding: Binding<Bool> {
        Binding(
            get: { self.presentingView != nil },
            set: { if !$0 { self.presentingView = nil } }
        )
    }
}
