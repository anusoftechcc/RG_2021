//
//  Constants.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 10/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import Foundation

struct GlobalConstants {
    
    //  COLOR CONSTANT
    static let APPCOLOR: UIColor = UIColor(red: 68.0/255.0, green: 67.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    static let APPNAVCOLOR: UIColor = UIColor(red: 68.0/255.0, green: 67.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    static let APPLIGHTGRAYCOLOR: UIColor = UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    static let APPGREENCOLOR: UIColor = UIColor(red: 0.0/255.0, green: 181.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    static let EDITPROFILELINECOLOR: UIColor = UIColor(red: 165.0/255.0, green: 184.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    static let PLAYGAMETABCOLORS: UIColor = UIColor(red: 0.0/255.0, green: 110.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    static let CELLBCKGROUNDCOLORS: UIColor = UIColor(red: 224.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    static let PURPLECOLORS: UIColor = UIColor(red: 212.0/255.0, green: 220.0/255.0, blue: 257.0/255.0, alpha: 1.0)
    static let RADIOBTNCOLORS: UIColor = UIColor(red: 1.0/255.0, green: 131.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    
    
    
    //  Device IPHONE
    static let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
    static let kIphone_5 : Bool =  (UIScreen.main.bounds.size.height == 568)
    static let kIphone_6 : Bool =  (UIScreen.main.bounds.size.height == 667)
    static let kIphone_6_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)
    
    static let kScreen_width : CGFloat =  UIScreen.main.bounds.size.width
    static let kScreen_height : CGFloat =  UIScreen.main.bounds.size.height
    
   // static let IMG_NAME: UIImage = UIImage.init(named: "") ??  ""
    
    //   Constant Variable.
    static let kBirthDate                     =    "DateOfBirth"
    static let kFirstName                     =    "FirstName"
    static let kLastName                      =    "LastName"
}
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
struct ConstantsString {
    static let InvisibleSign = "\u{200B}"
}
