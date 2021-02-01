//
//  NassauSubmitTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/08/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NassauSubmitTVCell: UITableViewCell {
    
    @IBOutlet weak var holeView: UIView!
    @IBOutlet weak var tilleLbl: UILabel!
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
    
    @IBOutlet weak var pressRightBtn: UIButton!
    @IBOutlet weak var pressLeftBtn: UIButton!
    
    @IBOutlet weak var playersViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLbl_HeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateLabels(_ friendDetails: NSDictionary) {
        
        pressLeftBtn.isHidden = true
        pressRightBtn.isHidden = true
        titleLbl_HeightConst.constant = 48
        
        if friendDetails.allKeys.count == 0 {
            pressLeftBtn.isHidden = true
            pressRightBtn.isHidden = true
            
        }else {
            let teamNo = friendDetails["TeamNo"] as? Int
            if teamNo == 1 {
                titleLbl_HeightConst.constant = 60
                pressLeftBtn.isHidden = false
            }else if teamNo == 2 {
                titleLbl_HeightConst.constant = 60
                pressRightBtn.isHidden = false
            }else {
                titleLbl_HeightConst.constant = 48
                pressLeftBtn.isHidden = true
                pressRightBtn.isHidden = true
            }
        }
    }
}
