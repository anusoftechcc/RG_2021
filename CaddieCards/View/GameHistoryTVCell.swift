//
//  GameHistoryTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/10/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GameHistoryTVCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var scoresBtn: UIButton!

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
       // profileImgView.cornerRadius = profileImgView.frame.size.height/2
      //  profileImgView.clipsToBounds = true
    }
    func updateLabels(_ friendDetails: NSDictionary) {
        /*
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let userId =  (friendDetails["GameId"] as? String ?? "")
        let urlStr = String(format: "%@.gif?rd=%@",userId,String(diceRoll))
        let ProfilePicUrl = AVATARURL + urlStr
        profileImgView.sd_setImage(with: URL(string: ProfilePicUrl), completed: nil)
        if profileImgView.image == nil {
            profileImgView.image = UIImage.init(named: "avatar_male")
        }
 */
        let gameName =  (friendDetails["GameName"] as? String ?? "")
        nameLbl.text = gameName
        
        let courseName =  (friendDetails["Course"] as? String ?? "")
        courseNameLbl.text = courseName
        
        let schDate =  (friendDetails["ScheduleDate"] as? String ?? "")
        let schTime = (friendDetails["ScheduleTime"] as? String ?? "")
        timeLbl.text = schDate + " " + schTime
    }
    
}
