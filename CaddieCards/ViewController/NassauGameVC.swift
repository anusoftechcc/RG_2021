//
//  NassauGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 29/08/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NassauGameVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var nassauTV: UITableView!
    var nassauPlayModelDict = NassauPlayModel(JSONString: "")
    @IBOutlet weak var submitView: UIView!
    var radioSelDict = NSMutableArray()
    var numberOfRows: NSNumber = 0
    
    @IBOutlet weak var eneterScoreBotBtn_heightConst: NSLayoutConstraint!
    @IBOutlet weak var enterScoreBotBtn: UIButton!
    @IBOutlet weak var submitBtn_topConst: NSLayoutConstraint!
    
    @IBOutlet weak var submitBtn_heightConst: NSLayoutConstraint!
    
    @IBOutlet weak var enterScoreBotBtn_botConst: NSLayoutConstraint!
    @IBOutlet weak var enterScoreBotBtn_topConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nassauTV.tableFooterView = self.submitView
        nassauTV.register(UINib(nibName: "PressEnterScoreTVCell", bundle: nil), forCellReuseIdentifier: "PressEnterScoreTVCell")
        getnassauGameDetailsWS()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.nassauPlayModelDict?.teamSelection == "Yes" {
            return 2
        }
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.nassauPlayModelDict?.teamSelection == "Yes" {
            if section == 0 {
                return 1
            }
            return self.nassauPlayModelDict?.players.count ?? 0
        }else if self.nassauPlayModelDict?.teamSelection == "No" {
            if section == 0 {
                return 1
            }else {
                if section == 1 {
                    let swing6sPress = self.nassauPlayModelDict?.nassauPress[0]
                    return 1 + (swing6sPress?.pressed.count)!
                }else if section == 2 {
                    let swing6sPress = self.nassauPlayModelDict?.nassauPress[1]
                    return 1 + (swing6sPress?.pressed.count)!
                }else {
                    let swing6sPress = self.nassauPlayModelDict?.nassauPress[2]
                    return 1 + (swing6sPress?.pressed.count)!
                }
            }
        }else {
            return Int(truncating: self.numberOfRows)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.nassauPlayModelDict?.teamSelection == "Yes" {
            if indexPath.section == 0 {
                /*
                var cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
                if( !(cell != nil))
                {
                    cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HeaderCell")
                }
               // cell?.backgroundColor = GlobalConstants.PURPLECOLORS
 */
                let mPCell = tableView.dequeueReusableCell(withIdentifier: "MPHeaderTVCell", for: indexPath) as! MPHeaderTVCell
                mPCell.thruBtn.setTitle("Thru \(self.nassauPlayModelDict?.thru ?? "")", for: .normal)
                mPCell.thruBtn.addTarget(self, action: #selector(enterScoreBtnTapped(_:)), for: .touchUpInside)
                return mPCell
            }else {
                let mPCell = tableView.dequeueReusableCell(withIdentifier: "NassauGameTVCell", for: indexPath) as! NassauGameTVCell
                
                if indexPath.row%2 != 0 {
                    mPCell.backgroundColor = GlobalConstants.PURPLECOLORS
                }
                
                let player = self.nassauPlayModelDict?.players[indexPath.row]
                let cId = player?.customerId ?? ""
                print(cId)
                
                let fullName    = player?.name ?? ""
                if player?.name == "" || player?.name == nil {
                    mPCell.playerNameLbl.text = ""
                }else {
                    let fullNameArr = fullName.components(separatedBy: " ")
                    if fullNameArr.count > 1 {
                        let secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                        mPCell.playerNameLbl.text = "\(fullNameArr[0]) \(secondNameFL)"
                    }else {
                        mPCell.playerNameLbl.text = "\(fullNameArr[0])"
                    }
                }
                mPCell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                mPCell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                let dict = self.radioSelDict.object(at: indexPath.row) as! NSDictionary
                if dict["radioFirst"] as? String == "true" {
                    let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                    mPCell.radioBtn_1.setImage(image, for: .normal)
                    mPCell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
                }else if dict["radioSecond"] as? String == "true" {
                    let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                    mPCell.radioBtn_2.setImage(image, for: .normal)
                    mPCell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
                }
                mPCell.radioBtn_1.tag = 200 + indexPath.row
                mPCell.radioBtn_2.tag = 300 + indexPath.row
                
                mPCell.radioBtn_1.addTarget(self, action: #selector(radioBtnFTapped(_:)), for: .touchUpInside)
                mPCell.radioBtn_2.addTarget(self, action: #selector(radioBtnSTapped(_:)), for: .touchUpInside)
                return mPCell
            }
        }else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NassauHeaderCell", for: indexPath) as! NassauHeaderCell
                
                // cell.thruLbl.text =  "Thru \(self.nassauPlayModelDict?.thru ?? "")\nEnter Score"
                cell.thruLbl.text =  "Thru \(self.nassauPlayModelDict?.thru ?? "")"
                cell.thruBackBtn.addTarget(self, action: #selector(thruBackBtnTapped(_:)), for: .touchUpInside)
                return cell
            }else {
                if indexPath.row == 0 {
                    let nSCell = tableView.dequeueReusableCell(withIdentifier: "NassauSubmitTVCell", for: indexPath) as! NassauSubmitTVCell
                    
                    var holePlayers = self.nassauPlayModelDict?.holes[0]
                    if indexPath.section == 2 {
                        holePlayers = self.nassauPlayModelDict?.holes[1]
                    }else if indexPath.section == 3 {
                        holePlayers = self.nassauPlayModelDict?.holes[2]
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
                    for player in (self.nassauPlayModelDict?.players)! {
                        if player.team == "1" {
                            let fullName    = player.name ?? ""
                            let fullNameArr = fullName.components(separatedBy: " ")
                            var secondNameFL = ""
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
                        }else {
                            let fullName    = player.name ?? ""
                            let fullNameArr = fullName.components(separatedBy: " ")
                            var secondNameFL = ""
                            if fullNameArr.count > 1 {
                                secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                            }
                            if index2 == 0 {
                                //  nSCell.playersViewHeightConstraint.constant = 35
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
                        }
                    }
                    let swing6sPress = self.nassauPlayModelDict?.nassauPress[indexPath.section-1]
                    
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
                     nSCell.holeView.layer.borderWidth = 1
                     nSCell.holeView.layer.borderColor = UIColor.lightGray.cgColor
                     */
                    return nSCell
                }else {
                    let swing6sPress = self.nassauPlayModelDict?.nassauPress[indexPath.section-1]
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
    }
    
    //MARK: - Button action methods
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        let temsArray = NSMutableArray()
        
        for (index, item) in (self.radioSelDict.enumerated()) {
            let dict = item as! NSDictionary
            let temsDict = NSMutableDictionary()
            if dict["radioFirst"] as? String == "true" {
                let player = self.nassauPlayModelDict?.players[index]
                temsDict.setValue("1", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }else if dict["radioSecond"] as? String == "true" {
                let player = self.nassauPlayModelDict?.players[index]
                temsDict.setValue("2", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }
        }
        
        if temsArray.count == 1 {
            self.errorAlert("Each team should have atleast 1 player")
            return
        }
        if temsArray.count == 0 {
            self.errorAlert("Each team should have atleast 1 player")
            return
        }
        
        let params: Parameters = [
            "GameId": gameId,
            "Teams": temsArray
        ]
        print("Match play submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postMatchPlayDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getnassauGameDetailsWS()
            }
        }
    }
    @objc func radioBtnFTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.nassauTV)
        let indexPath = self.nassauTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.nassauTV.cellForRow(at: indexPath! as IndexPath) as! NassauGameTVCell
        if (cell.radioBtn_1.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            cell.radioBtn_1.setImage(image, for: .normal)
            cell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            dictChnaged.setValue("true", forKey: "radioFirst")
            dictChnaged.setValue("false", forKey: "radioSecond")
            
        }else {
            cell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            dictChnaged.setValue("false", forKey: "radioFirst")
            dictChnaged.setValue("false", forKey: "radioSecond")
        }
        self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
        self.nassauTV.reloadData()
        //   self.matchPlayTV.reloadRows(at: [indexPath!], with: .none)
    }
    @objc func radioBtnSTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.nassauTV)
        let indexPath = self.nassauTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.nassauTV.cellForRow(at: indexPath! as IndexPath) as! NassauGameTVCell
        if (cell.radioBtn_2.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            cell.radioBtn_2.setImage(image, for: .normal)
            cell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
            dictChnaged.setValue("false", forKey: "radioFirst")
            dictChnaged.setValue("true", forKey: "radioSecond")
        }else {
            cell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            dictChnaged.setValue("false", forKey: "radioFirst")
            dictChnaged.setValue("false", forKey: "radioSecond")
        }
        self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
        self.nassauTV.reloadData()
    }
    @objc func thruBackBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.nassauPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @objc func pressRightBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.nassauTV)
        let indexPath = self.nassauTV.indexPathForRow(at: buttonPosition)
        let showPressDict = self.nassauPlayModelDict?.nassauPress[indexPath!.section-1]
        var showP = NSDictionary()
        showP = showPressDict!.showPress as NSDictionary
        
        var holes18Show : Int = 1
        let holePlayers = self.nassauPlayModelDict?.holes[indexPath!.section-1]
        if holePlayers?.teamName == "Front 9" ||  holePlayers?.teamName == "Back 9" {
            let alert = UIAlertController(title: "Also press the '18 Holes'?", message: "", preferredStyle: .alert)
            alert.view.tintColor = GlobalConstants.APPGREENCOLOR
            
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                holes18Show = 0
                let params: Parameters = [
                    "GameId": self.gameId,
                    "TeamNo": 2,
                    "HoleNo": showP["HoleNo"] as Any,
                    "Holes18Show" : holes18Show
                ]
                print("Press Post Parameters = \(params)")
                
                self.startLoadingIndicator(loadTxt: "Loading...")
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        self.getnassauGameDetailsWS()
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
                holes18Show = 1
                let params: Parameters = [
                    "GameId": self.gameId,
                    "TeamNo": 2,
                    "HoleNo": showP["HoleNo"] as Any,
                    "Holes18Show" : holes18Show
                ]
                print("Press Post Parameters = \(params)")
                
                self.startLoadingIndicator(loadTxt: "Loading...")
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        self.getnassauGameDetailsWS()
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @objc func pressLeftBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.nassauTV)
        let indexPath = self.nassauTV.indexPathForRow(at: buttonPosition)
        let showPressDict = self.nassauPlayModelDict?.nassauPress[indexPath!.section-1]
        var showP = NSDictionary()
        showP = showPressDict!.showPress as NSDictionary
        
        var holes18Show : Int = 1
        let holePlayers = self.nassauPlayModelDict?.holes[indexPath!.section-1]
        if holePlayers?.teamName == "Front 9" ||  holePlayers?.teamName == "Back 9" {
            let alert = UIAlertController(title: "Also press the '18 Holes'?", message: "", preferredStyle: .alert)
            alert.view.tintColor = GlobalConstants.APPGREENCOLOR
            
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                holes18Show = 0
                let params: Parameters = [
                    "GameId": self.gameId,
                    "TeamNo": 1,
                    "HoleNo": showP["HoleNo"] as Any,
                    "Holes18Show" : holes18Show
                ]
                
                print("Press Post Parameters = \(params)")
                
                self.startLoadingIndicator(loadTxt: "Loading...")
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        self.getnassauGameDetailsWS()
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
                holes18Show = 1
                let params: Parameters = [
                    "GameId": self.gameId,
                    "TeamNo": 1,
                    "HoleNo": showP["HoleNo"] as Any,
                    "Holes18Show" : holes18Show
                ]
                
                print("Press Post Parameters = \(params)")
                
                self.startLoadingIndicator(loadTxt: "Loading...")
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        self.getnassauGameDetailsWS()
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func enterScoreBtnTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.nassauPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @IBAction func eneterScoreBotBtnTapped(_ sender: Any) {
        self.enterScoreBtnTapped(UIButton.init())
    }
    
    
    //MARK: - Web service methods
    func getnassauGameDetailsWS() {
        
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
            
            let nassauPlay = try! JSONSerialization.data(withJSONObject: dict["Nassau"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let nassauPlayString = NSString(data: nassauPlay, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.nassauPlayModelDict = NassauPlayModel(JSONString: nassauPlayString)
            let radioDict = NSMutableDictionary()
            for _ in (self.nassauPlayModelDict?.players)! {
                radioDict.setValue("false", forKey: "radioFirst")
                radioDict.setValue("false", forKey: "radioSecond")
                self.radioSelDict.add(radioDict)
                
            }
            self.numberOfRows = 1
            if self.nassauPlayModelDict?.teamSelection == "Yes" {
                self.nassauTV.tableFooterView = self.submitView
                self.eneterScoreBotBtn_heightConst.constant = 0
                self.enterScoreBotBtn_botConst.constant = 0
                self.enterScoreBotBtn_topConst.constant = 0
                self.enterScoreBotBtn.isHidden = true
            }else {
                    self.nassauTV.tableFooterView = UIView()
                self.eneterScoreBotBtn_heightConst.constant = 40
                self.enterScoreBotBtn_botConst.constant = 15
                self.enterScoreBotBtn_topConst.constant = 15
                self.enterScoreBotBtn.isHidden = false
            }
            print(self.radioSelDict)
            self.nassauTV.reloadData()
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
