//
//  MatchPlayVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class MatchPlayVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var matchPlayTV: UITableView!
    var matchPlayModelDict = MatchPlayModel(JSONString: "")
    @IBOutlet weak var submitView: UIView!
    var radioSelDict = NSMutableArray()
    var numberOfRows: NSNumber = 0
    var playGameDetailsDict = PlayGameModel(JSONString: "")
    var showPressBtnLeft: Bool = true
    @IBOutlet weak var eneterScoreBotBtn_heightConst: NSLayoutConstraint!
    @IBOutlet weak var enterScoreBotBtn: UIButton!
    @IBOutlet weak var submitBtn_topConst: NSLayoutConstraint!
    
    @IBOutlet weak var submitBtn_heightConst: NSLayoutConstraint!
    @IBOutlet weak var enterScoreBotBtn_botConst: NSLayoutConstraint!
    @IBOutlet weak var enterScoreBotBtn_topConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchPlayTV.tableFooterView = self.submitView
        matchPlayTV.register(UINib(nibName: "PressEnterScoreTVCell", bundle: nil), forCellReuseIdentifier: "PressEnterScoreTVCell")
        
        getMatchPlayDetailsWS()
    }
    override func viewDidLayoutSubviews() {
        
    }
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.matchPlayModelDict?.teamSelection == "Yes" {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.matchPlayModelDict?.teamSelection == "Yes" {
            if section == 0 {
                return 1
            }
            return self.matchPlayModelDict?.players.count ?? 0
        }
        return Int(truncating: self.numberOfRows) + (self.playGameDetailsDict?.press.count ?? 0)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.matchPlayModelDict?.teamSelection == "Yes" {
            if indexPath.section == 0 {
                let mPCell = tableView.dequeueReusableCell(withIdentifier: "MPHeaderTVCell", for: indexPath) as! MPHeaderTVCell
              //  cell?.backgroundColor = UIColor(red: 0.0/255.0, green: 110.0/255.0, blue: 207.0/255.0, alpha: 1.0)//GlobalConstants.PURPLECOLORS
                mPCell.thruBtn.setTitle("Thru \(self.matchPlayModelDict?.thru ?? "")", for: .normal)
                mPCell.thruBtn.addTarget(self, action: #selector(enterScoreBtnTapped(_:)), for: .touchUpInside)
                return mPCell
            }else {
                let mPCell = tableView.dequeueReusableCell(withIdentifier: "MatchPlayTVCell", for: indexPath) as! MatchPlayTVCell
                
                if indexPath.row%2 != 0 {
                    mPCell.backgroundColor = GlobalConstants.PURPLECOLORS
                }
                
                let player = self.matchPlayModelDict?.players[indexPath.row]
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
            if indexPath.row == 0 {
                let mPSCell = tableView.dequeueReusableCell(withIdentifier: "MatchPlaySubmitTVCell", for: indexPath) as! MatchPlaySubmitTVCell
                
                // mPSCell.thruLbl.text = "Thru \(self.matchPlayModelDict?.thru ?? "")\nEnter Score"
                mPSCell.thruLbl.text = "Thru \(self.matchPlayModelDict?.thru ?? "")"
                mPSCell.noScoreLbl.isHidden = true
                if self.matchPlayModelDict?.team1 == "0" && self.matchPlayModelDict?.team2 == "0" {
                    mPSCell.lineLbl.isHidden = true
                    mPSCell.noScoreLbl.isHidden = false
                    mPSCell.team1_scoreLbl.isHidden = true
                    mPSCell.team2_scoreLbl.isHidden = true
                }else {
                    mPSCell.lineLbl.isHidden = false
                    mPSCell.noScoreLbl.isHidden = true
                    mPSCell.team1_scoreLbl.isHidden = false
                    mPSCell.team2_scoreLbl.isHidden = false
                    if self.matchPlayModelDict?.team2 == "0" {
                        mPSCell.team1_scoreLbl.text =  "+\(self.matchPlayModelDict?.team1 ?? "0")"
                    }else {
                        mPSCell.team2_scoreLbl.text = "+\(self.matchPlayModelDict?.team2 ?? "0")"
                    }
                }
                mPSCell.team1_player1Lbl.isHidden = true
                mPSCell.team1_player2Lbl.isHidden = true
                mPSCell.team1_player3Lbl.isHidden = true
                mPSCell.team2_player1Lbl.isHidden = true
                mPSCell.team2_player2Lbl.isHidden = true
                mPSCell.team2_player3Lbl.isHidden = true
                
                var index : Int = 0
                var index2 : Int = 0
                mPSCell.playersViewHeightConstraint.constant = 35
                for player in (self.matchPlayModelDict?.players)! {
                    if player.team == "1" {
                        let fullName    = player.name ?? ""
                        let fullNameArr = fullName.components(separatedBy: " ")
                        var secondNameFL = ""
                        if fullNameArr.count > 1 {
                            secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                        }
                        if index == 0 {
                            mPSCell.team1_player1Lbl.isHidden = false
                            mPSCell.team1_player1Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                        }else if index == 1 {
                            mPSCell.playersViewHeightConstraint.constant = 70
                            mPSCell.team1_player2Lbl.isHidden = false
                            mPSCell.team1_player2Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                        }else {
                            mPSCell.playersViewHeightConstraint.constant = 105
                            mPSCell.team1_player3Lbl.isHidden = false
                            mPSCell.team1_player3Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
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
                            mPSCell.team2_player1Lbl.isHidden = false
                            mPSCell.team2_player1Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                        }else if index2 == 1 {
                            mPSCell.playersViewHeightConstraint.constant = 70
                            mPSCell.team2_player2Lbl.isHidden = false
                            mPSCell.team2_player2Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                        }else {
                            mPSCell.playersViewHeightConstraint.constant = 105
                            mPSCell.team2_player3Lbl.isHidden = false
                            mPSCell.team2_player3Lbl.text = "\(fullNameArr[0].capitalizingFirstLetter()) \(secondNameFL) (\(player.hcp ?? ""))"
                        }
                        index2 += 1
                    }
                }
                
                mPSCell.thruLbl.layer.cornerRadius = 3
                mPSCell.thruLbl.clipsToBounds = true
                
                /*
                 mPSCell.playersView.layer.cornerRadius = 3
                 mPSCell.playersView.layer.borderWidth = 1
                 mPSCell.playersView.layer.borderColor = UIColor.gray.cgColor
                 */
                
                mPSCell.thruBackBtn.addTarget(self, action: #selector(thruBackBtnTapped(_:)), for: .touchUpInside)
                mPSCell.pressBView.isHidden = false
                if self.playGameDetailsDict?.showPress.count == 0 {
                    mPSCell.pressBView.isHidden = true
                    mPSCell.pressBView_heightConst.constant = 0
                }else {
                    if self.showPressBtnLeft == true {
                        mPSCell.pressLeftBtn.isHidden = false
                        mPSCell.pressRightBtn.isHidden = true
                    }else {
                        mPSCell.pressLeftBtn.isHidden = true
                        mPSCell.pressRightBtn.isHidden = false
                    }
                    mPSCell.pressRightBtn.addTarget(self, action: #selector(pressRightBtnTapped(_:)), for: .touchUpInside)
                    mPSCell.pressLeftBtn.addTarget(self, action: #selector(pressLeftBtnTapped(_:)), for: .touchUpInside)
                    mPSCell.pressRightBtn.layer.cornerRadius = 2
                    mPSCell.pressRightBtn.layer.borderWidth = 1
                    mPSCell.pressRightBtn.layer.borderColor = UIColor.white.cgColor
                    
                    mPSCell.pressLeftBtn.layer.cornerRadius = 2
                    mPSCell.pressLeftBtn.layer.borderWidth = 1
                    mPSCell.pressLeftBtn.layer.borderColor = UIColor.white.cgColor
                }
                return mPSCell
            }else {
                let press = self.playGameDetailsDict?.press[indexPath.row - 1]
                /*
                if (self.playGameDetailsDict?.press.count ?? 0)! == indexPath.row {
                    let pESCell = tableView.dequeueReusableCell(withIdentifier: "PressEnterScoreTVCell", for: indexPath) as! PressEnterScoreTVCell
                    pESCell.leftScoreLbl.text = ""
                    pESCell.rightScoreLbl.text = ""
                    pESCell.press_holeLbl.text = "Press Hole \(press?.holeNo ?? 0)"
                    if press?.teamNo == 1 {
                        pESCell.leftScoreLbl.text = "+\(press?.prevScore ?? "")"
                    }else {
                        pESCell.rightScoreLbl.text = "+\(press?.prevScore ?? "")"
                    }
                    pESCell.pressEnterScoreBtn.addTarget(self, action: #selector(enterScoreBtnTapped(_:)), for: .touchUpInside)
                    return pESCell
                }
                */
                let mPPCell = tableView.dequeueReusableCell(withIdentifier: "PressesTVCell", for: indexPath) as! PressesTVCell
                
                mPPCell.leftScoreLbl.text = ""
                mPPCell.rightScoreLbl.text = ""
                mPPCell.press_holeLbl.text = "Press Hole \(press?.holeNo ?? 0)"
                if press?.teamNo == 1 {
                    mPPCell.leftScoreLbl.text = "+\(press?.prevScore ?? "")"
                }else {
                    mPPCell.rightScoreLbl.text = "+\(press?.prevScore ?? "")"
                }
                
                return mPPCell
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
                let player = self.matchPlayModelDict?.players[index]
                temsDict.setValue("1", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }else if dict["radioSecond"] as? String == "true" {
                let player = self.matchPlayModelDict?.players[index]
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
                self.getMatchPlayDetailsWS()
            }
        }
    }
    @objc func radioBtnFTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.matchPlayTV)
        let indexPath = self.matchPlayTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.matchPlayTV.cellForRow(at: indexPath! as IndexPath) as! MatchPlayTVCell
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
        self.matchPlayTV.reloadData()
        //   self.matchPlayTV.reloadRows(at: [indexPath!], with: .none)
    }
    @objc func radioBtnSTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.matchPlayTV)
        let indexPath = self.matchPlayTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.matchPlayTV.cellForRow(at: indexPath! as IndexPath) as! MatchPlayTVCell
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
        self.matchPlayTV.reloadData()
    }
    @objc func thruBackBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.matchPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @IBAction func headerCellThruBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.matchPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @objc func pressRightBtnTapped(_ sender: UIButton) {
        
        let showPressDict = self.playGameDetailsDict?.showPress[0]
        let params: Parameters = [
            "GameId": gameId,
            "TeamNo": 2,
            "HoleNo": showPressDict!.holeNo as Any
        ]
        print("Press Post Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getMatchPlayDetailsWS()
            }
        }
    }
    @objc func pressLeftBtnTapped(_ sender: UIButton) {
        let showPressDict = self.playGameDetailsDict?.showPress[0]
        let params: Parameters = [
            "GameId": gameId,
            "TeamNo": 1,
            "HoleNo": showPressDict!.holeNo as Any
        ]
        
        print("Press Post Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postPressDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getMatchPlayDetailsWS()
            }
        }
    }
    @objc func enterScoreBtnTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.matchPlayModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @IBAction func eneterScoreBotBtnTapped(_ sender: Any) {
        self.enterScoreBtnTapped(UIButton.init())
    }
    //MARK: - Web service methods
    func getMatchPlayDetailsWS() {
        
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
            
            let matchPlay = try! JSONSerialization.data(withJSONObject: dict["MatchPlay"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let matchPlayString = NSString(data: matchPlay, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.matchPlayModelDict = MatchPlayModel(JSONString: matchPlayString)
            let radioDict = NSMutableDictionary()
            for _ in (self.matchPlayModelDict?.players)! {
                radioDict.setValue("false", forKey: "radioFirst")
                radioDict.setValue("false", forKey: "radioSecond")
                self.radioSelDict.add(radioDict)
                
            }
            self.numberOfRows = 1
            if self.matchPlayModelDict?.teamSelection == "Yes" {
                self.matchPlayTV.tableFooterView = self.submitView
                self.eneterScoreBotBtn_heightConst.constant = 0
                self.enterScoreBotBtn_botConst.constant = 0
                self.enterScoreBotBtn_topConst.constant = 0
                self.enterScoreBotBtn.isHidden = true
            }else {
                    self.matchPlayTV.tableFooterView = UIView()
                self.eneterScoreBotBtn_heightConst.constant = 40
                self.enterScoreBotBtn_botConst.constant = 15
                self.enterScoreBotBtn_topConst.constant = 15
                self.enterScoreBotBtn.isHidden = false
            }
            print(self.radioSelDict)
            let jsonData2 = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
            self.playGameDetailsDict = PlayGameModel(JSONString: jsonString2)
            for (_, item) in ((self.playGameDetailsDict?.showPress.enumerated())!) {
                if item.teamNo == 1 {
                    self.showPressBtnLeft = true
                }else {
                    self.showPressBtnLeft = false
                }
            }
            self.matchPlayTV.reloadData()
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
