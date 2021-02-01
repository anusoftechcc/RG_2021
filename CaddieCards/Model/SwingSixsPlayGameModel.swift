//
//  SwingSixsPlayGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/09/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class  SwingSixsPlayGameModel: Mappable {
    
    var thru : String!
    var players : [SwingPlayersModel]!
    var holes : [SwingHolesModel]!
    var swing6sPress : [Swing6sPressModel]!
    
    required init?(map: Map) {
        
        thru <- map["Thru"]
        players <- map["Players"]
        holes <- map["Holes"]
        swing6sPress <- map["Swing6sPress"]
    }
    
    func mapping(map: Map) {
        
    }
}
class SwingPlayersModel :  Mappable {
    
    var customerId : String?
    var name : String?
    var hcp : String?
    var team : String?
    var order : Int!
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        team <- map["Team"]
        order <- map["Order"]
    }
    func mapping(map: Map) {
        
    }
}
class SwingHolesModel :  Mappable {
    
    var teamNo : String?
    var teamName : String?
    var team1 : String?
    var team2 : String?
    var teamOneMembers : [TeamOneMembersModel]!
    var teamTwoMembers : [TeamTwoMembersModel]!
    
    required init?(map: Map) {
        teamNo <- map["TeamNo"]
        teamName <- map["TeamName"]
        team1 <- map["Team1"]
        team2 <- map["Team2"]
        teamOneMembers <- map["TeamOneMembers"]
        teamTwoMembers <- map["TeamTwoMembers"]
    }
    func mapping(map: Map) {
        
    }
}
class TeamOneMembersModel :  Mappable {
    
    var customerId : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
    }
    func mapping(map: Map) {
        
    }
}
class TeamTwoMembersModel :  Mappable {
    
    var customerId : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
    }
    func mapping(map: Map) {
        
    }
}
class Swing6sPressModel :  Mappable {
    
    var pressed : [Swing6sPressedModel]!
    var showPress : [String : AnyObject]!
    var sectionNo : String?
    
    required init?(map: Map) {
        pressed <- map["Pressed"]
        showPress <- map["ShowPress"]
    }
    
    func mapping(map: Map) {
        
    }
}
class Swing6sPressedModel :  Mappable {
    
    var gameId : Int!
    var holeNo : Int!
    var teamNo : Int!
    var pressNo : Int!
    var prevScore : String?
    
    required init?(map: Map) {
        gameId <- map["GameId"]
        holeNo <- map["HoleNo"]
        teamNo <- map["TeamNo"]
        pressNo <- map["PressNo"]
        prevScore <- map["PrevScore"]
    }
    
    func mapping(map: Map) {
        
    }
}
