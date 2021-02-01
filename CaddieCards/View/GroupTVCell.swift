//
//  GroupTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 19/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GroupTVCell: UITableViewCell {

    @IBOutlet weak var deleteGroupBtn: UIButton!
    @IBOutlet weak var gameInviteBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var groupNavBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLabels(_ groupDict: NSDictionary) {
        
        let firstName =  (groupDict["GroupName"] as? String ?? "")
        groupNameLbl.text = firstName
    }
    
}
