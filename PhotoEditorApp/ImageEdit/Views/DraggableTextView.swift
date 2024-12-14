//
//  DraggableTextView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 13/12/24.
//

import SwiftUI

struct DraggableTextView: View {
    @Binding var text: String
    @Binding var position: CGPoint
    @Binding var color: Color
    @Binding var fontSize: CGFloat
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: fontSize))
            .foregroundColor(color)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
//            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//            .padding()
            .offset(x: position.x, y: position.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        position = value.location
                    }
            )
    }
}
