//
//  MessageGallery.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import SwiftUI
import PhotosUI

struct MessageGallery: UIViewControllerRepresentable {
    
    let action: ((String, String) -> Void)
    
    func makeCoordinator() -> Coordinator {
        return MessageGallery.Coordinator( parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MessageGallery
        
        init( parent: MessageGallery) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if !results.isEmpty {
                
                for media in results {
                    
                    let itemProvider = media.itemProvider
                    
                    guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                          let utType = UTType(typeIdentifier)
                    else { continue }
                    
                    if utType.conforms(to: .image) {
                        self.getPhoto(from: itemProvider)
                    } else if utType.conforms(to: .movie) {
                        self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
                    }  else {
                        self.getPhoto(from: itemProvider)
                    }

                    DispatchQueue.main.async {
                        picker.dismiss()
                    }
                }
                
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (img, error) in
                    if let uiimage = img as? UIImage {
                        if let imageData = uiimage.jpegData(compressionQuality: 0.4) {
                            DispatchQueue.main.async {
                                self.parent.action("photo", imageData.base64EncodedString())
                            }
                        }
                    }
                }
            }
        }
        
        private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let url = url else { return }
                
                if let data = try? Data(contentsOf: URL(fileURLWithPath: url.path)) {
                    DispatchQueue.main.async {
                        self.parent.action("video", data.base64EncodedString())
                    }
                }
            }
        }
    }
}
