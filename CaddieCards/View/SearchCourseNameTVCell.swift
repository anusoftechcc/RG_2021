//
//  SearchCourseNameTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 03/07/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SearchCourseNameTVCell: UITableViewCell {

    
    @IBOutlet weak var courseNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateLabels(_ courseDetails: NSDictionary) {
        
        let courseName =  (courseDetails["CourseName"] as? String ?? "")
        courseNameLbl.text =  courseName
    }

}
