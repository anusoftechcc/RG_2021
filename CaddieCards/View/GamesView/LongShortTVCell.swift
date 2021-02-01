//
//  LongShortTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 04/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class LongShortTVCell: UITableViewCell {

    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var radioBtn_1: UIButton!
    @IBOutlet weak var radioBtn_2: UIButton!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
