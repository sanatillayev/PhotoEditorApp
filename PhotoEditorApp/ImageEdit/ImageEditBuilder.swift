//
//  ImageEditBuilder.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import SwiftUI

final class ImageEditBuilder {
    static func createImageEditorScreen(
        with modules: AnyModules,
        presentationType: Binding<Bool>
    ) -> ImageEditorView {
        let viewModel = ImageEditorViewModel()
        let scene = ImageEditorView(viewModel: viewModel)
        return scene
    }
}
