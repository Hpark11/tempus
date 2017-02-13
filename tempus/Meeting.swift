//
//  Meeting.swift
//  tempus
//
//  Created by hPark on 2017. 2. 11..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import Firebase

//class Meeting : NSObject {
//    var cover_image_name: String?
//    var title: String?
//    var sub_title: String?
//    var meeting_type: String?
//    var category: String?
//    var upload_date: Date?
//    var userId: String?
//
//    var slides: [MeetingSlide]?
//    var detail: MeetingDetail
//    init(title:String) {
//        
//    }
//}
//
//class MeetingSlide : NSObject {
//    var image: String?
//    var header: String?
//    var content: String?
//}
//
//class MeetingDetail : NSObject {
//    
//}

struct Meeting {
    private var _title: String!
    private var _subTitle: String!
    private var _imageUrl: String!
    private var _type: String!
    private var _category: String!
    private var _username: String!
    private var _followers: Int!
    private var _comments: Int!
    
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
    
    init(data: Dictionary<String, AnyObject>, username:String, numFollowers:Int, numComments:Int) {
        if let title = data[Constants.Meetings.title] as? String,
            let subTitle = data[Constants.Meetings.subTitle] as? String,
            let imageUrl = data[Constants.Meetings.frontImageUrl] as? String,
            let type = data[Constants.Meetings.type] as? String,
            let category = data[Constants.Meetings.category] as? String {
            
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

//struct MeetingNormalSlide {
//    var storyTitle: String!
//    var storySubTitle: String!
//    var imageUrl: String!
//}
//
//struct MeetingDetailSlide {
//    var price: String!
//    var profile: String!
//    var preferred: String!
//    var imageUrl: String!
//}
//
//struct MeetingCoverSlide {
//    var title: String!
//    var subTitle: String!
//    var imageUrl: String!
//}
//
//struct Meeting {
//    private var _cover: MeetingCoverSlide!
//    private var _detail: MeetingDetailSlide!
//    private var _normals: [MeetingNormalSlide]!
//    private var _type: String!
//    private var _category: String!
//    private var _userId: String!
//    private var _dateTime: Int!
//    private var _meetingRef: FIRDatabaseReference!
//
//    var cover: MeetingCoverSlide {
//        return _cover
//    }
//    
//    var detail: MeetingDetailSlide {
//        return _detail
//    }
//    
//    var normal: [MeetingNormalSlide] {
//        return _normals
//    }
//    
//    var type: String {
//        return _type
//    }
//    
//    var category: String {
//        return _category
//    }
//    
//    var userId: String {
//        return _userId
//    }
//    
//    var dateTime: Int {
//        return _dateTime
//    }
//    
//    init(meetingId: String, data: Dictionary<String, AnyObject>, cover: Dictionary<String, AnyObject>, detail: Dictionary<String, AnyObject>, normals: Array<Dictionary<String, AnyObject>>) {
//        if let type = data[Constants.Meetings.type] as? String,
//            let category = data[Constants.Meetings.category] as? String,
//            let userId = data[Constants.Meetings.userId] as? String,
//            let dateTime = data[Constants.Meetings.dateTime] as? Int {
//            
//            self._type = type
//            self._category = category
//            self._userId = userId
//            self._dateTime = dateTime
//            
//            self._cover.title = cover[Constants.Meetings.Cover.title] as? String
//            self._cover.subTitle = cover[Constants.Meetings.Cover.subTitle] as? String
//            self._cover.imageUrl = cover[Constants.Meetings.Cover.imageUrl] as? String
//            
//            self._detail.price = detail[Constants.Meetings.Detail.price] as? String
//            self._detail.preferred = detail[Constants.Meetings.Detail.preferred] as? String
//            self._detail.profile = detail[Constants.Meetings.Detail.profile] as? String
//            self._detail.imageUrl = detail[Constants.Meetings.Detail.imageUrl] as? String
//            
//            for normal in normals {
//                var norm = MeetingNormalSlide()
//                norm.storyTitle = normal[Constants.Meetings.Normal.storyTitle] as? String
//                norm.storySubTitle = normal[Constants.Meetings.Normal.storySubtitle] as? String
//                norm.imageUrl = normal[Constants.Meetings.Normal.imageUrl] as? String
//                self._normals.append(norm)
//            }
//            self._meetingRef = FirebaseDataService.instance.meetingRef.child(meetingId)
//        }
//    }

//    func changeLikesNumber(addLike: Bool) {
//        if addLike {
//            _likes = _likes + 1
//        } else {
//            _likes = _likes - 1
//        }
//        
//        _postRef.child("likes").setValue(_likes)
//    }
//}
