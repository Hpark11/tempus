//
//  UserProfileBarView.swift
//  tempus
//
//  Created by hPark on 2017. 2. 14..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserProfileBarView : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var attachedViewController: UserPageViewController?
    var profileHighlightedBarConstraint: NSLayoutConstraint?
    
    struct UserProfileBarData {
        static let cellId = "cellId"
        static let categories = ["내 정보", "팔로잉"]
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.makeViaRgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        addSubViews()
        setConstraints()
        registerCells()
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        setupHorizontalBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHorizontalBar() {
        let categoryHighlightedBar = UIView()
        categoryHighlightedBar.backgroundColor = UIColor.makeViaRgb(red: 0, green: 159, blue: 232)
        categoryHighlightedBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryHighlightedBar)
        
        categoryHighlightedBarConstraint = categoryHighlightedBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        categoryHighlightedBarConstraint?.isActive = true
        
        categoryHighlightedBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        categoryHighlightedBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / CGFloat(UserProfileBarData.categories.count)).isActive = true
        categoryHighlightedBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    fileprivate func addSubViews() {
        addSubview(collectionView)
    }
    
    fileprivate func setConstraints() {
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func registerCells() {
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryBarData.cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        attachedViewController?.scrollToCategoryIndex(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryBarData.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBarData.cellId, for: indexPath) as! CategoryViewCell
        cell.backgroundColor = .black
        cell.categoryLabel.text = CategoryBarData.categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(CategoryBarData.categories.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
