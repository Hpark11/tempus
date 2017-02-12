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

class DataService {
    static let instance = DataService()
    
    // Database References
    private var _baseRef = DB_BASE
    private var _meetingRef = DB_BASE.child("meeting")
    private var _userRef = DB_BASE.child("user")
    
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
    
    var imageRef: FIRStorageReference {
        return _imageRef
    }
    
    func createFirebaseDatabaseUser(uid: String, dataUser: Dictionary<String, String>) {
        userRef.child(uid).updateChildValues(dataUser)
    }
}

