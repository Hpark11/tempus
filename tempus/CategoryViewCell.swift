//
//  CategoryViewCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CategoryViewCell: BaseCell {

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            categoryLabel.textColor = isHighlighted ? UIColor.white : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.textColor = isSelected ? UIColor.white : UIColor.lightGray
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(categoryLabel)
        
        _ = categoryLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
