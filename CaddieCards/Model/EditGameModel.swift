//
//  EditGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/07/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGameModel: Mappable {
    
    var customerId : Int?
    var gameId : Int?
    var scheduleDate : String!
    var scheduleTime : String!
    var gameName : String!
    var courseName : String!
    var teeName : String!
   
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        gameId <- map["GameId"]
        scheduleDate <- map["ScheduleDate"]
        scheduleTime <- map["ScheduleTime"]
        gameName <- map["GameName"]
        courseName <- map["CourseName"]
        teeName <- map["TeeName"]
        
    }
    
    func mapping(map: Map) {
        
    }
}

class EditScheduleGameModel: Mappable {
    
    var Success : [EditGameModel]!
    
    required init?(map: Map) {
        Success <- map["Success"]
    }
    func mapping(map: Map) {
        
    }
}

