//
//  EditPlayerScoreVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 18/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class EditPlayerScoreVC: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var holeCount: UILabel!
    @IBOutlet weak var scoreDWBtn: UIButton!
    @IBOutlet weak var parCount: UILabel!
    
    var name : String?
    var hole : String?
    var par : String?
    var score : String?
    var gameId: NSNumber = 0
    var customerId: NSNumber = 0
    var scoresArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "EDIT PLAYER SCORE"
        self.playerName.text = name ?? ""
        self.holeCount.text = hole ?? ""
        self.parCount.text = par ?? ""
        self.scoreDWBtn.setTitle(score ?? par ?? "5", for: .normal)
        scoresArray = scoreValues() as! [String]
    }
    
    @IBAction func scoreDWBtnTapped(_ sender: Any) {
        let configuration = FTConfiguration.shared
        let cellConfi = FTCellConfiguration()
        configuration.menuRowHeight = 40
        configuration.menuWidth =  200
        configuration.backgoundTintColor = UIColor.lightGray
        cellConfi.textColor = UIColor.white
        cellConfi.textFont = .systemFont(ofSize: 13)
        configuration.borderColor = UIColor.lightGray
        configuration.menuSeparatorColor = UIColor.white
        configuration.borderWidth = 0.5
        cellConfi.textAlignment = NSTextAlignment.center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.scoresArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.scoreDWBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
        }) {

        }
        
     
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        var scoreIntValue: NSNumber = 0
        guard let hole = self.holeCount.text, hole.count > 0 else {
            self.errorAlert("Please go back and select hole value")
            //  self.show(message: "Please go back and select hole value", controller: self)
            return
        }
        
        var params: Parameters = [
            "CustomerId": customerId,
            "GameId": gameId,
            "HoleName": hole,
            "Par": par ?? ""
        ]
        if let text = scoreDWBtn.titleLabel?.text {
            print(text)
            if text == "-" {
                params["Score"] = "-"
            }else {
                scoreIntValue = Int(text)! as NSNumber
                params["Score"] = scoreIntValue
            }
        }
        print("Save edit player score Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().editPlayerScoreDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK: - Custom Methods
    func scoreValues() -> NSArray {
        var array = [String]()
        array.append(String("-"))
        for i in 1...25 {
            array.append(String(i))
        }
        return array as NSArray
    }
}
