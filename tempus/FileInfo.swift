//
//  FileInfo.swift
//  tempus
//
//  Created by hPark on 2017. 2. 23..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

class FileInfo: NSObject {
    private var _key: String?
    private var _fileName: String?
    private var _fileExt: String?
    private var _fileSize: Int?
    private var _fileUrl: String?
    
    var key: String {
        if let key = _key {
            return key
        } else {
            return ""
        }
    }
    
    var fileName: String {
        if let fileName = _fileName {
            return fileName
        } else {
            return ""
        }
    }
    
    var fileExt: String {
        if let fileExt = _fileExt {
            return fileExt
        } else {
            return ""
        }
    }
    
    var fileSize: Int {
        if let fileSize = _fileSize {
            return fileSize
        } else {
            return 0
        }
    }
    
    var fileUrl: String {
        if let fileUrl = _fileUrl {
            return fileUrl
        } else {
            return ""
        }
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        _key = key
        _fileName = data[Constants.Group.FileUrls.fileName] as? String
        _fileExt = data[Constants.Group.FileUrls.fileExt] as? String
        _fileUrl = data[Constants.Group.FileUrls.fileUrl] as? String
        _fileSize = data[Constants.Group.FileUrls.fileSize] as? Int
    }
}
