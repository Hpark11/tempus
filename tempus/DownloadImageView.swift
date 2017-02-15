//
//  downloadImageView.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

import UIKit

class DownloadImageView : UIImageView {
    
    var imageUrlString: String? {
        didSet {
            if let imageUrlString = imageUrlString {
                loadImageUsingUrlString(urlString: imageUrlString)
            }
        }
    }
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                self.image = imageToCache
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            })
        }).resume()
    }
}
