//
//  SelectFrndTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SelectFrndTVCell: UITableViewCell {

    @IBOutlet weak var frndImgView: UIImageView!
    @IBOutlet weak var frndNameLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var addFrnd_switch: UISwitch!
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
        let lastName = (groupDict["LastName"] as? String ?? "")
        frndNameLbl.text = firstName + " " + lastName
        
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let userId =  (groupDict["UserId"] as? String ?? "")
        let urlStr = String(format: "%@.gif?rd=%@",userId,String(diceRoll))
        let ProfilePicUrl = AVATARURL + urlStr
        frndImgView.sd_setImage(with: URL(string: ProfilePicUrl), completed: nil)
        if frndImgView.image == nil {
            frndImgView.image = UIImage.init(named: "avatar_male")
        }
    }
    
}
