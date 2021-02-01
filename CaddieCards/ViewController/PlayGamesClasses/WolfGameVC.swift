//
//  WolfGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class WolfGameVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var holeTeamSubmitBtn: UIButton!
    
    @IBOutlet weak var wolfTV: UITableView!
    var wolfModelDict = WolfGameModel(JSONString: "")
    @IBOutlet weak var submitView: UIView!
    var radioSelDict = NSMutableArray()
    var wolfRadioSelArray = NSMutableArray()
    var numberOfRows: NSNumber = 0
    @IBOutlet weak var thruLbl: UILabel!
    
    @IBOutlet weak var loneWolfGBBtn: UIButton!
    var onCompletion: ((_ success: Bool) -> ())?
    var selPlayersCount = NSMutableArray()
    
    var loneWolfGBSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wolfTV.tableFooterView = self.submitView
        getwolfGameDetailsWS()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.numberOfRows == 1 {
            if section == 0 {
                return 1
            }
            return self.wolfModelDict?.players.count ?? 0
            
        }else {
            return Int(truncating: self.numberOfRows)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            
            if( !(cell != nil))
            {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HeaderCell")
            }
            cell?.backgroundColor = UIColor(red: 0.0/255.0, green: 110.0/255.0, blue: 207.0/255.0, alpha: 1.0)//GlobalConstants.PURPLECOLORS
            return cell!
        }else {
            let wGCell = tableView.dequeueReusableCell(withIdentifier: "WolfGameTVCell", for: indexPath) as! WolfGameTVCell
            
            if indexPath.row%2 != 0 {
                wGCell.backgroundColor = GlobalConstants.PURPLECOLORS
            }
            
            let player = self.wolfModelDict?.players[indexPath.row]
            let cId = player?.customerId ?? ""
            print(cId)
            
            let fullName    = player?.name ?? ""
            if player?.name == "" || player?.name == nil {
                wGCell.playerNameLbl.text = ""
            }else {
                let fullNameArr = fullName.components(separatedBy: " ")
                if fullNameArr.count > 1 {
                    let secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                    wGCell.playerNameLbl.text = "\(fullNameArr[0]) \(secondNameFL)"
                }else {
                    wGCell.playerNameLbl.text = "\(fullNameArr[0])"
                }
            }
            
            if player?.score == "0" {
                wGCell.scoreLbl.text = "0"
            }else {
                wGCell.scoreLbl.text = "+\(player?.score ?? "0")"
            }
            
            wGCell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            wGCell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            wGCell.wolfRadioBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            
            let dict = self.radioSelDict.object(at: indexPath.row) as! NSDictionary
            if dict["radioFirst"] as? String == "true" {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                wGCell.radioBtn_1.setImage(image, for: .normal)
                wGCell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
            }else if dict["radioSecond"] as? String == "true" {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                wGCell.radioBtn_2.setImage(image, for: .normal)
                wGCell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
            }
            wGCell.radioBtn_1.tag = 200 + indexPath.row
            wGCell.radioBtn_2.tag = 300 + indexPath.row
            
            
            if wolfRadioSelArray[indexPath.row] as? String == "true" {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                wGCell.wolfRadioBtn.setImage(image, for: .normal)
                wGCell.wolfRadioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            }
            wGCell.wolfRadioBtn.tag = 100 + indexPath.row
            wGCell.wolfRadioBtn.addTarget(self, action: #selector(wolfRadioBtnFTapped(_:)), for: .touchUpInside)
            
            wGCell.radioBtn_1.addTarget(self, action: #selector(radioBtnFTapped(_:)), for: .touchUpInside)
            wGCell.radioBtn_2.addTarget(self, action: #selector(radioBtnSTapped(_:)), for: .touchUpInside)
            return wGCell
        }
    }
    
    //MARK: - Button action methods
    @IBAction func loneWolfGBCheckBoxSelected(_ sender: Any) {
        
        self.radioSelDict.removeAllObjects()
        //  self.wolfRadioSelArray.removeAllObjects()
        if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
            let image = UIImage(named: "check_box_selected")?.withRenderingMode(.alwaysTemplate)
            loneWolfGBBtn.setImage(image, for: .normal)
            loneWolfGBBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            loneWolfGBSelected = true
            
        }else {
            loneWolfGBBtn.setImage(UIImage.init(named: "check_box"), for: .normal)
            loneWolfGBSelected = false
        }
        
        for (index, _) in (self.wolfModelDict?.players.enumerated())! {
            let radioDict = NSMutableDictionary()
            if self.wolfRadioSelArray[index] as? String == "true" {
                radioDict.setValue("true", forKey: "radioFirst")
                radioDict.setValue("false", forKey: "radioSecond")
            }else {
                radioDict.setValue("false", forKey: "radioFirst")
                radioDict.setValue("false", forKey: "radioSecond")
            }
            self.radioSelDict.add(radioDict)
            //  self.wolfRadioSelArray.add("false")
        }
        UserDefaults.standard.setValue(self.radioSelDict, forKey: "radioSelDict")
        self.wolfTV.reloadData()
    }
    @IBAction func holeTeamSubmitBtnTapped(_ sender: Any) {
        
        //        UserDefaults.standard.setValue("true", forKey: "isSubmitBtnClicked")
        //        UserDefaults.standard.synchronize()
        
        let temsArray = NSMutableArray()
        var noTeamPlayer: Bool = false
        for (index, item) in (self.radioSelDict.enumerated()) {
            let dict = item as! NSDictionary
            let temsDict = NSMutableDictionary()
            let player = self.wolfModelDict?.players[index]
            
            if dict["radioFirst"] as? String == "true" {
                if self.wolfRadioSelArray[index] as? String == "true" {
                    temsDict.setValue(1, forKey: "WolfPlayer")
                    temsDict.setValue(0, forKey: "WolfPartner")
                    temsDict.setValue(1, forKey: "LoneWolfGoingBlind")
                }else {
                    temsDict.setValue(0, forKey: "WolfPlayer")
                    temsDict.setValue(1, forKey: "WolfPartner")
                    temsDict.setValue(0, forKey: "LoneWolfGoingBlind")
                }
                temsDict.setValue(0, forKey: "NonWolfPlayer")
                
                selPlayersCount.add("1")
            }else if dict["radioSecond"] as? String == "true" {
                temsDict.setValue(0, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(1, forKey: "NonWolfPlayer")
                temsDict.setValue(0, forKey: "LoneWolfGoingBlind")
                selPlayersCount.add("2")
            }else if self.wolfRadioSelArray[index] as? String == "true" {
                temsDict.setValue(1, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(0, forKey: "NonWolfPlayer")
                temsDict.setValue(0, forKey: "LoneWolfGoingBlind")
            }else {
                temsDict.setValue(0, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(0, forKey: "NonWolfPlayer")
                temsDict.setValue(0, forKey: "LoneWolfGoingBlind")
                noTeamPlayer = true
            }
            temsDict.setValue(player?.customerId, forKey: "CustomerId")
            temsArray.add(temsDict)
        }
        if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
            if selPlayersCount.count == 1 {
                // self.errorAlert("Each team should have atleast 1 player")
                self.errorAlert("All players must be on a team")
                return
            }
            if selPlayersCount.count == 0 {
                // self.errorAlert("Each team should have atleast 1 player")
                self.errorAlert("All players must be on a team")
                return
            }
        }
        if noTeamPlayer == true {
            self.errorAlert("All players must be on a team")
            return
        }
        let params: Parameters = [
            "HoleNumber": Int(self.wolfModelDict?.nextHole ?? "0") ?? 0,
            "GameId": gameId,
            "Teams": temsArray
        ]
        
        print("Wolf Game submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postWolfGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                //                UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
                //                UserDefaults.standard.removeObject(forKey: "radioSelDict")
                //                UserDefaults.standard.removeObject(forKey: "wolfRadioSelArray")
                
                self.onCompletion?(true)
            }
        }
    }
    @objc func radioBtnFTapped(_ sender: UIButton) {
        if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.wolfTV)
            let indexPath = self.wolfTV.indexPathForRow(at: buttonPosition)
            
            let dictChnaged = NSMutableDictionary()
            
            let cell = self.wolfTV.cellForRow(at: indexPath! as IndexPath) as! WolfGameTVCell
            if (cell.radioBtn_1.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                cell.radioBtn_1.setImage(image, for: .normal)
                cell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
                
                dictChnaged.setValue("true", forKey: "radioFirst")
                dictChnaged.setValue("false", forKey: "radioSecond")
                self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
                self.wolfTV.reloadData()
                
            }
            UserDefaults.standard.setValue(self.radioSelDict, forKey: "radioSelDict")
            /*else { //Commeneted on 10/03 sat/2020
             cell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
             dictChnaged.setValue("false", forKey: "radioFirst")
             dictChnaged.setValue("false", forKey: "radioSecond")
             }
             self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
             self.wolfTV.reloadData()
             */
            //   self.matchPlayTV.reloadRows(at: [indexPath!], with: .none)
        }
    }
    @objc func radioBtnSTapped(_ sender: UIButton) {
        if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.wolfTV)
            let indexPath = self.wolfTV.indexPathForRow(at: buttonPosition)
            
            let dictChnaged = NSMutableDictionary()
            
            let cell = self.wolfTV.cellForRow(at: indexPath! as IndexPath) as! WolfGameTVCell
            if self.wolfRadioSelArray[(indexPath?.row)!] as? String == "false" {
                if (cell.radioBtn_2.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
                    let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                    cell.radioBtn_2.setImage(image, for: .normal)
                    cell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
                    dictChnaged.setValue("false", forKey: "radioFirst")
                    dictChnaged.setValue("true", forKey: "radioSecond")
                    
                    self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
                    self.wolfTV.reloadData()
                }
                UserDefaults.standard.setValue(self.radioSelDict, forKey: "radioSelDict")
                /*else {//Commeneted on 10/03 sat/2020
                 cell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                 dictChnaged.setValue("false", forKey: "radioFirst")
                 dictChnaged.setValue("false", forKey: "radioSecond")
                 }
                 self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
                 self.wolfTV.reloadData()
                 */
            }
        }
    }
    @objc func wolfRadioBtnFTapped(_ sender: UIButton) {
        if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.wolfTV)
            let indexPath = self.wolfTV.indexPathForRow(at: buttonPosition)
            
            self.wolfRadioSelArray.removeAllObjects()
            for _ in (self.wolfModelDict?.players)! {
                self.wolfRadioSelArray.add("false")
            }
            self.wolfRadioSelArray.replaceObject(at: indexPath!.row, with: "true")
            UserDefaults.standard.setValue(self.wolfRadioSelArray, forKey: "wolfRadioSelArray")
            self.radioBtnFTapped(sender)
            self.wolfTV.reloadData()
        }
    }
    @IBAction func thruBeckBtnTapped(_ sender: Any) {
        //  UserDefaults.standard.setValue("true", forKey: "isSubmitBtnClicked")
        let temsArray = NSMutableArray()
        var noTeamPlayer: Bool = false
        for (index, item) in (self.radioSelDict.enumerated()) {
            let dict = item as! NSDictionary
            let temsDict = NSMutableDictionary()
            let player = self.wolfModelDict?.players[index]
            
            if dict["radioFirst"] as? String == "true" {
                if self.wolfRadioSelArray[index] as? String == "true" {
                    temsDict.setValue(1, forKey: "WolfPlayer")
                    temsDict.setValue(0, forKey: "WolfPartner")
                }else {
                    temsDict.setValue(0, forKey: "WolfPlayer")
                    temsDict.setValue(1, forKey: "WolfPartner")
                }
                temsDict.setValue(0, forKey: "NonWolfPlayer")
                selPlayersCount.add("1")
            }else if dict["radioSecond"] as? String == "true" {
                temsDict.setValue(0, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(1, forKey: "NonWolfPlayer")
                selPlayersCount.add("2")
            }else if self.wolfRadioSelArray[index] as? String == "true" {
                temsDict.setValue(1, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(0, forKey: "NonWolfPlayer")
            }else {
                temsDict.setValue(0, forKey: "WolfPlayer")
                temsDict.setValue(0, forKey: "WolfPartner")
                temsDict.setValue(0, forKey: "NonWolfPlayer")
                noTeamPlayer = true
            }
            temsDict.setValue(0, forKey: "LoneWolfGoingBlind")
            temsDict.setValue(player?.customerId, forKey: "CustomerId")
            temsArray.add(temsDict)
        }
        for i in 0..<wolfRadioSelArray.count {
            if wolfRadioSelArray[i] as? String == "true" {
                if loneWolfGBBtn.currentImage?.pngData() == UIImage(named: "check_box")?.pngData() {
                    if noTeamPlayer == true {
                        self.errorAlert("Select team for Hole \(self.wolfModelDict?.nextHole ?? "0")")
                        return
                    }
                }
            }else {
                if loneWolfGBSelected == true {
                    
                }else {
                    if noTeamPlayer == true {
                        self.errorAlert("Select team for Hole \(self.wolfModelDict?.nextHole ?? "0")")
                        return
                    }
                }
            }
        }
        
        /*
         if (loneWolfGBBtn.currentImage?.isEqual(UIImage(named: "check_box")))! {
         if selPlayersCount.count == 1 {
         self.errorAlert("Select team for Hole \(self.wolfModelDict?.nextHole ?? "0")")
         return
         }
         if selPlayersCount.count == 0 {
         self.errorAlert("Select team for Hole \(self.wolfModelDict?.nextHole ?? "0")")
         return
         }
         }
         */
        let params: Parameters = [
            "HoleNumber": Int(self.wolfModelDict?.nextHole ?? "0") ?? 0,
            "GameId": gameId,
            "Teams": temsArray
        ]
        
        print("Wolf Game submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postWolfGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
                gEPSVCObj.gameId = self.gameId
                let thru :Int = Int(self.wolfModelDict?.thru ?? "0") ?? 0
                gEPSVCObj.thruValue = thru + 1
                self.navigationController?.pushViewController(gEPSVCObj, animated: true)
            }
        }
    }
    @IBAction func enterScoreBtnTapped(_ sender: Any) {
       self.thruBeckBtnTapped(UIButton.init())
    }
    //MARK: - Web service methods
    func getwolfGameDetailsWS() {
        
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
            
            let wolfGame = try! JSONSerialization.data(withJSONObject: dict["Wolf"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let wolfGameString = NSString(data: wolfGame, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.wolfRadioSelArray.removeAllObjects()
            self.radioSelDict.removeAllObjects()
            self.wolfModelDict = WolfGameModel(JSONString: wolfGameString)
            
            if UserDefaults.contains("nextHoleValue") {
                let priviesHole =  UserDefaults.standard.value(forKey: "nextHoleValue") as? String
                let priviesH = Int(priviesHole!) ?? 0
                let nextH = Int((self.wolfModelDict?.nextHole)!) ?? 0
                if priviesH < nextH {
                   // UserDefaults.standard.setValue("true", forKey: "isSubmitBtnClicked")
                    UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
                    UserDefaults.standard.removeObject(forKey: "radioSelDict")
                    UserDefaults.standard.removeObject(forKey: "wolfRadioSelArray")
                }
            }
            
            let str =  UserDefaults.standard.value(forKey: "isSubmitBtnClicked") as? String
            if str == "true" || str == nil {
                for player in (self.wolfModelDict?.players)! {
                    let radioDict = NSMutableDictionary()
                    if player.customerId == self.wolfModelDict?.nextWolfCustomerId {
                        radioDict.setValue("true", forKey: "radioFirst")
                        radioDict.setValue("false", forKey: "radioSecond")
                        self.wolfRadioSelArray.add("true")
                    }else {
                        radioDict.setValue("false", forKey: "radioFirst")
                        radioDict.setValue("false", forKey: "radioSecond")
                        self.wolfRadioSelArray.add("false")
                    }
                    self.radioSelDict.add(radioDict)
                }
                UserDefaults.standard.setValue("false", forKey: "isSubmitBtnClicked")
            }else {
                if UserDefaults.contains("radioSelDict") {
                    let dict = UserDefaults.standard.object(forKey: "radioSelDict") as! NSArray
                    self.radioSelDict = dict.mutableCopy() as! NSMutableArray
                    if UserDefaults.contains("wolfRadioSelArray") {
                        let dict2 = UserDefaults.standard.object(forKey: "wolfRadioSelArray") as! NSArray
                        self.wolfRadioSelArray = dict2.mutableCopy() as! NSMutableArray
                    }else {
                        for player in (self.wolfModelDict?.players)! {
                            if player.customerId == self.wolfModelDict?.nextWolfCustomerId {
                                self.wolfRadioSelArray.add("true")
                            }else {
                                self.wolfRadioSelArray.add("false")
                            }
                        }
                    }
                }else {
                    for player in (self.wolfModelDict?.players)! {
                        let radioDict = NSMutableDictionary()
                        if player.customerId == self.wolfModelDict?.nextWolfCustomerId {
                            radioDict.setValue("true", forKey: "radioFirst")
                            radioDict.setValue("false", forKey: "radioSecond")
                            self.wolfRadioSelArray.add("true")
                        }else {
                            radioDict.setValue("false", forKey: "radioFirst")
                            radioDict.setValue("false", forKey: "radioSecond")
                            self.wolfRadioSelArray.add("false")
                        }
                        self.radioSelDict.add(radioDict)
                    }
                }
            }
           // self.thruLbl.text = "Thru \(self.wolfModelDict?.thru ?? "")\nEnter Score"
            self.thruLbl.text = "Thru \(self.wolfModelDict?.thru ?? "")"
            self.holeTeamSubmitBtn.setTitle("Hole \(self.wolfModelDict?.nextHole ?? "0") Team", for: .normal)
            UserDefaults.standard.setValue(self.wolfModelDict?.nextHole ?? "0", forKey: "nextHoleValue")
            self.numberOfRows = 1
            self.wolfTV.tableFooterView = self.submitView
            
            print(self.radioSelDict)
            self.wolfTV.reloadData()
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
