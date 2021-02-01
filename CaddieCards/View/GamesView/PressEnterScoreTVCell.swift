//
//  PressEnterScoreTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 07/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class PressEnterScoreTVCell: UITableViewCell {

    @IBOutlet weak var press_holeLbl: UILabel!
    @IBOutlet weak var leftScoreLbl: UILabel!
    @IBOutlet weak var rightScoreLbl: UILabel!
    @IBOutlet weak var pressEnterScoreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
