//
//  LoadingView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

private enum Constants {
    static let spacing: CGFloat = 8.0
    static let font = Font.system(size: 16.0)
}

struct LoadingView: View {

    let text: String
    let color: Color

    init(text: String, color: Color = .accentColor) {
        self.text = text
        self.color = color
    }

    var body: some View {
        HStack(spacing: Constants.spacing) {
            ProgressView() .tint(color)
            Text(text)
                .font(Constants.font)
                .foregroundColor(color)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .edgesIgnoringSafeArea(.all)
        .transition(.opacity)
    }
}

extension LinearGradient {

    static var baseGradient: Self = {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color.gray, location: .zero),
                Gradient.Stop(color: Color.white, location: 1.0),
            ],
            startPoint: .zero,
            endPoint: UnitPoint(x: 1.0, y: 1.0)
        )
    }()
}
