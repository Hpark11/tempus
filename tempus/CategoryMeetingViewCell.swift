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
                MeetingCategoryContent(title: "취미", subTitle: "요가, 피트니스, 운동, 악기 등", imageName: "placeholder3")
            ]
        }()
    }
    
    let meetingTypeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 32))
        label.text = "카테고리"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryButtons: [UIButton] = {
        var buttons = [UIButton]()
        for i in 0..<CategoryData.contents.count {
            let button = UIButton(type: .system)
            button.tag = i
            button.setTitle(CategoryData.contents[i].title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
            button.setBackgroundImage(UIImage(named: CategoryData.contents[i].imageName), for: .normal)
            button.isUserInteractionEnabled = true
            buttons.append(button)
        }
        return buttons
    }()
    
    func categoryButtonTapped(_ button: UIButton) {
        print(button.tag)
    }
    
    override func setupViews() {
        super.setupViews()
        self.contentView.isUserInteractionEnabled = false
        
        addSubViews()
        setConstraints()
    }
    
    fileprivate func addSubViews() {
        self.addSubview(meetingTypeLabel)
        for i in 0..<categoryButtons.count {
            self.addSubview(categoryButtons[i])
        }
    }
    
    fileprivate func setConstraints() {
        var position: CGFloat = 0
        
        _ = meetingTypeLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 32)
        for i in 0..<categoryButtons.count {
            _ = categoryButtons[i].anchor(meetingTypeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: position + 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height / 4)
            position += (frame.height - meetingTypeLabel.frame.height - 8) / 4
        }
    }
}
