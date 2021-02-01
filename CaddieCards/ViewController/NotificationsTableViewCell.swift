//
//  NotificationsTableViewCell.swift
//  CaddieCards
//
//  Created by Mounika Reddy on 21/01/21.
//  Copyright © 2021 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
