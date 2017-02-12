//
//  MeetingAddViewController_ext.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

extension MeetingAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // present image picker
    func presentImagePickerController(_ source: UIImagePickerControllerSourceType, imgTag: Int) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        if imgTag != 0 {
            imagePickerController.allowsEditing = true
        }
        self.imgTag = imgTag
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // after finished picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if imgTag == 0 {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                mainImage = image
            }
        } else if imgTag == 1 {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                detailImage = image
            }
        } else {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                subImages[imgTag - 2] = image
            }
        }
        collectionView?.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    // cancel button tapped
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


