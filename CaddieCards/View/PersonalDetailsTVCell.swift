//
//  PersonalDetailsTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 17/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class PersonalDetailsTVCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var personalDetailsEditBtn: UIButton!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var handicapLbl: UILabel!
    @IBOutlet weak var homecourseLbl: UILabel!
    @IBOutlet weak var averageScoreLbl: UILabel!
     @IBOutlet weak var rightHandedBtn: UIButton!
     @IBOutlet weak var leftHandedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layoutIfNeeded()
        let layer = shadowView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
    }
    
}
