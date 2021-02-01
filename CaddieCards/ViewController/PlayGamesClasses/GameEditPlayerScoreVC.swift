//
//  GameEditPlayerScoreVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 10/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import SwiftyPickerPopover

class GameEditPlayerScoreVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var holeLbl: UILabel!
    @IBOutlet weak var parLbl: UILabel!
    @IBOutlet weak var hcpLbl: UILabel!
    @IBOutlet weak var playersTV: UITableView!
    @IBOutlet weak var tv_heightConstraint: NSLayoutConstraint!
    var playGameDetailsDict = PlayGameModel(JSONString: "")
    
    var firstPScore : String = ""
    var secondPScore : String = ""
    var thardPScore : String = ""
    var fourthPScore : String = ""
    var fifthPScore : String = ""
    var thruValue : Int = 0
    var scoresArray = [String]()
    var hole : String = ""
    var par : String = ""
    var hcp : String = ""
    var scoreHoleIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "EDIT PLAYER SCORE"
        playersTV.tableFooterView = UIView.init()
        
        scoresArray = scoreValues() as! [String]
        getScoreDetailsWS()
        
    }
    override func updateViewConstraints() {
        tv_heightConstraint.constant = playersTV.contentSize.height
        super.updateViewConstraints()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = self.playersTV.cellForRow(at: indexPath! as IndexPath) as! GameEPScoreTVCell
//        cell.scoreBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
//        let p = StringPickerPopover(title: "", choices: self.scoresArray)
//                                .setSelectedRow(1)
//                                .setDoneButton(title:"👌", action: { (popover, selectedRow, selectedString) in print("done row \(selectedRow) \(selectedString)") })
//                                .setCancelButton(title:"🗑", action: { (_, _, _) in print("cancel")} )
      
//                p.appear(originView: cell, baseViewWhenOriginViewHasNoSuperview , baseViewController: self)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playGameDetailsDict?.scoreBoard[0].players.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gameEPSell = tableView.dequeueReusableCell(withIdentifier: "GameEPScoreTVCell", for: indexPath) as! GameEPScoreTVCell
        
        var scorecard = self.playGameDetailsDict?.scoreBoard[0]
        if self.par != "" {
            scorecard = self.playGameDetailsDict?.scoreBoard[self.scoreHoleIndex]
        }else {
            scorecard = self.playGameDetailsDict?.scoreBoard[self.thruValue - 1]
        }
        
        let player = scorecard!.players[indexPath.row]
        let cId = player.customerId ?? ""
        
        let fullName = player.name ?? ""
        let fullNameArr = fullName.components(separatedBy: " ")
        var nameStr = ""
        if fullNameArr.count > 1 {
            nameStr = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
        }
        nameStr = fullNameArr[0].capitalizingFirstLetter() + " " + nameStr
        
        gameEPSell.playerNameLbl.text = nameStr
        
        gameEPSell.dot_2.isHidden = true
        gameEPSell.dot_1.isHidden = true
        if player.dots == 1 {
            gameEPSell.dot_1.isHidden = false
        }else if player.dots == 2 {
            gameEPSell.dot_1.isHidden = false
            gameEPSell.dot_2.isHidden = false
        }
        
        let playerScore = scorecard!.players[indexPath.row]
//        if playerScore.score == "" {
//            gameEPSell.scoreBtn.setTitle("-", for: .normal)
//        }else {
//            gameEPSell.scoreBtn.setTitle(playerScore.score, for: .normal)
//        }
        var  btnTitle = playerScore.score ?? ""
        if btnTitle.count == 0 {
            btnTitle = scorecard?.par ?? "_"
        }
        gameEPSell.scoreBtn.setTitle(btnTitle, for: .normal)
        if indexPath.row == 0 {
            if playerScore.score == "-" {
                self.firstPScore = ""
            }else {
                self.firstPScore = playerScore.score ?? ""
            }
        }else if indexPath.row == 1 {
            if playerScore.score == "-" {
                self.secondPScore = ""
            }else {
                self.secondPScore = playerScore.score ?? ""
            }
        }else if indexPath.row == 2 {
            if playerScore.score == "-" {
                self.thardPScore = ""
            }else {
                self.thardPScore = playerScore.score ?? ""
            }
        }else if indexPath.row == 3 {
            if playerScore.score == "-" {
                self.fourthPScore = ""
            }else {
                self.fourthPScore = playerScore.score ?? ""
            }
        }else if indexPath.row == 4 {
            if playerScore.score == "-" {
                self.fifthPScore = ""
            }else {
                self.fifthPScore = playerScore.score ?? ""
            }
        }
        
        gameEPSell.scoreBtn.tag = indexPath.row
        gameEPSell.scoreBtn.addTarget(self, action: #selector(selectScoreBtnTapped(_:)), for: .touchUpInside)
        
        return gameEPSell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }
    //MARK: - Web service methods
    func getScoreDetailsWS() {
        
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        let urlString :  String =  MyStrings().getPlayGameDataFromCreateGameUrl + "\(gameId)" + "&customerid=" + "\(custId)"
        
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
            
            if self.par != "" {
                self.parLbl.text = "PAR \(self.par)"
                self.hcpLbl.text = "HCP \(self.hcp)"
                self.holeLbl.text = "Hole \(self.hole)"
                self.thruValue = Int(self.hole) ?? 0
            }else {
                let scorecard = self.playGameDetailsDict?.scoreBoard[self.thruValue - 1]
                self.parLbl.text = "PAR \(scorecard?.par ?? "")"
                self.hcpLbl.text = "HCP \(scorecard?.hcp ?? "")"
                self.holeLbl.text = "Hole \(self.thruValue)"
            }
            
            self.tv_heightConstraint.constant = CGFloat((self.playGameDetailsDict?.scoreBoard[0].players.count)!*80)
            self.playersTV.reloadData()
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
    func getFirstLattersOfSecondName(name : String) -> String {
        if name != "" {
            let firstChar = String(name.first!)
            print(firstChar)
            return firstChar
        }else {
            return ""
        }
    }
    //MARK: - Button action Methods
    @objc func selectScoreBtnTapped(_ sender: UIButton) {
//        let configuration = FTConfiguration.shared
//        let cellConfi = FTCellConfiguration()
//        configuration.menuRowHeight = 40
//        configuration.menuWidth =  200
//        configuration.backgoundTintColor = UIColor.lightGray
//        cellConfi.textColor = UIColor.white
//        cellConfi.textFont = .systemFont(ofSize: 13)
//        configuration.borderColor = UIColor.lightGray
//        configuration.menuSeparatorColor = UIColor.white
//        configuration.borderWidth = 0.5
//        cellConfi.textAlignment = NSTextAlignment.center
//        FTPopOverMenu.showForSender(sender: sender as UIView,
//                                    with: self.scoresArray,
//                                    done: { (selectedIndex) -> () in
//                                        print(selectedIndex)
//                                        if selectedIndex < self.scoresArray.count {
//                                            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.playersTV)
//                                            let indexPath = self.playersTV.indexPathForRow(at: buttonPosition)
//                                            let cell = self.playersTV.cellForRow(at: indexPath! as IndexPath) as! GameEPScoreTVCell
//                                            cell.scoreBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
//                                            if indexPath?.row == 0 {
//                                                if self.scoresArray[selectedIndex] == "-" {
//                                                    self.firstPScore = ""
//                                                }else {
//                                                    self.firstPScore = self.scoresArray[selectedIndex]
//                                                }
//                                            }else if indexPath?.row == 1 {
//                                                if self.scoresArray[selectedIndex] == "-" {
//                                                    self.secondPScore = ""
//                                                }else {
//                                                    self.secondPScore = self.scoresArray[selectedIndex]
//                                                }
//                                            }else if indexPath?.row == 2 {
//                                                if self.scoresArray[selectedIndex] == "-" {
//                                                    self.thardPScore = ""
//                                                }else {
//                                                    self.thardPScore = self.scoresArray[selectedIndex]
//                                                }
//                                            }else if indexPath?.row == 3 {
//                                                if self.scoresArray[selectedIndex] == "-" {
//                                                    self.fourthPScore = ""
//                                                }else {
//                                                    self.fourthPScore = self.scoresArray[selectedIndex]
//                                                }
//                                            }else if indexPath?.row == 4 {
//                                                if self.scoresArray[selectedIndex] == "-" {
//                                                    self.fifthPScore = ""
//                                                }else {
//                                                    self.fifthPScore = self.scoresArray[selectedIndex]
//                                                }
//                                            }
//                                        }
//        }) {
//        }
        
//        setDoneButton(
//            font: UIFont.boldSystemFont(ofSize: 16),
//            color: UIColor.orange,
//            action: { popover, selectedRow, selectedString in
//                print("done row \(selectedRow) \(selectedString)")
//                self.selectedRow = selectedRow
//
//        })
        
        let popOver = StringPickerPopover(title: "", choices: self.scoresArray)
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = self.playersTV.cellForRow(at: indexPath as IndexPath) as! GameEPScoreTVCell
        let btnTitle = cell.scoreBtn.titleLabel?.text ?? ""
        popOver.setSelectedRow(Int(self.scoresArray.firstIndex(of: btnTitle) ?? 0))
//        popOver.setValueChange { (_, index, selectedString) in
//            print("current string: \(selectedString)")
//        }
        popOver.setFont(UIFont(name: "OpenSans", size: 20)!)
          popOver.setDoneButton(title: "Done", font: UIFont(name: "OpenSans", size: 20), color: .white) { (popoverType, selectedIndex, selectedString) in
            if selectedIndex < self.scoresArray.count {
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.playersTV)
                let indexPath = self.playersTV.indexPathForRow(at: buttonPosition)
                let cell = self.playersTV.cellForRow(at: indexPath! as IndexPath) as! GameEPScoreTVCell
                cell.scoreBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
                if indexPath?.row == 0 {
                    if self.scoresArray[selectedIndex] == "-" {
                        self.firstPScore = ""
                    }else {
                        self.firstPScore = self.scoresArray[selectedIndex]
                    }
                }else if indexPath?.row == 1 {
                    if self.scoresArray[selectedIndex] == "-" {
                        self.secondPScore = ""
                    }else {
                        self.secondPScore = self.scoresArray[selectedIndex]
                    }
                }else if indexPath?.row == 2 {
                    if self.scoresArray[selectedIndex] == "-" {
                        self.thardPScore = ""
                    }else {
                        self.thardPScore = self.scoresArray[selectedIndex]
                    }
                }else if indexPath?.row == 3 {
                    if self.scoresArray[selectedIndex] == "-" {
                        self.fourthPScore = ""
                    }else {
                        self.fourthPScore = self.scoresArray[selectedIndex]
                    }
                }else if indexPath?.row == 4 {
                    if self.scoresArray[selectedIndex] == "-" {
                        self.fifthPScore = ""
                    }else {
                        self.fifthPScore = self.scoresArray[selectedIndex]
                    }
                }
            }
            //self.firstPScore = self.scoresArray[selectedRow]
        }
        popOver.setCancelButton(title: "", font: .systemFont(ofSize: 0), color: .clear) { (_, _, _) in
            
        }
//        popOver.setCancelButton { (_, _,_ ) in
//
//        }
       // popOver.setFont(UIFont.systemFont(ofSize: 14))
//        popOver.appear(originView: sender as UIView, baseViewController: self)
        
//        popOver.appear(originView: sender as UIView, baseViewWhenOriginViewHasNoSuperview: sender as UIView, baseViewController: self) {
//
//        }
        
        popOver.appear(originView: sender as UIView, baseViewWhenOriginViewHasNoSuperview: playersTV, baseViewController: self, completion: nil)
        
        popOver.disappearAutomatically(after: 300.0, completion: { print("automatically hidden")} )
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        let temsArray = NSMutableArray()
        var scorecard = self.playGameDetailsDict?.scoreBoard[0]
        if self.par != "" {
            scorecard = self.playGameDetailsDict?.scoreBoard[self.scoreHoleIndex]
        }else {
            scorecard = self.playGameDetailsDict?.scoreBoard[self.thruValue - 1]
        }
        var i = 0
        for player in (scorecard!.players) {
            let temsDict = NSMutableDictionary()
            
            if i == 0 {
                var fisrtS = self.firstPScore
                if fisrtS == "" {
                    fisrtS = scorecard?.par ?? "-"
                }
                temsDict.setValue(fisrtS, forKey: "Score")
            }else if i == 1 {
                var secondS = self.secondPScore
                if secondS == "" {
                    secondS = scorecard?.par ?? "-"
                }
                temsDict.setValue(secondS, forKey: "Score")
            }
            else if i == 2 {
                var thirdS = self.thardPScore
                if thirdS == "" {
                    thirdS = scorecard?.par ?? "-"
                }
                temsDict.setValue(thirdS, forKey: "Score")
            }
            else if i == 3 {
                var fourthS = self.fourthPScore
                if fourthS == "" {
                    fourthS = scorecard?.par ?? "-"
                }
                temsDict.setValue(fourthS, forKey: "Score")
            }
            else if i == 4 {
                var fifthS = self.fifthPScore
                if fifthS == "" {
                    fifthS = scorecard?.par ?? "-"
                }
                temsDict.setValue(fifthS, forKey: "Score")
            }
            temsDict.setValue(player.customerId, forKey: "CustomerId")
            temsArray.add(temsDict)
            i += 1
        }
        
        let params: Parameters = [
            "HoleNumber": thruValue,
            "GameId": gameId,
            "Players": temsArray
        ]
        
        print("GameEditPlayScore submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postGameEPSSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
