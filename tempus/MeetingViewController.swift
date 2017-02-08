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
    let topPanelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(topPanelCollectionView)
        
        
        
        _ = topPanelCollectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 5).first
        
        topPanelCollectionView.register(MeetingViewTopPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.topPanelCellId)
        collectionView?.register(MeetingViewBottomPanelCell.self, forCellWithReuseIdentifier: MeetingMainData.bottomPanelCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if topPanelCollectionView == collectionView {
//            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier:MeetingMainData.topPanelCellId, for: indexPath)  as! MeetingViewTopPanelCell
//            
//        } else if bottomPanelCollectionView == collectionView  {
//            
//        }
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:MeetingMainData.topPanelCellId, for: indexPath)
//        return cell
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
