//
//  SwingSixsGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/09/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SwingSixsGameVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    
    @IBOutlet weak var swingSixsTV: UITableView!
    var swingSixsPlayModelDict = SwingSixsPlayGameModel(JSONString: "")
    var numberOfRows: NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swingSixsTV.register(UINib(nibName: "PressEnterScoreTVCell", bundle: nil), forCellReuseIdentifier: "PressEnterScoreTVCell")
        getswingSixsGameDetailsWS()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.numberOfRows == 1 {
            if section == 0 {
                return 1
            }else {
                if section == 1 {
                    let swing6sPress = self.swingSixsPlayModelDict?.swing6sPress[0]
                    return 1 + (swing6sPress?.pressed.count)!
                }else if section == 2 {
                    let swing6sPress = self.swingSixsPlayModelDict?.swing6sPress[1]
                    return 1 + (swing6sPress?.pressed.count)!
                }else {
                    let swing6sPress = self.swingSixsPlayModelDict?.swing6sPress[2]
                    return 1 + (swing6sPress?.pressed.count)!
                }
            }
        }else {
            return Int(truncating: self.numberOfRows)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NassauHeaderCell", for: indexPath) as! NassauHeaderCell
            
            // cell.thruLbl.text =  "Thru \(self.swingSixsPlayModelDict?.thru ?? "")\nEnter Score"
            cell.thruLbl.text =  "Thru \(self.swingSixsPlayModelDict?.thru ?? "")"
            cell.thruBackBtn.addTarget(self, action: #selector(thruBackBtnTapped(_:)), for: .touchUpInside)
            return cell
        }else {
            if indexPath.row == 0 {
                let nSCell = tableView.dequeueReusableCell(withIdentifier: "NassauSubmitTVCell", for: indexPath) as! NassauSubmitTVCell
                
                var holePlayers = self.swingSixsPlayModelDict?.holes[0]
                if indexPath.section == 2 {
                    holePlayers = self.swingSixsPlayModelDict?.holes[1]
                }else if indexPath.section == 3 {
                    holePlayers = self.swingSixsPlayModelDict?.holes[2]
                }
                nSCell.tilleLbl.text = holePlayers?.teamName ?? ""
                nSCell.noScoreLbl.isHidden = true
                if holePlayers?.team1 == "0" && holePlayers?.team2 == "0" {
                    nSCell.lineLbl.isHidden = true
                    nSCell.noScoreLbl.isHidden = false
                    nSCell.team1_scoreLbl.isHidden = true
                    nSCell.team2_scoreLbl.isHidden = true
                }else {
                    nSCell.lineLbl.isHidden = false
                    nSCell.noScoreLbl.isHidden = true
                    nSCell.team1_scoreLbl.isHidden = false
                    nSCell.team2_scoreLbl.isHidden = false
                    if holePlayers?.team2 == "0" {
                        nSCell.team1_scoreLbl.text =  "+\(holePlayers?.team1 ?? "0")"
                    }else {
                        nSCell.team2_scoreLbl.text = "+\(holePlayers?.team2 ?? "0")"
                    }
                }
                
                nSCell.team1_player1Lbl.isHidden = true
                nSCell.team1_player2Lbl.isHidden = true
                nSCell.team1_player3Lbl.isHidden = true
                nSCell.team2_player1Lbl.isHidden = true
                nSCell.team2_player2Lbl.isHidden = true
                nSCell.team2_player3Lbl.isHidden = true
                
                var index : Int = 0
                var index2 : Int = 0
                nSCell.playersViewHeightConstraint.constant = 35
                for tMembers in (holePlayers?.teamOneMembers)! {
                    for player in (self.swingSixsPlayModelDict?.players)! {
                        //    if player.team == "1" {
                        let fullName    = player.name ?? ""
                        let fullNameArr = fullName.components(separatedBy: " ")
                        var secondNameFL = ""
                        if tMembers.customerId == player.customerId {
                            if fullNameArr.count > 1 {
                                secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                            }
                            if index == 0 {
                                nSCell.team1_player1Lbl.isHidden = false
                                nSCell.team1_player1Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }else if index == 1 {
                                nSCell.playersViewHeightConstraint.constant = 70
                                nSCell.team1_player2Lbl.isHidden = false
                                nSCell.team1_player2Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }else {
                                nSCell.playersViewHeightConstraint.constant = 105
                                nSCell.team1_player3Lbl.isHidden = false
                                nSCell.team1_player3Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }
                            index += 1
                            break
                        }
                        //  }
                    }
                }
                for tMembers in (holePlayers?.teamTwoMembers)! {
                    for player in (self.swingSixsPlayModelDict?.players)! {
                        //   if player.team == "2" {
                        let fullName    = player.name ?? ""
                        let fullNameArr = fullName.components(separatedBy: " ")
                        var secondNameFL = ""
                        if tMembers.customerId == player.customerId {
                            if fullNameArr.count > 1 {
                                secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                            }
                            if index2 == 0 {
                             //   nSCell.playersViewHeightConstraint.constant = 35
                                nSCell.team2_player1Lbl.isHidden = false
                                nSCell.team2_player1Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }else if index2 == 1 {
                                nSCell.playersViewHeightConstraint.constant = 70
                                nSCell.team2_player2Lbl.isHidden = false
                                nSCell.team2_player2Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }else {
                                nSCell.playersViewHeightConstraint.constant = 105
                                nSCell.team2_player3Lbl.isHidden = false
                                nSCell.team2_player3Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                            }
                            index2 += 1
                            break
                        }
                        //    }
                    }
                }
                
                let swing6sPress = self.swingSixsPlayModelDict?.swing6sPress[indexPath.section-1]
                
                nSCell.updateLabels(swing6sPress!.showPress as NSDictionary)
                
                nSCell.pressRightBtn.addTarget(self, action: #selector(pressRightBtnTapped(_:)), for: .touchUpInside)
                nSCell.pressLeftBtn.addTarget(self, action: #selector(pressLeftBtnTapped(_:)), for: .touchUpInside)
                
                nSCell.pressRightBtn.layer.cornerRadius = 2
                nSCell.pressRightBtn.layer.borderWidth = 1
                nSCell.pressRightBtn.layer.borderColor = UIColor.white.cgColor
                
                nSCell.pressLeftBtn.layer.cornerRadius = 2
                nSCell.pressLeftBtn.layer.borderWidth = 1
                nSCell.pressLeftBtn.layer.borderColor = UIColor.white.cgColor
                /*
                 nSCell.holeView.layer.cornerRadius = 5
                 nSCell.holeView.layer.borderWidth = 1
                 nSCell.holeView.layer.borderColor = UIColor.lightGray.cgColor
                 */
                return nSCell
            }else {
                let swing6sPress = self.swingSixsPlayModelDict?.swing6sPress[indexPath.section-1]
                let press = swing6sPress?.pressed[indexPath.row - 1]
                /*
                if ((swing6sPress?.pressed.count ?? 0)! == indexPath.row) && (indexPath.section == 3) {
                    let pESCell = tableView.dequeueReusableCell(withIdentifier: "PressEnterScoreTVCell", for: indexPath) as! PressEnterScoreTVCell
                    pESCell.leftScoreLbl.text = ""
                    pESCell.rightScoreLbl.text = ""
                    pESCell.press_holeLbl.text = "Press Hole \(press!.holeNo ?? 0)"
                    if press!.teamNo == 1 {
                        pESCell.leftScoreLbl.text = "+\(press!.prevScore ?? "")"
                    }else {
                        pESCell.rightScoreLbl.text = "+\(press!.prevScore ?? "")"
                    }
                    pESCell.pressEnterScoreBtn.addTarget(self, action: #selector(enterScoreBtnTapped(_:)), for: .touchUpInside)
                    return pESCell
                }
 */
                
                let mPPCell = tableView.dequeueReusableCell(withIdentifier: "PressesTVCell", for: indexPath) as! PressesTVCell
                
                //  for (_, press) in ((swing6sPress?.pressed.enumerated())!) {
                mPPCell.leftScoreLbl.text = ""
                mPPCell.rightScoreLbl.text = ""
                mPPCell.press_holeLbl.text = "Press Hole \(press!.holeNo ?? 0)"
                if press!.teamNo == 1 {
                    mPPCell.leftScoreLbl.text = "+\(press!.prevScore ?? "")"
                }else {
                    mPPCell.rightScoreLbl.text = "+\(press!.prevScore ?? "")"
                }
                // }
                return mPPCell
            }
        }
    }
    //MARK: - Button Action methods
    @objc func thruBackBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.swingSixsPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @objc func pressRightBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.swingSixsTV)
        let indexPath = self.swingSixsTV.indexPathForRow(at: buttonPosition)
        let showPressDict = self.swingSixsPlayModelDict?.swing6sPress[indexPath!.section-1]
        var showP = NSDictionary()
        showP = showPressDict!.showPress as NSDictionary
        
        let params: Parameters = [
            "GameId": gameId,
            "TeamNo": 2,
            "HoleNo": showP["HoleNo"] as Any
        ]
        print("Press Post Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getswingSixsGameDetailsWS()
            }
        }
    }
    @objc func pressLeftBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.swingSixsTV)
        let indexPath = self.swingSixsTV.indexPathForRow(at: buttonPosition)
        let showPressDict = self.swingSixsPlayModelDict?.swing6sPress[indexPath!.section-1]
        var showP = NSDictionary()
        showP = showPressDict!.showPress as NSDictionary
        
        let params: Parameters = [
            "GameId": gameId,
            "TeamNo": 1,
            "HoleNo": showP["HoleNo"] as Any
        ]
        
        print("Press Post Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getswingSixsGameDetailsWS()
            }
        }
    }
    @objc func enterScoreBtnTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.swingSixsPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @IBAction func enterScoreBotBtnTapped(_ sender: Any) {
        self.enterScoreBtnTapped(UIButton.init())
    }
    
    //MARK: - Web service methods
    func getswingSixsGameDetailsWS() {
        
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
            
            let swingPlay = try! JSONSerialization.data(withJSONObject: dict["Swing6s"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let swingPlayString = NSString(data: swingPlay, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.swingSixsPlayModelDict = SwingSixsPlayGameModel(JSONString: swingPlayString)
            
            self.numberOfRows = 1
            self.swingSixsTV.reloadData()
        }
    }
    
    //MARK: - Custome Methods
    func getFirstLattersOfSecondName(name : String) -> String {
        if name != "" {
            let firstChar = String(name.first!)
            print(firstChar)
            return firstChar
        }else {
            return ""
        }
    }
}
