//
//  AuthGallery.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import Foundation
import SwiftUI
import PhotosUI

struct AuthGallery: UIViewControllerRepresentable {
    
    @Binding var model: RegistrationRequest
    
    func makeCoordinator() -> Coordinator {
        return AuthGallery.Coordinator( parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: AuthGallery
        
        init( parent: AuthGallery) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                
                for media in results {
                    
                    let itemProvider = media.itemProvider
                    self.getPhoto(from: itemProvider, resultCount: results.count)


                    DispatchQueue.main.async {
                        picker.dismiss()
                    }
                }
                
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider, resultCount: Int) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (img, error) in
                    if let uiimage = img as? UIImage {
                        if let imageData = uiimage.jpegData(compressionQuality: 0.4) {
                            DispatchQueue.main.async {
                                self.parent.model.images.append(imageData.base64EncodedString())
                            }
                        }
                    }
                }
            }
        }
    }
}
