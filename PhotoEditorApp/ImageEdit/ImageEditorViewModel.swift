//
//  ImageEditorViewModel.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 12/12/24.
//

import SwiftUI
import Combine
import PencilKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageEditorViewModel: NSObject, ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    @Published var canvasView: PKCanvasView = PKCanvasView()
    @Published var error: String?
    
    @Published var addedText = "Text"
    @Published var textPosition: CGPoint = .zero
    @Published var textColor: Color = .black
    @Published var textSize: CGFloat = 20.0
    @Published var isWritingEnabled = false
    @Published var isDrawingEnabled = false

    @Published var rotationAngle: Double = 0.0
    @Published var scale: CGFloat = 1.0

    private let context = CIContext()
    private var originalImage: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        $canvasView
            .sink { [weak self] canvasView in
                self?.setupCanvasView(canvasView)
            }
            .store(in: &cancellables)
    }
    
    private func setupCanvasView(_ canvasView: PKCanvasView?) {
        guard let canvasView = canvasView else { return }
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
    }
    
    // MARK: - Image Handling
    func loadImage(from sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController?.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.error = error.localizedDescription
        } else {
            print("Save successful!")
        }
    }
    
    func saveTransformedImage() {
        isLoading = true
        guard let baseImage = image else {
            isLoading = false
            return
        }
        let format = UIGraphicsImageRendererFormat()
        format.scale = baseImage.scale
        let renderer = UIGraphicsImageRenderer(size: baseImage.size, format: format)
        
        let transformedImage = renderer.image { context in
            let cgContext = context.cgContext
            
            cgContext.translateBy(x: baseImage.size.width / 2, y: baseImage.size.height / 2)
            cgContext.rotate(by: rotationAngle * .pi / 180)
            cgContext.scaleBy(x: scale, y: scale)
            cgContext.translateBy(x: -baseImage.size.width / 2, y: -baseImage.size.height / 2)
            
            baseImage.draw(at: .zero)
            
            if isDrawingEnabled {
                let canvasDrawing = canvasView.drawing.image(from: canvasView.bounds, scale: baseImage.scale)
                canvasDrawing.draw(in: CGRect(origin: .zero, size: baseImage.size))
            }
            if isWritingEnabled, !addedText.isEmpty {
                let scaledTextPosition = CGPoint(
                    x: textPosition.x + baseImage.size.width / 2,
                    y: textPosition.y + baseImage.size.height / 2
                )
                
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: textSize * baseImage.size.width / canvasView.bounds.width),
                    .foregroundColor: UIColor(textColor)
                ]
                
                let attributedString = NSAttributedString(string: addedText, attributes: textAttributes)
                
                let textSize = attributedString.size()
                let textRect = CGRect(
                    origin: CGPoint(
                        x: scaledTextPosition.x - textSize.width / 2,
                        y: scaledTextPosition.y - textSize.height / 2
                    ),
                    size: textSize
                )
                attributedString.draw(in: textRect)
            }
        }
        
        UIImageWriteToSavedPhotosAlbum(transformedImage, self, #selector(saveError), nil)
        isLoading = false
    }
    
    func applyFilter(filterName: String) {
        guard let ciImage = CIImage(image: image ?? UIImage()) else { return }
        guard let filter = CIFilter(name: filterName) else { return }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            image = UIImage(cgImage: cgImage)
        }
    }
    
    func resetImage() {
        image = originalImage
    }
    
    func saveOriginalImage() {
        originalImage = image
    }
}

extension ImageEditorViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
