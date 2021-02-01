//
//  FriendsModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class FriendsModel: Mappable {
    var acceptedDate : String!
    var firstName : String!
    var friendOne  : String!
    var friendTwo  : String!
    var lastName  : String!
    var requestedDate  : String!
    var status  : String!
    var userId  : String!
    var userName  : String!
    var userType  : String!
    var timeSpan : [String : AnyObject]!
    
    required init?(map: Map) {
        acceptedDate <- map["AcceptedDate"]
        firstName <- map["FirstName"]
        friendOne  <- map["FriendOne"]
         friendTwo  <- map["FriendTwo"]
         lastName  <- map["LastName"]
         requestedDate  <- map["RequestedDate"]
         status  <- map["Status"]
         userId  <- map["UserId"]
         userName  <- map["UserName"]
         userType  <- map["UserType"]
         timeSpan <- map["TimeSpan"]
    }
    
    func mapping(map: Map) {
        
    }
    
}
class WebCastModel: Mappable {
    
    var success : Array<AnyObject>?
    
    required init?(map: Map) {
        success <- map["success"]
    }
    
    func mapping(map: Map) {
        
    }
}
