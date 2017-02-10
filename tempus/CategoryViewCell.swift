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
        label.text = "자기계발"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override var isHighlighted: Bool {

    }

    override var isSelected: Bool {

    }
}
