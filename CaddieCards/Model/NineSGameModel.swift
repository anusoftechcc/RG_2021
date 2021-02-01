//
//  NineSGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 13/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class  NineSGameModel: Mappable {
    
    var thru : String!
    var players : [NineSModel]!
    
    
    required init?(map: Map) {
       
        thru <- map["Thru"]
        players <- map["Players"]
    }
    
    func mapping(map: Map) {
        
    }
}
class NineSModel :  Mappable {
    
    var customerId : String?
    var name : String?
    var hcp : String?
    var score : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        score <- map["Score"]
    }
    func mapping(map: Map) {
        
    }
}
