//
//  ImagePicker.swift
//  Notes
//
//  Created by apple on 02/09/19.
//  Copyright © 2019 Swiftter. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    /// MARK:
    /// This method is responsible for Preseting the image with ImagePickerDelegate
    ///
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    /// MARK:
    /// This method is responsible for Performing tht action for  Image selection from Action Sheet
    ///
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    /// MARK:
    /// This method is responsible for Preseting the image in source view
    ///
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take a new photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Use existing photo") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelHandler(alert:)))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func cancelHandler(alert: UIAlertAction!) {
        self.delegate?.didSelect(image: nil)
    }
    
    /// MARK:
    /// This method is responsible ImagePicker delegate method
    ///
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
    
    public func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "image001.png" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 0.75){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
   public func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
    
    
}

/// MARK:
/// UIImagePickerControllerDelegate
///
extension ImagePicker: UIImagePickerControllerDelegate {
    
    /// MARK:
    /// This method is responsible for cancel the user action imagePickerControllerDidCancel
    ///
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    /// MARK:
    /// This method is responsible for picking image from didFinishPickingMediaWithInfo
    ///
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}


