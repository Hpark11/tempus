//
//  Comment.swift
//  tempus
//
//  Created by hPark on 2017. 2. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

class Comment: NSObject {
    private var _key: String?
    private var _text: String?
    private var _userId: String?
    private var _timestamp: NSNumber?
    private var _children: Dictionary<String, AnyObject>?
    private var _parent: String?
    
    var key: String {
        if let key = _key {
            return key
        } else {
            return ""
        }
    }
    
    var text: String {
        if let text = _text {
            return text
        } else {
            return ""
        }
    }
    
    var userId: String {
        if let userId = _userId {
            return userId
        } else {
            return ""
        }
    }
    
    var timestamp: NSNumber {
        if let time = _timestamp {
            return time
        } else {
            return 0
        }
    }
    
    var children: Dictionary<String, AnyObject> {
        if let children = _children {
            return children
        } else {
            return [String:AnyObject]()
        }
    }
    
    var parent: String? {
        return _parent
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        _key = key
        _text = data[Constants.Comments.text] as? String
        _userId = data[Constants.Comments.userId] as? String
        _timestamp = data[Constants.Comments.timestamp] as? NSNumber
        _children = data[Constants.Comments.children] as? Dictionary<String, AnyObject>
        _parent = data[Constants.Comments.parent] as? String
    }
}
