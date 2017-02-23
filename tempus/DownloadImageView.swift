//
//  downloadImageView.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

import UIKit

class DownloadImageView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    let imageView = UIImageView()
    var imageUrlString: String? {
        didSet {
            if let imageUrlString = imageUrlString {
                loadImageUsingUrlString(urlString: imageUrlString)
            }
        }
    }
    
    func loadImageUsingUrlString(urlString: String) {
        let url: URL? = URL(string: urlString)
        imageView.image = nil
        
        if let url = url {
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                self.imageView.image = imageFromCache
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard error == nil else {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    let imageToCache = UIImage(data: data!)
                    self.imageView.image = imageToCache
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                })
            }).resume()
        }
    }
}
