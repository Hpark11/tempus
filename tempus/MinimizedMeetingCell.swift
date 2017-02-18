//
//  MinimizedMeetingCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class MinimizedMeetingCell: BaseCell {

    var meeting: MinimizedMeeting? {
        didSet {
            if let name = meeting?.title, let category = meeting?.category {
                titleLabel.text = name
                categoryLabel.text = category
            }
            
            if let imageUrl = meeting?.imageUrl {
                imageView.imageUrlString = imageUrl
            }
        }
    }
    
    let imageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "frozen")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney Build It: Frozen"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    
    func setImageFromFirebaseStorageWithUrl(imageUrl: String) {
        let ref = FIRStorage.storage().reference(forURL: imageUrl)
        ref.data(withMaxSize: 6 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print(":::[HPARK] Unable to Download image from Storage \(String(describing: error)):::")
            } else {
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        self.imageView.image = image
                        imageCache.setObject(image, forKey: imageUrl as NSString)
                    }
                }
            }
        })
    }
    
    override func setupViews() {
        super.setupViews()
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(categoryLabel)
    }
    
    fileprivate func setConstraints() {
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        titleLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 38 , width: frame.width, height: 20)
    }
}
