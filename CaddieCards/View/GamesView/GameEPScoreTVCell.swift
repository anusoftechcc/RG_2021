//
//  GameEPScoreTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GameEPScoreTVCell: UITableViewCell {

    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var dot_1: UILabel!
    @IBOutlet weak var dot_2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        dot_1.cornerRadius = dot_1.frame.size.height/2
        dot_1.clipsToBounds = true
        
        dot_2.cornerRadius = dot_2.frame.size.height/2
        dot_2.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
