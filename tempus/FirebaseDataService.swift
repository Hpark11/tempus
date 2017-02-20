//
//  FirebaseDataService.swift
//  tempus
//
//  Created by hPark on 2017. 2. 12..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

//struct StaticInstance {
//    static var instance: DataController?
//}
//
//class func sharedInstance() -> DataController {
//    if !(StaticInstance.instance != nil) {
//        StaticInstance.instance = DataController()
//    }
//    return StaticInstance.instance!
//}

class FirebaseDataService {
    static let instance = FirebaseDataService()
    
    // Database References
    private var _baseRef = DB_BASE
    private var _meetingRef = DB_BASE.child("meeting")
    private var _userRef = DB_BASE.child("users")
    private var _messeageRef = DB_BASE.child("messages")
    private var _userMessageRef = DB_BASE.child("user-messages")
    private var _imageUrlRef = DB_BASE.child("images")
    private var _storyRegRef = DB_BASE.child("storyReg")
    
    // Storage References
    private var _imageRef = STORAGE_BASE.child("images")
    
    // User currently signed in
    
    var baseRef: FIRDatabaseReference {
        return _baseRef
    }
    
    var meetingRef: FIRDatabaseReference {
        return _meetingRef
    }
    
    var userRef: FIRDatabaseReference {
        return _userRef
    }
    
    var messageRef: FIRDatabaseReference {
        return _messeageRef
    }
    
    var userMessageRef: FIRDatabaseReference {
        return _userMessageRef
    }
    
    var imageUrlRef: FIRDatabaseReference {
        return _imageUrlRef
    }
    
    var storyRegRef: FIRDatabaseReference {
        return _storyRegRef
    }
    
    var imageRef: FIRStorageReference {
        return _imageRef
    }

    func createFirebaseDatabaseUser(uid: String, dataUser: Dictionary<String, String>) {
        userRef.child(uid).updateChildValues(dataUser)
    }
    
    func downloadAllImagesToCache() {
        _imageUrlRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for one in snapshot {
                    if let url = one.value as? String {
                        FirebaseDataService.instance.imageRef.data(withMaxSize: 6 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print(":::[HPARK] Unable to Download image from Storage \(String(describing: error)):::")
                            } else {
                                if let data = data {
                                    imageCache.setObject(UIImage(data:data)!, forKey: url as NSString)
                                    print(url)
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    func downloadAllRawMeetingList() {
        let userMsgRef = FirebaseDataService.instance.meetingRef
        userMsgRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                rawMeetingList.removeAll()
                for one in snapshot {
                    if let dict = one.value as? Dictionary<String, AnyObject> {
                        rawMeetingList.append(dict)
                    }
                }
            }
        })
    }
}

