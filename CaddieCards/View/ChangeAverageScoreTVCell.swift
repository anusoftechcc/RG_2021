//
//  ChangeAverageScoreTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit


class ChangeAverageScoreTVCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var avgScoreEditBtn: UIButton!
    @IBOutlet weak var avgScoreLbl: UILabel!

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
