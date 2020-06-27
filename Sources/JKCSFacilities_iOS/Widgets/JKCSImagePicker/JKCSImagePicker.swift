//
//  ImagePickerView.swift
//  ImagePickerSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-24.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import SwiftUI

public struct JKCSImagePicker: UIViewControllerRepresentable {
    
    let sourceType: UIImagePickerController.SourceType
    
    public init(sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = sourceType
    }
    
    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: JKCSImagePicker
        
        public init(_ imagePickerController: JKCSImagePicker) {
            self.parent = imagePickerController
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // let imageOrientation = uiImage.imageOrientation // photos taken by camera usually do not have a correct imageOrientation
                if let uiImageAdjusted = uiImage.upOrientationImage() {
                    let image = Image(uiImage: uiImageAdjusted)
                    NotificationCenter.default.post(name: .JKCSImagePickerDidPickImage, object: image)
                }
            }
            picker.dismiss(animated: true)
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
