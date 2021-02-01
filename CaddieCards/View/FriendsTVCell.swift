//
//  FriendsTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 19/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import SDWebImage

class FriendsTVCell: UITableViewCell {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var gameInviteBtn: UIButton!
    @IBOutlet weak var groupBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        nameLbl.text = firstName + lastName
    }
}
