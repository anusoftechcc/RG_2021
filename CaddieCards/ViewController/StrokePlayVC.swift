//
//  StrokePlayVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 21/02/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class StrokePlayVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    
    @IBOutlet weak var strokePlayTV: UITableView!
    var playGameDetailsDict = PlayGameModel(JSONString: "")
    var playGameModelDict = PlayGameDataModel(JSONString: "")
    var gameDatadict = NSMutableDictionary()
    var scoreboardArray = NSMutableArray()
    var playersArray = NSMutableArray()
    
    
    @IBOutlet weak var gameNameLbl: UILabel!
    var onCompletion: ((_ gameName: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strokePlayTV.delegate = self
        strokePlayTV.dataSource =  self
        strokePlayTV.tableFooterView = UIView()
        getScoreboardDetailsWS()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.playGameDetailsDict?.playPlayers.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sPCell = tableView.dequeueReusableCell(withIdentifier: "StrokePlayTVCell", for: indexPath) as! StrokePlayTVCell
        
        if indexPath.row%2 != 0 {
            sPCell.backgroundColor = GlobalConstants.PURPLECOLORS
        }
        
        let player = self.playGameDetailsDict?.playPlayers[indexPath.row]
        let cId = player?.customerId ?? ""
        print(cId)
        
        let fullName    = player?.plr ?? ""
        let fullNameArr = fullName.components(separatedBy: " ")
        var secondNameFL = ""
        let secondName = fullNameArr[1]
        if secondName.count > 1 {
            secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
            sPCell.playerLbl.text = "\(fullNameArr[0]) \(secondNameFL)"
        }else {
            sPCell.playerLbl.text = "\(fullNameArr[0])"
        }
        
        sPCell.handicapLbl.text = player?.hcp ?? ""
        sPCell.grossLbl.text = player?.grs ?? ""
        sPCell.netLbl.text  = player?.net ?? ""
        
        return sPCell
    }
    
    //MARK: - Web Service Methods
    func getScoreboardDetailsWS() {
        
        let urlString :  String =  MyStrings().getPlayGameDataUrl + "\(gameId)"
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            
            print(response as Any)
            
            let isError = response.isSuccess
            print(isError)
            guard isError == true else {
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                self.errorAlert(message!)
                return
            }
            print(response.responseDictionary)
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.playGameDetailsDict = PlayGameModel(JSONString: jsonString)
            
            let gameData = try! JSONSerialization.data(withJSONObject: dict["GameData"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let gameDataString = NSString(data: gameData, encoding: String.Encoding.utf8.rawValue)! as String
            self.playGameModelDict = PlayGameDataModel(JSONString: gameDataString)
            let gameName =  (self.playGameModelDict?.game ?? "")
            
            self.onCompletion?(gameName)
            // self.gameNameLbl.text = gameName
            
            self.strokePlayTV.reloadData()
        }
    }
    @IBAction func thruBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScorebordVC") as! ScorebordVC
        scoresVCObj.gameId = gameId
        self.navigationController?.pushViewController(scoresVCObj, animated: true)
    }
    @IBAction func enterScoreBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScorebordVC") as! ScorebordVC
        scoresVCObj.gameId = gameId
        self.navigationController?.pushViewController(scoresVCObj, animated: true)
    }
    
    //MARK: - Custome Methods
    func getFirstLattersOfSecondName(name : String) -> String {
        let firstChar = String(name.first!)
        print(firstChar)
        return firstChar
    }
}
