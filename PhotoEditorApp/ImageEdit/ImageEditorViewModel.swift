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

class ImageEditorViewModel: NSObject, ObservableObject {
    @Published var image: UIImage?
    @Published var canvasView: PKCanvasView = PKCanvasView()
    @Published var error: String?
    
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
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.error = error.localizedDescription
        } else {
            // handle successful save
        }
    }
    
    func saveDrawing() {
        let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 0)
        if let markedupImage = saveImage(drawing: drawing){
            UIImageWriteToSavedPhotosAlbum(markedupImage, self, #selector(saveError), nil)
        }
    }
    
    func saveImage(drawing : UIImage) -> UIImage? {
        let bottomImage = image
        let newImage = autoreleasepool { () -> UIImage in
            UIGraphicsBeginImageContextWithOptions(canvasView.frame.size, false, 0.0)
            bottomImage?.draw(in: CGRect(origin: CGPoint.zero, size: canvasView.frame.size))
            drawing.draw(in: CGRect(origin: CGPoint.zero, size: canvasView.frame.size))
            let createdImage = UIGraphicsGetImageFromCurrentImageContext()
            return createdImage ?? .remove
        }
        return newImage
    }
    
    func saveTransformedImage(image: UIImage, rotationAngle: CGFloat, scale: CGFloat, canvasView: PKCanvasView) {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let transformedImage = renderer.image { context in
            context.cgContext.translateBy(x: image.size.width / 2, y: image.size.height / 2)
            context.cgContext.rotate(by: rotationAngle * .pi / 180)
            context.cgContext.scaleBy(x: scale, y: scale)
            context.cgContext.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
            
            image.draw(at: .zero)
            let canvasDrawing = canvasView.drawing.image(from: canvasView.bounds, scale: image.scale)
            canvasDrawing.draw(in: CGRect(origin: .zero, size: image.size))
        }
        
        UIImageWriteToSavedPhotosAlbum(transformedImage, self, #selector(saveError), nil)
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
