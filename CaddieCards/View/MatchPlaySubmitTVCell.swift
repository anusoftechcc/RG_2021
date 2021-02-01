//
//  MatchPlaySubmitTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class MatchPlaySubmitTVCell: UITableViewCell {

    
    @IBOutlet weak var thruLbl: UILabel!
    
    @IBOutlet weak var pressBView: UIView!
    @IBOutlet weak var pressBView_heightConst: NSLayoutConstraint!
    @IBOutlet weak var pressRightBtn: UIButton!
    @IBOutlet weak var pressLeftBtn: UIButton!
    
    @IBOutlet weak var thruBackBtn: UIButton!
    
    @IBOutlet weak var team1_player1Lbl: UILabel!
    @IBOutlet weak var team1_player2Lbl: UILabel!
    @IBOutlet weak var team1_player3Lbl: UILabel!
    
    @IBOutlet weak var team1_scoreLbl: UILabel!
    @IBOutlet weak var team2_scoreLbl: UILabel!
    @IBOutlet weak var noScoreLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    
    @IBOutlet weak var team2_player1Lbl: UILabel!
    @IBOutlet weak var team2_player2Lbl: UILabel!
    @IBOutlet weak var team2_player3Lbl: UILabel!
    
    @IBOutlet weak var playersViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pressBV_heightConstr: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
