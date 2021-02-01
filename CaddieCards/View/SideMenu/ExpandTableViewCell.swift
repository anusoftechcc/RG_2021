//
//  ExpandTableViewCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 14/11/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ExpandTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var arrowUpDownBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setExpanded() {
        statusButton.setImage(#imageLiteral(resourceName: "arrow_up"), for: .normal)
    }
    
    func setCollapsed() {
        statusButton.setImage(#imageLiteral(resourceName: "arrow_down-1"), for: .normal)
    }

}
