//
//  MatchPlayModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class  MatchPlayModel: Mappable {
    var netScore : String!
    var netTeam : String!
    var thru : String!
    var teamSelection : String!
    var players : [MatchPlayersModel]!
    var team1 : String!
    var team2 : String!
    
    required init?(map: Map) {
        netScore <- map["NetScore"]
        netTeam <- map["NetTeam"]
        thru <- map["Thru"]
        teamSelection <- map["TeamSelection"]
       players <- map["Players"]
        team1 <- map["Team1"]
        team2 <- map["Team2"]
    }
    
    func mapping(map: Map) {
        
    }
}
class MatchPlayersModel :  Mappable {
    
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
