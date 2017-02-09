//
//  MeetingViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MeetingViewController: UICollectionViewController {

    public struct MeetingMainData {
        static let topPanelCellId = "topPanelCellId"
        static let bottomPanelCellId = "bottomPanelCellId"
    }
    
    /*
     *  UI Components
     */
    lazy var topPanelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
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
    
    /*
     *  UI Actions
     */
    func searchButtonTapped() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView?.backgroundColor = .lightGray
        
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
    }
    
    fileprivate func setNavigationBarUI() {
        navigationItem.titleView = titleLabel
        
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    fileprivate func addSubViews() {
        view.addSubview(topPanelCollectionView)
    }
    
    fileprivate func setConstraints() {
        _ = topPanelCollectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 3.2).first
        
        _ = self.collectionView?.anchor(topPanelCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: -64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
    fileprivate func registerCells() {
        topPanelCollectionView.register(MeetingViewTopPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.topPanelCellId)
        collectionView?.register(MeetingViewBottomPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.bottomPanelCellId)
    }
    
    
    

   
    
//    var appCategories: [AppCategory]?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        appCategories = AppCategory.sampleAppCategories()
//        
//        collectionView?.backgroundColor = .white
//        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = appCategories?.count {
//            return count
//        }
//        return 0
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
//        
//        cell.appCategory = appCategories?[indexPath.item]
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 230)
//    }

}
