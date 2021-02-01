//
//  PlayGameModel.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/02/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayGameModel : Mappable {
    
    // var gameData : [: String]
    var scoreBoard : [PlayScoreModel]!
    var playersScore : [PlayPlayersScoreModel]!
    var scoreCard : [PlayScoreCardModel]!
    var playPlayers : [PlayPlayersModel]!
    var playAnimals : [PlayAnimalsModel]!
    var playPlayerAnimals : [PlayPlayerAnimalsModel]!
    var playGameData : [PlayGameDataModel]!
    var showPress : [ShowPressModel]!
    var press : [PressModel]!
    var playerCards : [PlayerCardsModel]!
    
    required init?(map: Map) {
        //    gameData <- map["GameData"]
        scoreCard <- map["ScoreCard"]
        scoreBoard <- map["ScoreBoard"]
        playPlayers <- map["StrokePaly"]
        playAnimals <- map["Animals"]
        playersScore <- map["PlayersScore"]
        playPlayerAnimals <- map["PlayerAnimals"]
        playGameData <- map["GameData"]
        showPress <- map["ShowPress"]
        press <- map["Press"]
        playerCards <- map["PlayerCards"]
    }
    
    func mapping(map: Map) {
        
    }
}
/*
class PlayGameDataModel : Mappable {
    var courseName : String?
    var gameType : String?
    var scheduleDate : String?
    var totalPlayers :  Int!
    var game : String?
    
    required init?(map: Map) {
        courseName <- map["CourseName"]
        gameType <- map["GameType"]
        scheduleDate <- map["ScheduleDate"]
        totalPlayers <- map["TotalPlayers"]
        game <- map["Game"]
    }
    
    func mapping(map: Map) {
        
    }
}
 */
class PlayGameDataModel : Mappable {
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
    var putzCards : String!
    
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
        putzCards <- map["PutzCards"]
    }
    
    func mapping(map: Map) {
        
    }
}
class PlayScoreModel : Mappable {
    
    var holeName :  String?
    var yards :  String?
    var hcp : String?
    var par :  String?
    var players : [ScorePlayersModel]!
    
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
class PlayScoreCardModel : Mappable {
    
    
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
class PlayAnimalsModel : Mappable {
    
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

class PlayPlayersModel :  Mappable {
    
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

class ScorePlayersModel :  Mappable {
    
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
class PlayPlayerAnimalsModel :  Mappable {
    
    var playerId : String?
    var AnimalId : String?
    
    required init?(map: Map) {
        playerId <- map["PlayerId"]
        AnimalId <- map["AnimalId"]
    }
    
    func mapping(map: Map) {
        
    }
}
class ShowPressModel :  Mappable {
    
    var holeNo : Int!
    var teamNo : Int!
    
    required init?(map: Map) {
        holeNo <- map["HoleNo"]
        teamNo <- map["TeamNo"]
    }
    
    func mapping(map: Map) {
        
    }
}
class PressModel :  Mappable {
    
    var holeNo : Int!
    var teamNo : Int!
    var pressNo : Int!
    var prevScore : String?
    
    required init?(map: Map) {
        holeNo <- map["HoleNo"]
        teamNo <- map["TeamNo"]
        pressNo <- map["PressNo"]
        prevScore <- map["PrevScore"]
    }
    
    func mapping(map: Map) {
        
    }
}
class PlayPlayersScoreModel :  Mappable {
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        
    }
}
class PlayerCardsModel :  Mappable {
    
    var card : String?
    var cardDescription : String?
    var cardId : String?
    var cardName : String?
   
    required init?(map: Map) {
        card <- map["Card"]
        cardDescription <- map["CardDescription"]
        cardId <- map["CardId"]
        cardName <- map["CardName"]
    }
    func mapping(map: Map) {
        
    }
}
