//
//  WolfGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class  WolfGameModel: Mappable {
    
    var thru : String!
    var prevWolfCustomerId : String!
    var nextHole : String!
    var players : [WolfPlayersModel]!
    var nextWolfCustomerId : String!
    
    required init?(map: Map) {
        
        thru <- map["Thru"]
        nextHole <- map["NextHole"]
        players <- map["Players"]
        prevWolfCustomerId <- map["PrevWolfCustomerId"]
        nextWolfCustomerId <- map["NextWolfCustomerId"]
    }
    
    func mapping(map: Map) {
        
    }
}
class WolfPlayersModel :  Mappable {
    
    var customerId : String?
    var name : String?
    var hcp : String?
    var team : String?
    var order : String?
    var score : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        team <- map["Team"]
        order <- map["Order"]
        score <- map["Score"]
    }
    func mapping(map: Map) {
        
    }
}

