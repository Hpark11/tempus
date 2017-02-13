//
//  Constants.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

struct Constants {
    struct sizeStandards {
        static let landscapeRatio: CGFloat = 9 / 16
        static let spaceShort: CGFloat = 8
        static let spaceMiddle: CGFloat = 16
        static let spaceLong: CGFloat = 32
    }
    
    struct userProfileImageSize {
        static let mini: CGFloat = 28
        static let small: CGFloat = 44
        static let middle: CGFloat = 96
        static let big: CGFloat = 128
    }
    
    struct keyColors {
        static let navBarColor: UIColor = .black
        static let tabBarColor: UIColor = .lightGray
    }
    
    struct Meetings {
        static let dateTime: String = "dateTime"
        static let cover: String = "cover"
        static let detail: String = "detail"
        static let normal: String = "normal"
        static let position: String = "position"
        
        struct Cover {
            static let title: String = "title"
            static let subTitle: String = "subTitle"
            static let imageUrl: String = "imageUrl"
        }
        
        struct Detail {
            static let price: String = "price"
            static let preferred: String = "preferred"
            static let profile: String = "profile"
            static let imageUrl: String = "imageUrl"
        }
        
        struct Normal {
            static let storyTitle: String = "storyTitle"
            static let storySubtitle: String = "storySubtitle"
            static let imageUrl: String = "imageUrl"
        }
        
        struct Position {
            static let address: String = "address"
            static let latitude: String = "latitude"
            static let longitude: String = "longitude"
        }
    }
}
