//
//  ShareFilesViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit




class ShareFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    
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
    
    lazy var mainImageView: DownloadImageView = {
        let imageView = DownloadImageView()
        imageView.image = UIImage(named: "placeholder1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainPanelTapped)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        return textView
    }()

    lazy var downloadTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //let deformationBtn = DeformationButton(frame: CGRectMake(100, 100, 140, 36), color: getColor("e13536"))
    //self.view.addSubview(deformationBtn)
    //
    //deformationBtn.forDisplayButton.setTitle("微博注册", forState: UIControlState.Normal)
    //deformationBtn.forDisplayButton.titleLabel?.font = UIFont.systemFontOfSize(15);
    //deformationBtn.forDisplayButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    //deformationBtn.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
    //deformationBtn.forDisplayButton.setImage(UIImage(named:"微博logo.png"), forState: UIControlState.Normal)
    //
    //deformationBtn.addTarget(self, action: "btnEvent", forControlEvents: UIControlEvents.TouchUpInside)
    
    lazy var uploadButton: DeformationButton = {
    
        let button = DeformationButton(frame: CGRect(x: 0, y: 0, width: 220, height: 36) , color: UIColor.makeViaRgb(red: 74, green: 144, blue: 226))
        button.tintColor = .white
        button.forDisplayButton.setTitle("업로드", for: .normal)
        button.forDisplayButton.setImage(UIImage(named: "icon upload"), for: .normal)
        button.forDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
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
        label.text = "시험용 텍스트입니다"
        return label
    }()
    
    let filesizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "시험용 텍스트입니다"
        return label
    }()
    
    func mainPanelTapped() {
        
    }
    
    func uploadButtonTapped() {
        uploadButton.isLoading = true
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
        view.addSubview(uploadButton)
        view.addSubview(dividerView)
        view.addSubview(sectionDownloadView)
        view.addSubview(downloadTableView)
    }
    
    fileprivate func setConstraints() {
        _ = sectionUploadView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = mainImageView.anchor(sectionUploadView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 84)
        
        _ = filenameLabel.anchor(sectionUploadView.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 28)
        
        _ = filesizeLabel.anchor(filenameLabel.bottomAnchor, left: mainImageView.rightAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 240, heightConstant: 20)
        
        _ = uploadButton.anchor(nil, left: nil, bottom: mainImageView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 160, heightConstant: 32)
        
        _ = dividerView.anchor(mainImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = sectionDownloadView.anchor(dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 32)
        
        _ = downloadTableView.anchor(sectionDownloadView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        downloadTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
