//
//  Users.swift
//  tempus
//
//  Created by hPark on 2017. 2. 15..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import Firebase

class Users {
    private var _uid: String?
    private var _email: String?
    private var _provider: String?
    private var _username: String?
    private var _imageUrl: String?
    private var _backgroundImageUrl: String?
    private var _followers: Array<String>?
    private var _following: Array<String>?
    private var _comments: Dictionary<String, AnyObject>?
    private var _appliedMeetings: Array<String>?
    private var _openedMeetings: Array<String>?
    private var _numComments: Int?
    private var _numFollowers: Int?
    private var _numFollowings: Int?
    private var _intro: String?
    private var _isGroupingAuth: String?
    private var _group: Dictionary<String, Int>?
    
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
    
    var comments: Dictionary<String, AnyObject> {
        if let comments = _comments {
            return comments
        } else {
            return [String:AnyObject]()
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
    
    var appliedMeetings: Array<String> {
        if let appliedMeetings = _appliedMeetings {
            return appliedMeetings
        } else {
            return []
        }
    }
    
    var openedMeetings: Array<String> {
        if let openedMeetings = _openedMeetings {
            return openedMeetings
        } else {
            return []
        }
    }
    
    var isGroupingAuth: String {
        if let isGroupingAuth = _isGroupingAuth {
            return isGroupingAuth
        } else {
            return "false"
        }
    }
    
    var group: Dictionary<String, Int> {
        if let group = _group {
            return group
        } else {
            return Dictionary<String, Int>()
        }
    }

    // username, text, date, image
    
    init(uid: String, data: Dictionary<String, AnyObject>) {
        _uid = uid
        _email = data[Constants.Users.email] as? String
        _username = data[Constants.Users.username] as? String
        _comments = data[Constants.Users.comments] as? Dictionary<String, AnyObject>
        _followers = data[Constants.Users.followers] as? Array<String>
        _following = data[Constants.Users.following] as? Array<String>
        _numComments = data[Constants.Users.numComments] as? Int
        _numFollowers = data[Constants.Users.numFollowers] as? Int
        _numFollowings = data[Constants.Users.numFollowings] as? Int
        _provider = data[Constants.Users.provider] as? String
        _imageUrl = data[Constants.Users.imageUrl] as? String
        _backgroundImageUrl = data[Constants.Users.backgroundImageUrl] as? String
        _intro = data[Constants.Users.intro] as? String
        _appliedMeetings = data[Constants.Users.appliedMeetings] as? Array<String>
        _openedMeetings = data[Constants.Users.openedMeetings] as? Array<String>
        _isGroupingAuth = data[Constants.Users.isGroupingAuth] as? String
        _group = data[Constants.Users.group] as? Dictionary<String, Int>
    }
    
    func changeNumFollowers(follows: Bool, followee: String, follower: String, numFollowing: Int) {
        if follows {
            self._numFollowers = self._numFollowers! + 1
            FirebaseDataService.instance.userRef.child(follower).child(Constants.Users.numFollowings).setValue(numFollowing + 1)
        } else {
            self._numFollowers = self._numFollowers! - 1
            FirebaseDataService.instance.userRef.child(follower).child(Constants.Users.numFollowings).setValue(numFollowing - 1)
        }
        FirebaseDataService.instance.userRef.child(followee).child(Constants.Users.followers).child(follower).setValue(NSNumber(value: 1))
        FirebaseDataService.instance.userRef.child(follower).child(Constants.Users.following).child(followee).setValue(NSNumber(value: 1))
        FirebaseDataService.instance.userRef.child(followee).child(Constants.Users.numFollowers).setValue(self._numFollowers)
    }
}
