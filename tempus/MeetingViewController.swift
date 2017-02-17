//
//  MeetingViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 8..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class MeetingViewController: UICollectionViewController {

    internal struct MeetingMainData {
        static let topContents: [MeetingTopPanelContent] = {
            return [
                MeetingTopPanelContent(title: "당신의 가치를 높여줄 사람을\n만나볼수 없을까요?", imageName: "placeholder1"),
                MeetingTopPanelContent(title: "잘 찾아보면 나와요 ", imageName: "placeholder2"),
                MeetingTopPanelContent(title: "혹시 뭐 배워보고 싶어요?", imageName: "placeholder3"),
                MeetingTopPanelContent(title: "당신의 하루를 가치있게!!", imageName: "placeholder1")
            ]
        }()
        
        static let bottomContents: [MeetingBottomPanelContent] = {
            return [
                MeetingBottomPanelContent(typeName: "카운셀링"),
                MeetingBottomPanelContent(typeName: "멘토링"),
                MeetingBottomPanelContent(typeName: "체험"),
                MeetingBottomPanelContent(typeName: "네트워킹")
            ]
        }()
        
        static let topPanelCellId = "topPanelCellId"
        static let bottomPanelCellId = "bottomPanelCellId"
        static let categoryCellId = "categoryCellId"
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
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setBottomPanelCollectionViewUI()
        setNavigationBarUI()
        addSubViews()
        setConstraints()
        registerCells()
    
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) { 
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    fileprivate func setNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        
        
        navigationItem.titleView = titleLabel
        let searchButtonItem = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    fileprivate func setBottomPanelCollectionViewUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collectionView?.backgroundColor = .white
        collectionView?.setCollectionViewLayout(layout, animated: true)
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
        collectionView?.register(CategoryMeetingViewCell.self, forCellWithReuseIdentifier: MeetingMainData.categoryCellId)
    }
}
