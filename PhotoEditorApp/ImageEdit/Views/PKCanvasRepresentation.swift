//
//  PKCanvasRepresentation.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 13/12/24.
//

import SwiftUI
import PencilKit

struct PKCanvasRepresentation: UIViewRepresentable {
    var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
