//
//  FieldView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import SwiftUI
import Combine

private enum Constants {
    static let vSpacing: CGFloat = 8.0
    static let titleFont = Font.system(size: 13.0, weight: .regular)
    static let fieldFont = Font.system(size: 17.0, weight: .regular)
    static let padding: CGFloat = 12.0
    static let cornerRadius: CGFloat = 8.0
    static let hOffset: CGFloat = 16.0
    static let hSpacing: CGFloat = 4.0
    static let fieldHeight: CGFloat = 44
    static let textVPadding: CGFloat = 11.0
}

struct FieldView<Trailing>: View where Trailing: View {

    private let title: String
    private let placeholder: String
    private let axis: Axis
    private let caption: String?
    private let trailingContent: (() -> Trailing)?
    @Binding var text: String
    
    init(
        title: String,
        text: Binding<String>,
        placeholder: String = "",
        caption: String? = nil,
        axis: Axis = .horizontal
    ) where Trailing == EmptyView {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.caption = caption
        self.axis = axis
        self.trailingContent = nil
    }
    
    init(
        title: String,
        text: Binding<String>,
        placeholder: String = "",
        caption: String? = nil,
        @ViewBuilder trailingContent: @escaping () -> Trailing
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.caption = caption
        self.axis = .horizontal
        self.trailingContent = trailingContent
    }
    
    private var textLimit: Int {
        axis == .vertical ? 10000 : 250
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
            Text(title)
                .font(Constants.titleFont)
                .foregroundColor(Color.txtSecondary)
            
            HStack(alignment: .center, spacing: Constants.hSpacing) {
                textField
                    .padding(.vertical, Constants.textVPadding)
                trailingContent?()
            }
            .frame(height: Constants.fieldHeight)
            .background(Color.bgPrimary)
            .cornerRadius(Constants.cornerRadius)

            if let caption {
                Text(caption)
                    .font(Constants.titleFont)
                    .foregroundColor(Color.txtSecondary)
            }
        }
        .padding(.horizontal, Constants.hOffset)
    }
    
    var textField: some View {
        TextField(placeholder, text: limitedTextBinding, axis: axis)
            .font(Constants.fieldFont)
            .foregroundColor(.txtPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    private var limitedTextBinding: Binding<String> {
        Binding {
            self.text
        } set: { newText in
            if newText.count <= textLimit {
                self.text = newText
            }
        }
    }
}
