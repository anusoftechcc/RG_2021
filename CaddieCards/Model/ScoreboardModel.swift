//
//  ScoreboardModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/10/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class ScoreboardModel : Mappable {
    
   // var gameData : [: String]
    var scoreBoard : [ScoreModel]!
    var playersScore : [GamePlayersScoreModel]!
    var scoreCard : [GamePlayScoreCardModel]!
    var playPlayers : [GamePlayPlayersModel]!
    var playAnimals : [GamePlayAnimalsModel]!
    var playPlayerAnimals : [GamePlayPlayerAnimalsModel]!
  //  var teamSelection : [TeamSelectionModel]!
    
    required init?(map: Map) {
    //    gameData <- map["GameData"]
        scoreBoard <- map["ScoreBoard"]
        playersScore <- map["PlayersScore"]
        scoreCard <- map["ScoreCard"]
        playPlayers <- map["StrokePaly"]
        playAnimals <- map["Animals"]
        playPlayerAnimals <- map["PlayerAnimals"]
       // teamSelection <- map["TeamSelection"]
    }
    
    func mapping(map: Map) {
        
    }
}

class GameDataModel : Mappable {
    var animals : String!
    var caddieCards : String!
    var customerId : Int?
    var scheduleDate : String!
    var scheduleTime : String!
    var gameName : String!
    var game : String!
    var handicaps : String!
    var strokeOnPar : String!
    var course : String!
    var scoreType : String?
    var teeName : String!
    var courseNumber : String!
    var gameType : String!
    var totalPlayers : Int?
    
    
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
        courseNumber <- map["CourseNumber"]
        gameType <- map["GameType"]
        handicaps <- map["Handicaps"]
        strokeOnPar <- map["StrokeOnPar"]
        totalPlayers <- map["TotalPlayers"]
    }
    
    func mapping(map: Map) {
        
    }
}
class TeamSelectionModel : Mappable {
    
    var hole_1 : Bool?
    var hole_2 :  Bool?
    var hole_3 :  Bool?
    var hole_4 :  Bool?
    var hole_5 :  Bool?
    var hole_6 :  Bool?
    var hole_7 :  Bool?
    var hole_8 :  Bool?
    var hole_9 :  Bool?
    var hole_10 :  Bool?
    var hole_11 :  Bool?
    var hole_12:  Bool?
    var hole_13 :  Bool?
    var hole_14 :  Bool?
    var hole_15 :  Bool?
    var hole_16 :  Bool?
    var hole_17 :  Bool?
    var hole_18 :  Bool?
    
    
    required init?(map: Map) {
        hole_1 <- map["Hole_1"]
        hole_2 <- map["Hole_2"]
        hole_3 <- map["Hole_3"]
        hole_4 <- map["Hole_4"]
        hole_5 <- map["Hole_5"]
        hole_6 <- map["Hole_6"]
        hole_7 <- map["Hole_7"]
        hole_8 <- map["Hole_8"]
        hole_9 <- map["Hole_9"]
        hole_10 <- map["Hole_10"]
        hole_11 <- map["Hole_11"]
        hole_12 <- map["Hole_12"]
        hole_13 <- map["Hole_13"]
        hole_14 <- map["Hole_14"]
        hole_15 <- map["Hole_15"]
        hole_16 <- map["Hole_16"]
        hole_17 <- map["Hole_17"]
        hole_18 <- map["Hole_18"]
        
    }
    func mapping(map: Map) {
        
    }
}
class ScoreModel : Mappable {
    
    var holeName :  String?
    var yards :  String?
    var hcp : String?
    var par :  String?
    var players : [PlayersModel]!

    required init?(map: Map) {
        holeName <- map["HoleName"]
        yards <- map["Yards"]
        hcp <- map["HCP"]
        par <- map["Par"]
        players <- map["Players"]
    }
    func mapping(map: Map) {
        
    }
}
class PlayersModel :  Mappable {
    
    var customerId : String?
    var name : String?
     var hcp : String?
    var score : String?
    var dots : Int!
    var percentageHCP : String?
    var ColorCode : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        score <- map["Score"]
        dots <- map["Dots"]
        percentageHCP <- map["PercentageHCP"]
        ColorCode <- map["ColorCode"]
    }
    func mapping(map: Map) {
        
    }
}
class GamePlayScoreCardModel : Mappable {
    
    
    var holeName :  String?
    var yards :  String?
    var hcp : String?
    var par :  String?
    var holeImage : String?
    
    required init?(map: Map) {
        holeName <- map["HoleName"]
        yards <- map["Yards"]
        hcp <- map["HCP"]
        par <- map["Par"]
        holeImage <- map["HoleImage"]
    }
    func mapping(map: Map) {
        
    }
}
class GamePlayAnimalsModel : Mappable {
    
    var animalId :  Int!
    var animal :  String?
    var animalIcon : String?
    var animalDiscription :  String?
    
    required init?(map: Map) {
        animalId <- map["Id"]
        animal <- map["Animal"]
        animalIcon <- map["Icon"]
        animalDiscription <- map["Discription"]
    }
    func mapping(map: Map) {
        
    }
}

class GamePlayPlayersModel :  Mappable {
    
    var customerId : String?
    var plr : String?
    var hcp : String?
    var grs : String?
    var net : String?
    var animalId : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        plr <- map["PLR"]
        hcp <- map["HCP"]
        grs <- map["GRS"]
        net <- map["NET"]
        animalId <- map["AnimalId"]
    }
    func mapping(map: Map) {
        
    }
}

class GameScorePlayersModel :  Mappable {
    
    var customerId : String?
    var name : String?
    var hcp : String?
    var score : String?
    var dots : Int!
    var percentageHCP : String?
    
    required init?(map: Map) {
        customerId <- map["CustomerId"]
        name <- map["Name"]
        hcp <- map["HCP"]
        score <- map["Score"]
        dots <- map["Dots"]
        percentageHCP <- map["PercentageHCP"]
    }
    func mapping(map: Map) {
        
    }
}
class GamePlayPlayerAnimalsModel :  Mappable {
    
    var playerId : String?
    var AnimalId : String?
    
    required init?(map: Map) {
        playerId <- map["PlayerId"]
        AnimalId <- map["AnimalId"]
    }
    
    func mapping(map: Map) {
        
    }
}
class GamePlayersScoreModel :  Mappable {
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
