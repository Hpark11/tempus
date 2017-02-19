//
//  Message.swift
//  tempus
//
//  Created by hPark on 2017. 2. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromUserId: String?
    var toUserId: String?
    var text: String?
    var timestamp: NSNumber?
    
    func chatWithSomeone() -> String? {
        if fromUserId == FIRAuth.auth()?.currentUser?.uid {
            return toUserId
        } else {
            return fromUserId
        }
    }
}
