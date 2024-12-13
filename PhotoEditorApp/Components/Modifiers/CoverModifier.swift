//
//  CoverModifier.swift
//  CleanSwiftUI
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

struct CoverModifier: ViewModifier {

    @Binding var presentingView: AnyView?

    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: Binding(get: { self.presentingView != nil },
                                                     set: { if !$0 { self.presentingView = nil }}),
                             content: { self.presentingView })
    }
}
