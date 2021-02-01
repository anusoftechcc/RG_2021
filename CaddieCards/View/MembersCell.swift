//
//  MembersCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/06/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {

    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
