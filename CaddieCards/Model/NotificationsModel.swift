//
//  NotificationsModel.swift
//  CaddieCards
//
//  Created by Mounika.x.muduganti on 25/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import Foundation

struct Token {
    static var fcmToken:String? = nil

    static func setToken(fcmToken:String) {
        Token.fcmToken = fcmToken
    }
}
struct NotificationGameId {
    static var gameId:String? = nil

    static func setGameId(gameId:String) {
        NotificationGameId.gameId = gameId
    }
}

struct UserNotificationDataResponse: Codable {
    let SenderName : String?
    let GameId: String?
    let CardId : String?
    let CardName: String?
    let CardDescription : String?
    let Animal: String?
    let Icon: String?
}
struct UserNotificationCardResponse: Codable {
    let body : String?
    let title: String?
    let sound : String?
    let icon: String?
}
