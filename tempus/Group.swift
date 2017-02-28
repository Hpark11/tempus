//
//  Group.swift
//  tempus
//
//  Created by hPark on 2017. 2. 22..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

class Group: NSObject {
    private var _key: String?
    private var _imageUrl: String?
    private var _fileDir: String?
    private var _meetingId: String?
    private var _name: String?
    private var _messages: Dictionary<String, Int>?
    private var _fileUrls: Dictionary<String, String>?
    
    var key: String {
        if let key = _key {
            return key
        } else {
            return ""
        }
    }
    
    var imageUrl: String {
        if let imageUrl = _imageUrl {
            return imageUrl
        } else {
            return "https://firebasestorage.googleapis.com/v0/b/tempus-cbe18.appspot.com/o/images%2Fplaceholder.jpeg?alt=media&token=08d46599-746b-46da-a43e-73321be7be63"
        }
    }
    
    var fileDir: String {
        if let fileDir = _fileDir {
            return fileDir
        } else {
            return ""
        }
    }
    
    var meetingId: String {
        if let meetingId = _meetingId {
            return meetingId
        } else {
            return ""
        }
    }
    
    var name: String {
        if let name = _name {
            return name
        } else {
            return ""
        }
    }
    
    var messages: Dictionary<String, Int> {
        if let messages = _messages {
            return messages
        } else {
            return Dictionary<String, Int>()
        }
    }
    
    var fileUrls: Dictionary<String,String> {
        if let fileUrls = _fileUrls {
            return fileUrls
        } else {
            return Dictionary<String, String>()
        }
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        _key = key
        _imageUrl = data[Constants.Group.imageUrl] as? String
        _fileDir = data[Constants.Group.fileDir] as? String
        _meetingId = data[Constants.Group.meetingId] as? String
        _name = data[Constants.Group.name] as? String
        _messages = data[Constants.Group.messages] as? Dictionary<String, Int>
        _fileUrls = data[Constants.Group.fileUrls] as? Dictionary<String, String>
    }
    
}
