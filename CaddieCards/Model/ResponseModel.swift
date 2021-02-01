//
//  ResponseModel.swift


import UIKit

/// Models for saving info about API response

class ResponseModel: NSObject {
    var customModel:Any!
    var responseDictionary:NSDictionary = NSDictionary()
    var responseCode:Int!
    var isSuccess:Bool = false
}
