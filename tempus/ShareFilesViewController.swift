//
//  ShareFilesViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase
import FileBrowser

class ShareFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var group: Group? {
        didSet {
            observeDownloadFiles()
        }
    }
    var flag = false
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 26))
        label.font = UIFont(name: "GothamRounded-Bold", size: 24)
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        return label
    }()
    
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let sectionUploadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let sectionDownloadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    lazy var downloadTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_file")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .white
        return imageView
    }()
    
    lazy var uploadButton: DeformationButton = {
        let button = DeformationButton(frame: CGRect(x: 0, y: 0, width: 160, height: 28) , color: UIColor.makeViaRgb(red: 80, green: 227, blue: 194))
        button.tintColor = .white
        button.forDisplayButton.setTitle("업로드", for: .normal)
        button.forDisplayButton.setTitleColor(.white, for: .normal)
        button.forDisplayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    let filenameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.text = "파일을 클릭하여 선택"
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
    
    let uploadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "파일 업로드"
        return label
    }()
    
    let downloadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "파일 다운로드"
        return label
    }()
    
    func mainPanelTapped() {
        present(fileBrowser, animated: true, completion: nil)
    }
    
    lazy var fileBrowser: FileBrowser = {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory ,.userDomainMask, true)[0] as String
        let filePath = URL(string: dirPath)
        let fb = FileBrowser(initialPath: filePath!)
    
        fb.didSelectFile = { (file: FBFile) -> Void in
            self.fileInfo = file
            self.filenameLabel.text = file.displayName
            self.filesizeLabel.text = "\(file.fileAttributes?[FileAttributeKey.size] ?? "") bytes"
            self.fileExtLabel.text = file.fileExtension
        }
        return fb
    }()
    
    func uploadButtonTapped() {
        flag = !flag
        self.uploadButton.isLoading = flag
        percentLabel.isHidden = !flag
        uploadFile()
    }
    
    var fileInfo: FBFile?
    
    func uploadFile() {
        if let fileInfo = self.fileInfo, let group = self.group {
            FirebaseDataService.instance.groupRef.child(group.key).child(Constants.Group.fileDir).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? String {
                    let riversRef = STORAGE_BASE.child("\(value)/\(fileInfo.displayName)")
                    // Upload the file to the path "images/rivers.jpg"
                    let uploadTask = riversRef.putFile(fileInfo.filePath, metadata: nil) { metadata, error in
                        if (error != nil) {
                            // Uh-oh, an error occurred!
                        } else {
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                let ref = FirebaseDataService.instance.groupRef.child(group.key).child(Constants.Group.fileUrls).childByAutoId()
                                ref.setValue([
                                    Constants.Group.FileUrls.fileName: fileInfo.displayName,
                                    Constants.Group.FileUrls.fileUrl: downloadURL,
                                    Constants.Group.FileUrls.fileSize: fileInfo.fileAttributes?[FileAttributeKey.size],
                                    Constants.Group.FileUrls.fileExt: fileInfo.fileExtension
                                ])
                            }
                        }
                    }
                    uploadTask.observe(.progress) { snapshot in
                        // Upload reported progress
                        if let progress = snapshot.progress {
                            let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                            self.percentLabel.text = "\(round(percentComplete))%"
                        }
                    }
                    uploadTask.observe(.success) { snapshot in
                        uploadTask.removeAllObservers()
                        self.percentLabel.text = "완료"
                        self.uploadButton.isLoading = false
                        self.observeDownloadFiles()
                    }
                }
            })
        } else {
            self.percentLabel.text = "실패"
            self.uploadButton.isLoading = false
        }
    }
    var fileInfos = [FileInfo]()
    
    func observeDownloadFiles() {
        self.fileInfos.removeAll()
        if let group = self.group {
            FirebaseDataService.instance.groupRef.child(group.key).child(Constants.Group.fileUrls).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                    for (key, one) in dict {
                        if let data = one as? Dictionary<String, AnyObject> {
                            let file = FileInfo(key: key, data: data)
                            self.fileInfos.append(file)
                        }
                    }
                }
                self.percentLabel.text = "0%"
                DispatchQueue.main.async(execute: { 
                    self.downloadTableView.reloadData()
                })
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func setNavigationBarUI() {
        self.navigationItem.title = ""
        navigationItem.titleView = titleLabel
    }
    
    fileprivate func addSubViews() {
        view.addSubview(sectionUploadView)
        view.addSubview(mainImageView)
        view.addSubview(filenameLabel)
        view.addSubview(filesizeLabel)
        view.addSubview(percentLabel)
        view.addSubview(uploadButton)
        view.addSubview(fileExtLabel)
        view.addSubview(dividerView)
        view.addSubview(sectionDownloadView)
        view.addSubview(downloadTableView)
        view.addSubview(uploadLabel)
        view.addSubview(downloadLabel)
    }
    
    fileprivate func setConstraints() {
        _ = sectionUploadView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = mainImageView.anchor(sectionUploadView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 84)
        
        _ = fileExtLabel.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: mainImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 24, rightConstant: 6, widthConstant: 44, heightConstant: 24)
        
        _ = filenameLabel.anchor(sectionUploadView.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 28)
        
        _ = filesizeLabel.anchor(filenameLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 240, heightConstant: 20)
        
        _ = uploadButton.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 160, heightConstant: 28)
        
        _ = percentLabel.anchor(uploadButton.topAnchor, left: uploadButton.centerXAnchor, bottom: uploadButton.bottomAnchor, right: nil, topConstant: 0, leftConstant: 28, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = dividerView.anchor(mainImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionDownloadView.anchor(dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = downloadTableView.anchor(sectionDownloadView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = uploadLabel.anchor(sectionUploadView.topAnchor, left: sectionUploadView.leftAnchor, bottom: sectionUploadView.bottomAnchor, right: sectionUploadView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = downloadLabel.anchor(sectionDownloadView.topAnchor, left: sectionDownloadView.leftAnchor, bottom: sectionDownloadView.bottomAnchor, right: sectionDownloadView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        downloadTableView.register(FileInfoCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FileInfoCell
        cell.fileInfo = fileInfos[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
