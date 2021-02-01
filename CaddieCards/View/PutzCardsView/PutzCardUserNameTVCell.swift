//
//  PutzCardUserNameTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 23/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class PutzCardUserNameTVCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
