//
//  Meeting.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

struct MinimizedMeeting {
    var id: String?
    var title: String?
    var category: String?
    var imageUrl: String?
    var categoryEn: String?
    
    init(id: String, data: Dictionary<String, AnyObject>) {
        self.id = id
        self.title = data[Constants.Meetings.title] as? String
        self.imageUrl = data[Constants.Meetings.frontImageUrl] as? String
        if let category = data[Constants.Meetings.category] as? String {
            for i in 0..<Constants.categoryDataSourceEn.count {
                if Constants.categoryDataSourceEn[i] == category {
                    self.category = Constants.categoryDataSource[i]
                }
            }
        }
        categoryEn = data[Constants.Meetings.category] as? String
    }
}

struct Meeting {
    private var _meetingId: String?
    private var _title: String?
    private var _subTitle: String?
    private var _imageUrl: String?
    private var _type: String?
    private var _category: String?
    private var _username: String?
    private var _userImageUrl: String?
    private var _followers: Int?
    private var _comments: Int?
    
    var meetingId: String? {
        return _meetingId
    }
    
    var title: String? {
        return _title
    }
    
    var subTitle: String? {
        return _subTitle
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var type: String? {
        return _type
    }
    
    var category: String? {
        return _category
    }
    
    var username: String? {
        return _username
    }
    
    var userImageUrl: String? {
        return _userImageUrl
    }
    
    var followers: Int? {
        return _followers
    }
    
    var comments: Int? {
        return _comments
    }
    
    init(id: String, data: Dictionary<String, AnyObject>, userInfo: Dictionary<String, AnyObject>) {
        self._meetingId = id
        self._title = data[Constants.Meetings.title] as? String
        self._subTitle = data[Constants.Meetings.subTitle] as? String
        self._imageUrl = data[Constants.Meetings.frontImageUrl] as? String
        self._type = data[Constants.Meetings.type] as? String
        self._category = data[Constants.Meetings.category] as? String
        self._username = userInfo[Constants.Users.username] as? String
        self._userImageUrl = userInfo[Constants.Users.imageUrl] as? String
        self._followers = userInfo[Constants.Users.numFollowers] as? Int
        self._comments = userInfo[Constants.Users.comments] as? Int
    }
}




