//
//  NineSGameTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 13/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NineSGameTVCell: UITableViewCell {

    @IBOutlet weak var thruLbl: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var player_1: UILabel!
    @IBOutlet weak var player_2: UILabel!
    @IBOutlet weak var player_3: UILabel!
    @IBOutlet weak var player_scoere_1: UILabel!
    @IBOutlet weak var player_scoere_2: UILabel!
    @IBOutlet weak var player_scoere_3: UILabel!
    
    @IBOutlet var playerNamesLblArr: [UILabel]!
    @IBOutlet var playerScoreLblArr: [UILabel]!
    @IBOutlet weak var thruBackBtn: UIButton!
    
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
//        borderView.layer.cornerRadius = 5
//        borderView.layer.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR.cgColor
//        borderView.layer.borderWidth = 1
//        borderView.clipsToBounds = true
    }
}
