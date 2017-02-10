//
//  ViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    
    struct MeetingListData {
        static let selfDevelopmentCellId = ""
        static let preparingTestCellId = ""
        static let professionalCellId = ""
        static let hobbyCellId = ""
    }
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.textAlignment = .center
        label.text = "tempus"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func searchButtonTapped() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = .red
        //navigationController?.navigationBar.isTranslucent = false
        
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
        
        collectionView?.backgroundColor = UIColor.white
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.titleView = titleLabel
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    fileprivate func cellCollectionViewUI() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        
    }
    
    fileprivate func addSubViews() {
        
    }
    
    fileprivate func setConstraints() {
        _ = collectionView?.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MeetingListData.selfDevelopmentCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MeetingListData.preparingTestCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MeetingListData.professionalCellId)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MeetingListData.hobbyCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 9 / 16)
    }
}

