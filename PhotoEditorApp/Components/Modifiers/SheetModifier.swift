//
//  WellnessApp.swift
//  Wellness
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

struct SheetModifier: ViewModifier {

    @Binding var presentingView: AnyView?

    func body(content: Content) -> some View {
        content.sheet(isPresented: Binding( get: { self.presentingView != nil },
                                            set: { if !$0 { self.presentingView = nil }})) { self.presentingView }
    }
}
