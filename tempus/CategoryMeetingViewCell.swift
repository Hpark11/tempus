//
//  CategoryMeetingViewCell.swift
//  tempus
//
//  Created by hPark on 2017. 2. 9..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CategoryMeetingViewCell: BaseCell {
    
    public struct CategoryData {
        static let contents: [MeetingCategoryContent] = {
            return [
                MeetingCategoryContent(title: "자기계발", subTitle: "진로상담, 습관개선, 자기PR 등", imageName: "placeholder1"),
                MeetingCategoryContent(title: "입시", subTitle: "교과목, 언어, 예체능 등", imageName: "placeholder2"),
                MeetingCategoryContent(title: "전문기술", subTitle: "디자인, 프로그래밍 등", imageName: "placeholder1"),
                MeetingCategoryContent(title: "취미", subTitle: "요가, 피트니스, 운동, 악기 등", imageName: "placeholder2")
            ]
        }()
    }
    
    let categoryButtons: [UIButton] = {
        var buttons = [UIButton]()
        
        for i in 0..<CategoryData.contents.count {
            
            let button = UIButton(type: .system)
            button.tag = i
            button.setTitle(CategoryData.contents[i].title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            button.setBackgroundImage(UIImage(named: "placeholder1"), for: .normal)
            button.isUserInteractionEnabled = true
            buttons.append(button)
        }
        
        return buttons
    }()
    
    func categoryButtonTapped(button: UIButton) {
        print(button.tag)
    }
    
    override func setupViews() {
        super.setupViews()
        //contentView.isUserInteractionEnabled = false
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        for i in 0..<categoryButtons.count {
            contentView.addSubview(categoryButtons[i])
            //categoryButtons[i].bringSubview(toFront: self.contentView)
        }
    }
    
    fileprivate func setConstraints() {
        var position: CGFloat = 0
        
        for i in 0..<categoryButtons.count {
            _ = categoryButtons[i].anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: position, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
            position += frame.height / 4
        }
    }
}
