//
//  CheckUserProfileViewController.swift
//  tempus
//
//  Created by hPark on 2017. 2. 21..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CheckUserProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var userId: String?
    
    lazy var beforeButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "icon cancel") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .black
        button.addTarget(self, action: #selector(beforeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    func beforeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(beforeButton)
        _ = beforeButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 40)
        
        collectionView?.register(MyProfileInfoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyProfileInfoCell
        if let userId = self.userId {
            cell.userId = userId
        }
        cell.checkUserProfileViewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 0.8)
    }
}
