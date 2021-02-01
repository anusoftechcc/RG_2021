//
//  EditOrReplayGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 12/10/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class EditOrReplayGameModel: Mappable {
    
    var animals : String!
    var caddieCards : String!
    var customerId : Int?
    var scheduleDate : String!
    var scheduleTime : String!
    var gameName : String!
    var game : String!
    var handicaps : String!
    var playNow : String!
    var strokeOnPar : String!
    var course : String!
    var scoreType : String?
    var teeName : String!
    var gameNames : [EditGameNamesModel]!
    var groups : [EditGroupsModel]!
    var players : [PlaersViewModel]!
    var teeNames : [EditTeeNamesViewModel]!
    var deckNames : [EditDeckNamesModel]!
    var deckName : String!
    var tie : Int?
    var scoring : Int?
    var hasScoresData :  String!
    var press : String!
    var cardsPerPlayer : String!
    
    
    required init?(map: Map) {
        
         animals <- map["Animals"]
         caddieCards <- map["CaddieCards"]
         customerId <- map["CustomerId"]
         scheduleDate <- map["ScheduleDate"]
         scheduleTime <- map["ScheduleTime"]
         gameName <- map["GameName"]
         game <- map["Game"]
         course <- map["Course"]
         scoreType <- map["ScoreType"]
         teeName <- map["TeeName"]
         gameNames <- map["GameNames"]
         groups <- map["Groups"]
         players <- map["Players"]
         teeNames <- map["TeeNames"]
        handicaps <- map["Handicaps"]
        playNow <- map["PlayNow"]
        strokeOnPar <- map["StrokeOnPar"]
        deckNames <- map["DeckNames"]
        deckName <- map["DeckName"]
        tie <- map["Tie"]
        scoring <- map["Scoring"]
        hasScoresData <- map["HasScoresData"]
        press <- map["Press"]
        cardsPerPlayer <- map["CardsPerPlayer"]
    }
    
    func mapping(map: Map) {
        
    }
}
class EditGroupsModel: Mappable {
    
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
class PlaersViewModel: Mappable {
    
    var customerId : Int?
    var firstName : String!
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        firstName <- map["FirstName"]
    }
    func mapping(map: Map) {
        
    }
}
class EditGameNamesModel: Mappable {
    
    var gameName : String!
    
    required init?(map: Map) {
        gameName <- map["GameName"]
    }
    func mapping(map: Map) {
        
    }
}
class EditTeeNamesViewModel: Mappable {
    
    var teeName : String!
    
    required init?(map: Map) {
        teeName <- map["TeeName"]
    }
    func mapping(map: Map) {
        
    }
}

class EdityOrReplaModel: Mappable {
    
    var Success : [EditGameModel]!
    
    required init?(map: Map) {
        Success <- map["Success"]
    }
    func mapping(map: Map) {
        
    }
}
class EditDeckNamesModel: Mappable {
    
    var deckName : String!
    
    required init?(map: Map) {
        deckName <- map["DeckName"]
    }
    func mapping(map: Map) {
        
    }
}
