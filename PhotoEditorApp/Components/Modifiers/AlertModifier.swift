//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

struct CustomAlertViewModifier: ViewModifier {
    
    @State private var opacity: CGFloat = 0
    @State private var scale: CGFloat = 0.001
    
    init() { }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                animate(isShown: true)
            }
            .onDisappear {
                animate(isShown: false)
            }
    }
    
    private func animate(isShown: Bool) {
        if isShown {
            opacity = 1
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0)) {
                scale = 1
            }
        } else {
            withAnimation(.easeOut(duration: 0.1)) {
                scale = 0.0001
                opacity = 0
            }
        }
    }
}


struct AlertModifier: ViewModifier {
    
    @Binding var presentingView: AnyView?
    
    var isPresented: Binding<Bool> {
        Binding( get: { self.presentingView != nil },
                 set: { if !$0 { self.presentingView = nil } })
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                wrappedPresentingView
            }
    }
    
    @ViewBuilder
    var wrappedPresentingView: some View {
        if isPresented.wrappedValue {
            presentingView?.modifier(CustomAlertViewModifier())
        } else {
            EmptyView()
        }
        
    }
}
