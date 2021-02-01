//
//  WebCastDataVC.swift
//  Merz
//
//  Created by Thukaram Vadde on 15/08/18.
//  Copyright © 2018 Thukaram. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel: Mappable {
    
    var Error : String?
    var ErrorMsg : String?
    var SuccessMsg : String?
    
    required init?(map: Map) {
        Error <- map["IsError"]
        ErrorMsg <- map["ErrorMessage"]
        SuccessMsg <- map["SSuccessMessage"]
    }
    
    func mapping(map: Map) {
        
    }
}

