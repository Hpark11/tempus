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
}

struct Meeting {
    private var _meetingId: String!
    private var _title: String!
    private var _subTitle: String!
    private var _imageUrl: String!
    private var _type: String!
    private var _category: String!
    private var _username: String!
    private var _followers: Int!
    private var _comments: Int!
    
    var meetingId: String {
        return _meetingId
    }
    
    var title: String {
        return _title
    }
    
    var subTitle: String {
        return _subTitle
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var type: String {
        return _type
    }
    
    var category: String {
        return _category
    }
    
    var username: String {
        return _username
    }
    
    var followers: Int {
        return _followers
    }
    
    var comments: Int {
        return _comments
    }
    
    init(id: String, data: Dictionary<String, AnyObject>, username:String, numFollowers:Int, numComments:Int) {
        if let title = data[Constants.Meetings.title] as? String,
            let subTitle = data[Constants.Meetings.subTitle] as? String,
            let imageUrl = data[Constants.Meetings.frontImageUrl] as? String,
            let type = data[Constants.Meetings.type] as? String,
            let category = data[Constants.Meetings.category] as? String {
            
            self._meetingId = id
            self._title = title
            self._subTitle = subTitle
            self._imageUrl = imageUrl
            self._type = type
            self._category = category
            self._username = username
            self._followers = numFollowers
            self._comments = numComments
        }
    }
}
