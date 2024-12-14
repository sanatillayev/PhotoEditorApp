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
    
    var body: some View {
        ScrollView {
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
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { selectedImage in
                viewModel.image = selectedImage
            }
        }
        .alert(isPresented: $isAlertPresenting) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? ""))
        }
        .progressView(isShowing: Binding(get: { viewModel.isLoading }, set: { viewModel.isLoading = $0 }))
    }
    
    private func imageView(for image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .scaleEffect(viewModel.scale)
            .rotationEffect(.degrees(viewModel.rotationAngle))
            .overlay(
                GeometryReader { geometry in
                    let saveAreaSize = geometry.size
                    SaveAreaMask(
                        size: saveAreaSize,
                        saveRect: getSaveRectangle(for: saveAreaSize)
                    )
                    .overlay {
                        if viewModel.isWritingEnabled {
                            DraggableTextView(
                                text: Binding(
                                    get: { viewModel.addedText },
                                    set: { viewModel.addedText = $0 }
                                ),
                                position: Binding(
                                    get: { constrainedPosition(for: viewModel.textPosition, in: saveAreaSize) },
                                    set: { viewModel.textPosition = $0 }
                                ),
                                color: Binding(
                                    get: { viewModel.textColor },
                                    set: { viewModel.textColor = $0 }
                                ),
                                fontSize: Binding(
                                    get: { viewModel.textSize },
                                    set: { viewModel.textSize = $0 }
                                )
                            )
                        }
                    }
                }
            )
            .overlay(
                PKCanvasRepresentation(canvasView: viewModel.canvasView)
                    .opacity(viewModel.isDrawingEnabled ? 1.0 : 0.0)
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        viewModel.scale = value
                    }
            )
            .gesture(
                RotationGesture()
                    .onChanged { value in
                        viewModel.rotationAngle = value.degrees
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
                    viewModel.saveTransformedImage()
                }) {
                    Text("Save Image")
                }
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.scale = 1.0
                    viewModel.rotationAngle = 0.0
                }) {
                    Text("Reset")
                }
            }
            VStack {
                Text("Rotation (\(Int(viewModel.rotationAngle))°)")
                    .foregroundStyle(.txtPrimary)
                    .font(.caption)

                Slider(value: Binding(get: { viewModel.rotationAngle }, set: { viewModel.rotationAngle = $0 }), in: -180...180, step: 1) {
                    Text("Rotation (\(Int(viewModel.rotationAngle))°)")
                        .foregroundStyle(.txtPrimary)
                }
            }
            VStack {
                Text("Scale (\(String(format: "%.1f", viewModel.scale))x)")
                    .foregroundStyle(.txtPrimary)
                    .font(.caption)
                Slider(value: Binding(
                    get: { viewModel.scale },
                    set: { viewModel.scale = $0 }),
                       in: 0.5...2.0, step: 0.1) {
                    Text("Scale (\(String(format: "%.1f", viewModel.scale))x)")
                }
            }
            
            Toggle("Enable Drawing", isOn: Binding(get: { viewModel.isDrawingEnabled }, set: { viewModel.isDrawingEnabled = $0 }))
                .padding()
            
            Toggle("Enable Writing", isOn: Binding(get: { viewModel.isWritingEnabled }, set: { viewModel.isWritingEnabled = $0 }))
                .padding()
            
            textControlView()
            
            HStack(spacing: 16) {
                Button("Apply Sepia") {
                    viewModel.applyFilter(filterName: "CISepiaTone")
                }
                Button("Apply Blur") {
                    viewModel.applyFilter(filterName: "CIGaussianBlur")
                }
                Button("Reset Image") {
                    viewModel.resetImage()
                }
            }
        }
    }
    
    private func textControlView() -> some View {
        VStack {
            if viewModel.isWritingEnabled {
                TextField("Enter Text", text: Binding(get: { viewModel.addedText }, set: { viewModel.addedText = $0 }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    Text("Font Size")
                    Slider(value: Binding(get: { viewModel.textSize }, set: { viewModel.textSize = $0 }), in: 10...100)
                }
                
                HStack {
                    Text("Font Color")
                    ColorPicker("", selection: Binding(get: { viewModel.textColor }, set: { viewModel.textColor = $0 }))
                        .frame(width: 50)
                }
                
            }
        }
        .padding()
    }
    
    private func getSaveRectangle(for size: CGSize) -> CGRect {
        let saveWidth: CGFloat = 200
        let saveHeight: CGFloat = 300
        let x: CGFloat = (size.width - saveWidth) / 2
        let y: CGFloat = (size.height - saveHeight) / 2
        return CGRect(x: x, y: y, width: saveWidth, height: saveHeight)
    }
    
    private func constrainedPosition(for position: CGPoint, in saveAreaSize: CGSize) -> CGPoint {
        let maxX = saveAreaSize.width
        let maxY = saveAreaSize.height
        
        return CGPoint(
            x: min(max(position.x, 0), maxX),
            y: min(max(position.y, 0), maxY)
        )
    }
}
