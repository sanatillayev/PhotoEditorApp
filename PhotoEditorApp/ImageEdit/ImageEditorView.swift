//
//  ImageEditorView.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI

struct ImageEditorView: View {
    @StateObject var viewModel = ImageEditorViewModel()
    @State private var showingImagePicker = false
    @State private var isAlertPresenting = false
    @State private var isDrawingEnabled = false
    @State private var rotationAngle: Double = 0.0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            if let image = viewModel.image {
                imageView(for: image)
            } else {
                imagePlaceholderView()
            }
            buttonsView()
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { selectedImage in
                viewModel.image = selectedImage
            }
        }
        .alert(isPresented: $isAlertPresenting) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? ""))
        }
    }
    
    private func imageView(for image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotationAngle))
            .overlay(
                GeometryReader { geometry in
                    SaveAreaMask(
                        size: geometry.size,
                        saveRect: getSaveRectangle(for: geometry.size)
                    )
                }
            )
            .overlay(
                PKCanvasRepresentation(canvasView: viewModel.canvasView)
                    .opacity(isDrawingEnabled ? 1.0 : 0.0)
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                    }
            )
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        rotationAngle = value.degrees
                    }
            )
    }
    
    private func imagePlaceholderView() -> some View {
        ZStack {
            Rectangle()
                .frame(width: 200, height: 200)
                .foregroundColor(.gray)
            Text("No Image Selected")
                .foregroundColor(.white)
        }
    }
    
    private func buttonsView() -> some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.loadImage(from: .camera)
                }) {
                    Text("Take Photo")
                }
                Button(action: {
                    viewModel.loadImage(from: .photoLibrary)
                }) {
                    Text("Select Image")
                }
                
                Button(action: {
                    if let image = viewModel.image {
                        viewModel.saveTransformedImage(image: image, rotationAngle: rotationAngle, scale: scale, canvasView: viewModel.canvasView)
                    }
                }) {
                    Text("Save Image")
                }
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    scale = 1.0
                    rotationAngle = 0.0
                }) {
                    Text("Reset")
                }
            }
            
            Slider(value: $rotationAngle, in: -180...180, step: 1) {
                Text("Rotation (\(Int(rotationAngle))°)")
                    .foregroundStyle(.txtPrimary)
            }
            
            Slider(value: $scale, in: 0.5...2.0, step: 0.1) {
                Text("Scale (\(String(format: "%.1f", scale))x)")
            }
            
            Toggle("Enable Drawing", isOn: $isDrawingEnabled)
                .padding()
        }
    }
    
    private func getSaveRectangle(for size: CGSize) -> CGRect {
        let saveWidth: CGFloat = 200
        let saveHeight: CGFloat = 300
        let x: CGFloat = (size.width - saveWidth) / 2
        let y: CGFloat = (size.height - saveHeight) / 2
        return CGRect(x: x, y: y, width: saveWidth, height: saveHeight)
    }
}
