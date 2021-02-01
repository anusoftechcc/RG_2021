//
//  WebCastDataVC.swift
//  Merz
//
//  Created by Thukaram Vadde on 15/08/18.
//  Copyright © 2018 Thukaram. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginModel : Mappable {
    
    internal var Error : Bool?
    internal var Success : String?
    internal var ErrorMsg : String?
    internal var FirstName : String?
    internal var LastName : String?
    internal var FriendsCount : Int?
    internal var RequestCount : Int?
    internal var AccessToken : String?
    internal var CustomerId : Int?
    internal var Password : String?
    
    
    internal init?() {
        // Empty Constructor
    }
    required init?(map: Map) {
        mapping(map: map)
        
    }
    
    func mapping(map: Map) {
        Error <- map["IsError"]
        Success <- map["SuccessMessage"]
        ErrorMsg <- map["ErrorMessage"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        FriendsCount <- map["FriendsCount"]
        RequestCount <- map["RequestCount"]
        AccessToken <- map["AccessToken"]
        CustomerId <- map["CustomerId"]
        Password <- map["Password"]
    }
}



