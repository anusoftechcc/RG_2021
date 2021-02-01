//
//  GameViewDetailsModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 18/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class GameViewDetailsModel: Mappable {
    
    var groups : [GroupsModel]!
    var courseNames : [CourseGameViewModel]!
    var gameNames : [GameNamesModel]!
    var deckNames : [DeckNamesModel]!
    var homeCourse : String?
    
    required init?(map: Map) {
        groups <- map["Groups"]
         courseNames <- map["HomeCourse"]
        gameNames <- map["GameNames"]
        deckNames <- map["DeckNames"]
        homeCourse <- map["HomeCourse"]
    }
    
    func mapping(map: Map) {
        
    }
}

class GroupsModel: Mappable {
    
    var groupId : String!
    var customerId : String!
    var groupName : String!
    var entereddate : String!
    
    
    required init?(map: Map) {
        groupId <- map["GroupId"]
        customerId <- map["CustomerId"]
        groupName <- map["GroupName"]
        entereddate <- map["Entereddate"]
    }
    func mapping(map: Map) {
        
    }
}
class CourseGameViewModel: Mappable {
    
    var courseName : String!
    
    required init?(map: Map) {
        courseName <- map["CourseName"]
    }
    func mapping(map: Map) {
        
    }
}
class GameNamesModel: Mappable {
    
    var gameName : String!
    
    required init?(map: Map) {
        gameName <- map["GameName"]
    }
    func mapping(map: Map) {
        
    }
}
class GameDetailsModel: Mappable {
    
    var Success : [GameViewDetailsModel]!
    
    required init?(map: Map) {
        Success <- map["Success"]
    }
    func mapping(map: Map) {
        
    }
}
class DeckNamesModel: Mappable {
    
    var deckName : String!
    
    required init?(map: Map) {
        deckName <- map["DeckName"]
    }
    func mapping(map: Map) {
        
    }
}

