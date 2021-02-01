//
//  ActiveGameTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/04/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ActiveGameTVCell: UITableViewCell {

   
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var resumeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var endBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLabels(_ friendDetails: NSDictionary) {
        
        let gameName =  (friendDetails["GameName"] as? String ?? "")
        nameLbl.text = gameName
        
        let courseName =  (friendDetails["Course"] as? String ?? "")
        courseNameLbl.text = courseName
        
        let schDate =  (friendDetails["ScheduleDate"] as? String ?? "")
        let schTime = (friendDetails["ScheduleTime"] as? String ?? "")
        timeLbl.text = schDate + " " + schTime
    }
}
