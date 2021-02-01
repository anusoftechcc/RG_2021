//
//  SelectGroupTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/06/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SelectGroupTVCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var addGroupBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLabels(_ groupDetails: NSDictionary) {
    let groupName =  (groupDetails["GroupName"] as? String ?? "")
    groupNameLbl.text = groupName
    }
    
}
