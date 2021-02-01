//
//  NassauPlayModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/08/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class  NassauPlayModel: Mappable {
    
    var thru : String!
    var teamSelection : String!
    var players : [NassauPlayersModel]!
    var holes : [HolesPlayersModel]!
    var nassauPress : [NassauPressModel]!
    
    required init?(map: Map) {
       
        thru <- map["Thru"]
        teamSelection <- map["TeamSelection"]
        players <- map["Players"]
       holes <- map["Holes"]
        nassauPress <- map["NassauPress"]
    }
    
    func mapping(map: Map) {
        
    }
}
class NassauPlayersModel :  Mappable {
    
    var customerId : String?
    var name : String?
    var hcp : String?
    var team : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        team <- map["Team"]
    }
    func mapping(map: Map) {
        
    }
}
class HolesPlayersModel :  Mappable {
    
    var teamNo : String?
    var teamName : String?
    var team1 : String?
    var team2 : String?
    
    required init?(map: Map) {
        teamNo <- map["TeamNo"]
        teamName <- map["TeamName"]
        team1 <- map["Team1"]
        team2 <- map["Team2"]
    }
    func mapping(map: Map) {
        
    }
}
class NassauPressModel :  Mappable {
    
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
class NassauPressedModel :  Mappable {
    
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
