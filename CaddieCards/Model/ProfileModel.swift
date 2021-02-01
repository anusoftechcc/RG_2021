//
//  ProfileModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 17/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileModel: Mappable {
    
    var customerId : Int?
    var userName : String!
    var password : String!
    var firstName : String!
    var lastName : String!
    var dob : String!
    var age : String!
    var phone : String!
    var gender : String!
    var handiCap : String!
    var homeCourse : String!
    var averageScore : String!
    var address1 :  String!
    var address2 :  String!
    var city : String!
    var state : String!
    var zip : String!
    var courseNames : [CourseModel]!
    var handed : String!
    
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        userName <- map["UserName"]
        password <- map["Password"]
        firstName <- map["FirstName"]
        lastName <- map["LastName"]
        dob <- map["DOB"]
        age <- map["Age"]
        phone <- map["Phone"]
        gender <- map["Gender"]
        handiCap <- map["HandiCap"]
        homeCourse <- map["HomeCourse"]
        averageScore <- map["AverageScore"]
        address1 <- map["Address1"]
        address2 <- map["Address2"]
        city <- map["City"]
        state <- map["State"]
        zip <- map["Zip"]
        courseNames <- map["CourseNames"]
        handed <- map["Handed"]
        
    }
    
    func mapping(map: Map) {
        
    }
}

class CourseModel: Mappable {
    
    var courseName : String!
    
    
    required init?(map: Map) {
        courseName <- map["CourseName"]
    }
    func mapping(map: Map) {
        
    }
}
class MyProfileModel: Mappable {
    
    var Success : [ProfileModel]!
    
    required init?(map: Map) {
        Success <- map["Success"]
    }
    func mapping(map: Map) {
        
    }
}
