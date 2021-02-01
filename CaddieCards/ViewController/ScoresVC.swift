//
//  ScoresVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ScoresVC: UIViewController {

    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "SCORES"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
