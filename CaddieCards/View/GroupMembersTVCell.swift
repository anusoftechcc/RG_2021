//
//  GroupMembersTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 01/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GroupMembersTVCell: UITableViewCell {

    @IBOutlet weak var GroupMemberCountLbl: UILabel!
    @IBOutlet weak var groupMemberNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLabels(_ memberName: String) {
        groupMemberNameLbl.text = memberName
    }
    
}
