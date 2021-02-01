//
//  SearchFrndTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 28/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SearchFrndTVCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var FriendsBtn: UIButton!

    @IBOutlet weak var playerIdLbl: UILabel!
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var courseName_Toplayout: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImgView.cornerRadius = profileImgView.frame.size.height/2
        profileImgView.clipsToBounds = true
    }
    func updateLabels(_ friendDetails: NSDictionary) {
        
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let userId =  (friendDetails["UserId"] as? String ?? "")
        let urlStr = String(format: "%@.gif?rd=%@",userId,String(diceRoll))
        let ProfilePicUrl = AVATARURL + urlStr
        profileImgView.sd_setImage(with: URL(string: ProfilePicUrl), completed: nil)
        if profileImgView.image == nil {
            profileImgView.image = UIImage.init(named: "avatar_male")
        }
        let firstName =  (friendDetails["FirstName"] as? String ?? "")
        let lastName = (friendDetails["LastName"] as? String ?? "")
        nameLbl.text = firstName + " " + lastName
        
        playerIdLbl.text = (friendDetails["UserId"] as? String ?? "")
        courseNameLbl.text = (friendDetails["HomeCourse"] as? String ?? "")
        if courseNameLbl.text == "" {
            courseName_Toplayout.constant = 0
        }else {
            courseName_Toplayout.constant = 10
        }
        getRequestTime(timeDict: (friendDetails["TimeSpan"] as? NSDictionary)!)
        
        let status =  (friendDetails["Status"] as? String ?? "")
        if status == "3" {
            acceptBtn.setTitle("Add Friend", for: .normal)
        }else if status == "2" {
            acceptBtn.setTitle("Request Sent", for: .normal)
        }else if status == "0"{
            acceptBtn.setTitle("Accept", for: .normal)
        }else if status == "1"{ //Added by andy dev 04292019
            acceptBtn.setTitle("Game Invite", for: .normal)
        }
    }
    func getRequestTime(timeDict: NSDictionary) {
        var reqTime: String = ""
        let years = timeDict["Years"] as! Int
        let months = timeDict["Months"] as! Int
        let weeks = timeDict["Weeks"] as! Int
        let days = timeDict["Days"] as! Int
        let hours = timeDict["Hours"] as! Int
        let minutes = timeDict["Minutes"] as! Int
        let seconds = timeDict["Seconds"] as! Int
        
        if years > 0 {
            if years > 1 {
                reqTime = String(years) + " Years ago"
            }else {
                reqTime = "1 Year ago"
            }
        }else if months > 0 {
            if months > 1 {
                reqTime = String(months) + " Months ago"
            }else {
                reqTime = "1 Month ago"
            }
        }else if weeks > 0 {
            if weeks > 1 {
                reqTime = String(weeks) + " Weeks ago"
            }else {
                reqTime = "1 Week ago"
            }
        }else if days > 0 {
            if days > 1 {
                reqTime = String(days) + " Days ago"
            }else {
                reqTime = "1 Day ago"
            }
        }else if hours > 0 {
            if hours > 1 {
                reqTime = String(hours) + " Hours ago"
            }else {
                reqTime = "1 Hour ago"
            }
        }else if minutes > 0 {
            if minutes > 1 {
                reqTime = String(minutes) + " Minutes ago"
            }else {
                reqTime = "1 Minute ago"
            }
        }else if seconds > 0 {
            if seconds > 1 {
                reqTime = String(seconds) + " Seconds ago"
            }else {
                reqTime = "1 Second ago"
            }
        }else {
            reqTime="" //reqTime="Just now"
        }
        dateLbl.text = reqTime
    }
}