//
//  Users.swift
//  tempus
//
//  Created by hPark on 2017. 2. 15..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    private var _uid: String?
    private var _email: String?
    private var _provider: String?
    private var _username: String?
    private var _imageUrl: String?
    private var _backgroundImageUrl: String?
    private var _followers: Array<String>?
    private var _following: Array<String>?
    private var _comments: Array<String>?
    private var _numComments: Int?
    private var _numFollowers: Int?
    private var _numFollowings: Int?
    private var _intro: String?
    
    var uid: String {
        if let uid = _uid {
            return uid
        } else {
            return ""
        }
    }
    
    var email: String {
        if let email = _email {
            return email
        } else {
            return ""
        }
    }
    
    var provider: String {
        if let provider = _provider {
            return provider
        } else {
            return ""
        }
    }
    
    var username: String {
        if let username = _username {
            return username
        } else {
            return ""
        }
    }
    
    var imageUrl: String {
        if let imageUrl = _imageUrl {
            return imageUrl
        } else {
            return ""
        }
    }
    
    var backgroundImageUrl: String {
        if let backgroundImageUrl = _backgroundImageUrl {
            return backgroundImageUrl
        } else {
            return ""
        }
    }
    
    var followers: Array<String> {
        if let followers = _followers {
            return followers
        } else {
            return []
        }
    }
    
    var following: Array<String> {
        if let following = _following {
            return following
        } else {
            return []
        }
    }
    
    var comments: Array<String> {
        if let comments = _comments {
            return comments
        } else {
            return []
        }
    }
    
    var numFollowers: Int {
        if let numFollowers = _numFollowers {
            return numFollowers
        } else {
            return 0
        }
    }
    
    var numComments: Int {
        if let numComments = _numComments {
            return numComments
        } else {
            return 0
        }
    }
    
    var numFollowings: Int {
        if let numFollowings = _numFollowings {
            return numFollowings
        } else {
            return 0
        }
    }
    
    var intro: String {
        if let intro = _intro {
            return intro
        } else {
            return ""
        }
    }
    
    init(uid: String, data: Dictionary<String, AnyObject>) {
        _uid = uid
        _email = data[Constants.Users.email] as? String
        _username = data[Constants.Users.username] as? String
        _comments = data[Constants.Users.comments] as? Array<String>
        _followers = data[Constants.Users.followers] as? Array<String>
        _following = data[Constants.Users.following] as? Array<String>
        _numComments = data[Constants.Users.numComments] as? Int
        _numFollowers = data[Constants.Users.numFollowers] as? Int
        _numFollowings = data[Constants.Users.numFollowings] as? Int
        _provider = data[Constants.Users.provider] as? String
        _imageUrl = data[Constants.Users.imageUrl] as? String
        _backgroundImageUrl = data[Constants.Users.backgroundImageUrl] as? String
        _intro = data[Constants.Users.intro] as? String
    }
}
