//
//  Constants.swift
//  tempus
//
//  Created by hPark on 2017. 2. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

struct Constants {
    static let keychainUid = "uid"
    
    struct sizeStandards {
        static let landscapeRatio: CGFloat = 9 / 16
        static let spaceShort: CGFloat = 8
        static let spaceMiddle: CGFloat = 16
        static let spaceLong: CGFloat = 32
    }
    
    struct userProfileImageSize {
        static let mini: CGFloat = 28
        static let lessSmall: CGFloat = 36
        static let small: CGFloat = 44
        static let middle: CGFloat = 96
        static let big: CGFloat = 128
    }
    
    struct keyColors {
        static let navBarColor: UIColor = .black
        static let tabBarColor: UIColor = .lightGray
    }
    
    struct Meetings {
        static let userId: String = "userId"
        static let isPassed: String = "isPassed"
        static let title: String = "title"
        static let subTitle: String = "subTitle"
        static let category: String = "category"
        static let type: String = "type"
        static let dateTime: String = "dateTime"
        static let address: String = "address"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        static let price: String = "price"
        static let preferred: String = "preferred"
        static let profile: String = "profile"
        static let frontImageUrl: String = "frontImageUrl"
        static let backImageUrl: String = "backimageUrl"
        static let slides: String = "slides"
        
        struct Slides {
            static let storyTitle: String = "storyTitle"
            static let storySubtitle: String = "storySubtitle"
            static let imageUrl: String = "imageUrl"
        }
    }
    
    struct Users {
        static let imageUrl: String = "imageUrl"
        static let username: String = "username"
        static let comments: String = "comments"
        static let followers: String = "followers"
        static let following: String = "following"
        static let numFollowers: String = "numFollowers"
        static let numFollowings: String = "numFollowings"
        static let numComments: String = "numComments"
        static let provider: String = "provider"
        static let email: String = "email"
        static let uid: String = "uid"
    }
    
    struct Category {
        static let selfImprovement = "selfImprovement"
        static let prepareExamination = "prepareExamination"
        static let professionalSkills = "professionalSkills"
        static let lookingForHobby = "lookingForHobby"
    }
    
    struct MeetingType {
        static let mentoring = "mentoring"
        static let counseling = "counseling"
        static let networking = "networking"
        static let experience = "experience"
    }
    
    struct ControllerId {
        static let userPage = "userPage"
        static let chatting = "chatting"
    }
}
