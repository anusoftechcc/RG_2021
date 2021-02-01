//
//  ApiConstants.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation

let BASEURL = "https://www.caddiecards.com/api/"
let AVATARURL = "https://www.caddiecards.com/avatar/"

struct MyStrings {
    
    let loginUrl                   =   BASEURL + "Customer/Login"
    let zipCodeUrl                 =   BASEURL + "GetLocatinsByZipId?zip="
    let userExistUrl               =   BASEURL + "Customer/CheckUserExist?UserName="
    let registerUrl                =   BASEURL + "Customer/Register"
    let setActiveUsersUrl                =   BASEURL + "Customer/setactiveusers"
    //  let changePwdUrl             =   BASEURL + "Account/ChangePassword"
    let changePwdUrl               =   BASEURL + "Customer/ChangePassword"
    let getProfileUrl              =   BASEURL + "Customer/EditProfile?CustomerId="
    let uploadProfilePicUrl        =   BASEURL + "Customer/UploadOrDeleteAvatarImages"
    let saveEditProfileUrl         =   BASEURL + "Customer/EditProfileSubmit"
    let saveGuestDetailsUrl         =   BASEURL + "Customer/CreateGuestAccount"
    let shareAppUrl                =   BASEURL + "Customer/ShareApp"
    let addOrConfirmOrDeleteFriendUrl       =   BASEURL + "AddOrConfirmOrDeleteFriend"
    let getFriendDetailsUrl                 =   BASEURL + "GetFriendsDetails"
    let getFriendRequestsUrl                =   BASEURL + "GetFriendsRequests?UserId="
    let getSerachResultUrl                  =   BASEURL + "GetSearchDataByTerm?UserId="
    let getGroupsUrl                        =   BASEURL + "GetGroupsDataById?UserId="
    let deleteGroupUrl                      =   BASEURL + "DeleteGroupById?UserId="
    let getGroupDetailsUrl                        =   BASEURL + "GetGroupMemberDataByGroupId?GroupId="
    let getDeleteUserFromGroupUrl                        =   BASEURL + "DeleteUserFromGroup?UserId="
    let createGroupUrl                        =   BASEURL + "CreateGroup"
    let addGroupMemberUrl                        =   BASEURL + "AddGroupMemberByGroupId?GroupId="
    let getUserDetailsUrl                =   BASEURL + "Customer/GetUserDetails?UserName="
    let editGroupNameByGroupIdUrl                =   BASEURL + "EditGroupByGroupId"
    let addFriendWithOutReqUrl                =   BASEURL + "AddFriendWithoutRequest"
   // let createGameViewUrl                        =   BASEURL + "CreateGameViewAndScoreCards"
    let createGameViewUrl                        =   BASEURL + "CreateGameViewAndScoreCardsNew"
    let getGameViewDataUrl                        =   BASEURL + "GetGameViewData?UserId="
    
    let getScheduleDetailsUrl                        =   BASEURL + "GetScheduledGameDataByCustomerId?CustomerId="
    let getActiveDetailsUrl                        =   BASEURL + "GetActiveGamesByCustomerId?CustomerId="
    
    let editGameDataUrl                        =   BASEURL + "EditGameSubmitData"
    let deletePlayerUrl                        =   BASEURL + "AddOrDeletePlayerfromGame"
    let getHistoryGameDataUrl                        =   BASEURL + "GetHistoryGameData?CustomerId="
    let getGroupDataListUrl                        =   BASEURL + "GetGroupDataListFriendNotBelongs?friendid="
    
    let addFrndGroupDirectUrl                        =   BASEURL + "AddFriendToGroupDirect"
    let getTeeNamesUrl                        =   BASEURL + "GetTeeNamesByCourseName?CourseName="
    let getSheduleEditGameUrl              =   BASEURL + "EditGameData?GameId="
    let getCourseNamesAjaxSearchUrl              =   BASEURL + "GetCourseNamesAjaxSearch"
    let getReplayOrEditGameDetailsUrl              =   BASEURL + "GetReplayGameData?GameId="
    let replayOrEditGameSubmitUrl                        =   BASEURL + "EditGameViewAndScoreCards"
    let replayGameSubmitUrl                        =   BASEURL + "CreateGameViewAndScoreCardsNew"
    
    let getScoreCardsDataUrl             = BASEURL + "GetScoreCardsData2?GameId="
    let editPlayerScoreDataUrl                        =   BASEURL + "PlayerScoreUpdate"
   // let editProfileSubmitUrl             = BASEURL + "Customer/EditProfileSubmit"
   // let getPlayGameDataUrl             = BASEURL + "GetPlayGameData?GameId="
    let getPlayGameDataUrl             = BASEURL + "GetPlayGameDataWithScorecards?GameId="
    let getPlayGameDataFromCreateGameUrl             = BASEURL + "GetPlayGameDataWithScorecards?GameId="
    let addAnimalToCustomerUrl                        =   BASEURL + "SetAnimaltoCustomer"
    let getgamesNamesAjaxSearchUrl              =   BASEURL + "GetGamesAjaxSearch"
    let endGameWSUrl                        =   BASEURL + "EndGamebyGameId?CustomerId="
     let deleteScheduleGameWSUrl                        =   BASEURL + "DeleteScheduledGame?GameId="
    let deleteAnimaltoCustomerWSUrl         =   BASEURL + "DeleteAnimaltoCustomer"
    let getMatchPlayDataUrl             = BASEURL + "GetMatchPlayData?GameId="
    let postMatchPlayDataUrl             = BASEURL + "SetTeamSelection"
    let postWolfGameSubmitUrl             = BASEURL + "SetWolfTeamSelection"
    let postLongSGameSubmitUrl             = BASEURL + "SetLongestShortestTeamSelection"
    let getNineSGameDataUrl             = BASEURL + "GetNineSData?GameId="
    let getStatesUrl                    = BASEURL + "GetStates"
    let postGameEPSSubmitUrl             = BASEURL + "AllPlayersScoreUpdate"
    let getGameRulesWS                =   BASEURL + "GetGameRulesById?Id="
    let postPressDataUrl             = BASEURL + "SetPress"
    let getPutzCardsUrl              =   BASEURL + "GetDeckNames"
    let addFunSubmitUrl         =   BASEURL + "SetPutzCardsToPlayers"
    let sendPutzCardUrl         =   BASEURL + "SendCardToAnotherPlayer"
    let sendPushNotificationUrl         =   BASEURL + "POST-TestNotification"
    let getPutzCardsURL             = BASEURL + "GetPutzCardsByCustomerId_GameId_CustomerId?GameId="
    let contactUsUrl         =   BASEURL + "Customer/ContactUsSubmit"
    let getNotificationsUrl         =   BASEURL + "Notifications/GetNotificationSettings?customerid="
    let sendNotificationsUrl         =   BASEURL + "Notifications/SetNotificationSettings"
    let getUnreadNotificationsUrl         =   BASEURL + "Notifications/GetUnreadNotificationsCount?UserId="
    let getAllNotificationsPurposeUrl         =   BASEURL + "Notifications/GetAllNotificationsByPurpose?UserId="
  
}
