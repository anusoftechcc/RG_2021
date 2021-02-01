//
//  NassauGameTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/08/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NassauGameTVCell: UITableViewCell {

    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet var radioBtnArray: [UIButton]!
    @IBOutlet weak var radioBtn_1: UIButton!
    @IBOutlet weak var radioBtn_2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
