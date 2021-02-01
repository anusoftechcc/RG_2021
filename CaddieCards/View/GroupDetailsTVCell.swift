//
//  GroupDetailsTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 30/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import SDWebImage

class GroupDetailsTVCell: UITableViewCell {
    
    @IBOutlet weak var frndNameLbl: UILabel!
    @IBOutlet weak var frndImgView: UIImageView!
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var addFrndBtn: UIButton!
    
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
        frndImgView.cornerRadius = frndImgView.frame.size.height/2
        frndImgView.clipsToBounds = true
    }
    func updateLabels(_ groupDict: NSDictionary) {
        
        let firstName =  (groupDict["FirstName"] as? String ?? "")
        frndNameLbl.text = firstName
        
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let userId =  (groupDict["GroupId"] as? String ?? "")
        let urlStr = String(format: "%@.gif?rd=%@",userId,String(diceRoll))
        let ProfilePicUrl = AVATARURL + urlStr
        frndImgView.sd_setImage(with: URL(string: ProfilePicUrl), completed: nil)
        if frndImgView.image == nil {
            frndImgView.image = UIImage.init(named: "avatar_male")
        }
        
        let userType =  (groupDict["UserType"] as? String ?? "")
        
        addFrndBtn.isHidden = true
        addFrndBtn.isEnabled = false
     //   messageBtn.isHidden = false
     //   messageBtn.isEnabled = true
     //   removeBtn.setImage(UIImage.init(named: "close_red"), for: .normal)
     //   removeBtn.setTitle("", for: .normal)
        
        if userType == "You" {
//            removeBtn.setImage(UIImage.init(named: ""), for: .normal)
//            removeBtn.setTitle("( You )", for: .normal)
//            removeBtn.isUserInteractionEnabled = false
//            messageBtn.isHidden = true
//            messageBtn.isEnabled = false
        }else if userType == "Add" {
            addFrndBtn.isHidden = false
            addFrndBtn.isEnabled = true
        }else {
            
        }
    }
    
}
