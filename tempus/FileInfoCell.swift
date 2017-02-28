//
//  FileInfoCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 23..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
class FileInfoCell: UITableViewCell {
    
    var fileInfo: FileInfo? {
        didSet {
            if let fileInfo = self.fileInfo {
                filenameLabel.text = fileInfo.fileName
                fileExtLabel.text = fileInfo.fileExt
                filesizeLabel.text = "\(fileInfo.fileSize) bytes"
            }
        }
    }
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_file")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var downloadButton: DeformationButton = {
        let button = DeformationButton(frame: CGRect(x: 0, y: 0, width: 160, height: 28) , color: UIColor.makeViaRgb(red: 80, green: 227, blue: 194))
        button.tintColor = .white
        button.forDisplayButton.setTitle("다운로드", for: .normal)
        button.forDisplayButton.setTitleColor(.white, for: .normal)
        button.forDisplayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    func downloadButtonTapped() {
        if let fileInfo = self.fileInfo {
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory ,.userDomainMask, true)[0] as String
            let filePath = URL(string: "\(dirPath)/\(fileInfo.fileName)")
            let ref = FIRStorage.storage().reference(forURL: fileInfo.fileUrl)

            guard let fullPath = filePath else {
                return
            }
            let downloadTask = ref.write(toFile: fullPath)
            
            downloadTask.observe(.progress) { (snapshot) -> Void in
                // Download reported progress
                if let progress = snapshot.progress {
                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                    self.percentLabel.text = "\(round(percentComplete))%"
                }
            }
            
            downloadTask.observe(.success) { (snapshot) -> Void in
                // Download completed successfully
                self.percentLabel.text = "완료"
                downloadTask.removeAllObservers()
            }
            
            // Errors only occur in the "Failure" case
            downloadTask.observe(.failure) { (snapshot) -> Void in
                downloadTask.removeAllObservers()
                self.percentLabel.text = "실패"
                self.downloadButton.isLoading = false
            }
        } else {
            self.percentLabel.text = "실패"
            self.downloadButton.isLoading = false
        }
    }
    
    let filenameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    let filesizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = ""
        return label
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Medium", size: 16)
        label.textAlignment = .left
        label.text = "0%"
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    let fileExtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GothamRounded-Medium", size: 16)
        label.backgroundColor = .black
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.text = ""
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubViews() {
        addSubview(mainImageView)
        addSubview(filenameLabel)
        addSubview(filesizeLabel)
        addSubview(percentLabel)
        addSubview(downloadButton)
        addSubview(fileExtLabel)
    }
    
    fileprivate func setConstraints() {
        _ = mainImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 84)
        
        _ = fileExtLabel.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: mainImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 24, rightConstant: 6, widthConstant: 44, heightConstant: 24)
        
        _ = filenameLabel.anchor(topAnchor, left: mainImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 28)
        
        _ = filesizeLabel.anchor(filenameLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 240, heightConstant: 20)
        
        _ = downloadButton.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 160, heightConstant: 28)
        
        _ = percentLabel.anchor(downloadButton.topAnchor, left: downloadButton.centerXAnchor, bottom: downloadButton.bottomAnchor, right: nil, topConstant: 0, leftConstant: 28, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    }
}
