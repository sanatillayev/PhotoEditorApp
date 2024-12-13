//
//  ProgressView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI

extension View {
    func progressView(isShowing: Binding<Bool>) -> some View {
        ZStack {
            self
                .blur(radius: isShowing.wrappedValue ? 3 : 0)

            if isShowing.wrappedValue {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
        }
    }
}
