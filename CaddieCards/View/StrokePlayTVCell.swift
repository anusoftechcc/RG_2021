//
//  StrokePlayTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 21/02/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class StrokePlayTVCell: UITableViewCell {

    
    @IBOutlet weak var playerLbl: UILabel!
    @IBOutlet weak var handicapLbl: UILabel!
    @IBOutlet weak var grossLbl: UILabel!
    @IBOutlet weak var netLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
