//
//  ActionButton.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import Foundation
import SwiftUI

private enum Constants{
    static let color = Color.txtPrimary
    static let font = Font.system(size: 17)
    static let vOffset: CGFloat = 13.0
}

struct ActionButton: View {
    
    private let title: String
    @Binding var isEnabled: Bool
    private let action: () -> Void

    init(
        title: String,
        isEnabled: Binding<Bool>,
        action: @escaping () -> Void
    ) {
        self.title = title
        self._isEnabled = isEnabled
        self.action = action
    }
    
    @ViewBuilder
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(Constants.font)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.bgPrimary)
            .padding(.vertical, Constants.vOffset)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primary)
            )
            .padding(.horizontal)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.3)
    }
}
