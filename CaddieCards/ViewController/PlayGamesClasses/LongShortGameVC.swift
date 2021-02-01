//
//  LongShortGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 04/10/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class LongShortGameVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var holeTeamSubmitBtn: UIButton!
    
    @IBOutlet weak var longShortTV: UITableView!
    var wolfModelDict = WolfGameModel(JSONString: "")
    @IBOutlet weak var submitView: UIView!
    var radioSelDict = NSMutableArray()
    var wolfRadioSelArray = NSMutableArray()
    var numberOfRows: NSNumber = 0
    @IBOutlet weak var thruLbl: UILabel!
    
    var onCompletion: ((_ success: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longShortTV.tableFooterView = self.submitView
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
            let longSCell = tableView.dequeueReusableCell(withIdentifier: "LongShortTVCell", for: indexPath) as! LongShortTVCell
            
            if indexPath.row%2 != 0 {
                longSCell.backgroundColor = GlobalConstants.PURPLECOLORS
            }
            
            let player = self.wolfModelDict?.players[indexPath.row]
            let cId = player?.customerId ?? ""
            print(cId)
            
            let fullName    = player?.name ?? ""
            if player?.name == "" || player?.name == nil {
                longSCell.playerNameLbl.text = ""
            }else {
                let fullNameArr = fullName.components(separatedBy: " ")
                if fullNameArr.count > 1 {
                    let secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                    longSCell.playerNameLbl.text = "\(fullNameArr[0]) \(secondNameFL)"
                }else {
                    longSCell.playerNameLbl.text = "\(fullNameArr[0])"
                }
            }
            
            if player?.score == "0" {
                longSCell.scoreLbl.text = "0"
            }else {
                longSCell.scoreLbl.text = "+\(player?.score ?? "0")"
            }
            
            longSCell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            longSCell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            
            let dict = self.radioSelDict.object(at: indexPath.row) as! NSDictionary
            if dict["radioFirst"] as? String == "true" {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                longSCell.radioBtn_1.setImage(image, for: .normal)
                longSCell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
            }else if dict["radioSecond"] as? String == "true" {
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                longSCell.radioBtn_2.setImage(image, for: .normal)
                longSCell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
            }
            longSCell.radioBtn_1.tag = 200 + indexPath.row
            longSCell.radioBtn_2.tag = 300 + indexPath.row
            
            
            longSCell.radioBtn_1.addTarget(self, action: #selector(radioBtnFTapped(_:)), for: .touchUpInside)
            longSCell.radioBtn_2.addTarget(self, action: #selector(radioBtnSTapped(_:)), for: .touchUpInside)
            return longSCell
        }
    }
    
    //MARK: - Button action methods
    
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
                temsDict.setValue("1", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }else if dict["radioSecond"] as? String == "true" {
                temsDict.setValue("2", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }else {
                noTeamPlayer = true
            }
        }
        if temsArray.count == 1 || temsArray.count == 0 || noTeamPlayer == true {
            self.errorAlert("There must be at least 1 player on each team")
            return
        }
        
        let params: Parameters = [
            "HoleNumber": Int(self.wolfModelDict?.nextHole ?? "0") ?? 0,
            "GameId": gameId,
            "Teams": temsArray
        ]
        
        print("LongShort Game submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postLongSGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                //                UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
                //                UserDefaults.standard.removeObject(forKey: "radioSelDict")
                self.onCompletion?(true)
            }
        }
    }
    @objc func radioBtnFTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.longShortTV)
        let indexPath = self.longShortTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.longShortTV.cellForRow(at: indexPath! as IndexPath) as! LongShortTVCell
        if (cell.radioBtn_1.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            cell.radioBtn_1.setImage(image, for: .normal)
            cell.radioBtn_1.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            dictChnaged.setValue("true", forKey: "radioFirst")
            dictChnaged.setValue("false", forKey: "radioSecond")
            self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
            self.longShortTV.reloadData()
            
        }
        UserDefaults.standard.setValue(self.radioSelDict, forKey: "radioSelDict")
        
        /*else { //Commeneted on 10/03 sat/2020
         cell.radioBtn_1.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
         dictChnaged.setValue("false", forKey: "radioFirst")
         dictChnaged.setValue("false", forKey: "radioSecond")
         }
         self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
         self.longShortTV.reloadData()
         */
        //   self.matchPlayTV.reloadRows(at: [indexPath!], with: .none)
    }
    @objc func radioBtnSTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.longShortTV)
        let indexPath = self.longShortTV.indexPathForRow(at: buttonPosition)
        
        let dictChnaged = NSMutableDictionary()
        
        let cell = self.longShortTV.cellForRow(at: indexPath! as IndexPath) as! LongShortTVCell
        if (cell.radioBtn_2.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            cell.radioBtn_2.setImage(image, for: .normal)
            cell.radioBtn_2.tintColor = GlobalConstants.RADIOBTNCOLORS
            dictChnaged.setValue("false", forKey: "radioFirst")
            dictChnaged.setValue("true", forKey: "radioSecond")
            
            self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
            self.longShortTV.reloadData()
        }
        UserDefaults.standard.setValue(self.radioSelDict, forKey: "radioSelDict")
        /*else {//Commeneted on 10/03 sat/2020
         cell.radioBtn_2.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
         dictChnaged.setValue("false", forKey: "radioFirst")
         dictChnaged.setValue("false", forKey: "radioSecond")
         }
         self.radioSelDict.replaceObject(at: indexPath!.row, with: dictChnaged)
         self.longShortTV.reloadData()
         */
    }
    @IBAction func thruBackBtnTapped(_ sender: Any) {
        
        // UserDefaults.standard.setValue("true", forKey: "isSubmitBtnClicked")
        let temsArray = NSMutableArray()
        var noTeam1Player: Bool = false
        var noTeam2Player: Bool = false
        for (index, item) in (self.radioSelDict.enumerated()) {
            let dict = item as! NSDictionary
            let temsDict = NSMutableDictionary()
            let player = self.wolfModelDict?.players[index]
            
            if dict["radioFirst"] as? String == "true" {
                temsDict.setValue("1", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
                
            }else if dict["radioSecond"] as? String == "true" {
                temsDict.setValue("2", forKey: "TeamNo")
                temsDict.setValue(player?.customerId, forKey: "CustomerId")
                temsArray.add(temsDict)
            }else {
                noTeam1Player = true
                noTeam2Player = true
            }
        }        
        if temsArray.count == 1 || temsArray.count == 0 || noTeam1Player == true || noTeam2Player == true {
            self.errorAlert("Select team for Hole \(self.wolfModelDict?.nextHole ?? "0")")
            return
        }
        
        let params: Parameters = [
            "HoleNumber": Int(self.wolfModelDict?.nextHole ?? "0") ?? 0,
            "GameId": gameId,
            "Teams": temsArray
        ]
        
        print("LongShort Game submit Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().postLongSGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
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
        self.thruBackBtnTapped(UIButton.init())
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
            
            let longSGame = try! JSONSerialization.data(withJSONObject: dict["LongestShortest"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let longSGameString = NSString(data: longSGame, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.wolfModelDict = WolfGameModel(JSONString: longSGameString)
            
            if UserDefaults.contains("nextHoleValue") {
                let priviesHole =  UserDefaults.standard.value(forKey: "nextHoleValue") as? String
                let priviesH = Int(priviesHole!) ?? 0
                let nextH = Int((self.wolfModelDict?.nextHole ?? "")) ?? 0
                if priviesH < nextH {
                   // UserDefaults.standard.setValue("true", forKey: "isSubmitBtnClicked")
                    UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
                    UserDefaults.standard.removeObject(forKey: "radioSelDict")
                    UserDefaults.standard.removeObject(forKey: "wolfRadioSelArray")
                }
            }
            
            let radioDict = NSMutableDictionary()
            
            let str =  UserDefaults.standard.value(forKey: "isSubmitBtnClicked") as? String
            if str == "true" || str == nil {
                for _ in (self.wolfModelDict?.players)! {
                    radioDict.setValue("false", forKey: "radioFirst")
                    radioDict.setValue("false", forKey: "radioSecond")
                    self.radioSelDict.add(radioDict)
                    self.wolfRadioSelArray.add("false")
                }
                UserDefaults.standard.setValue("false", forKey: "isSubmitBtnClicked")
                
            }else {
                if UserDefaults.contains("radioSelDict") {
                    let dict = UserDefaults.standard.object(forKey: "radioSelDict") as! NSArray
                    self.radioSelDict = dict.mutableCopy() as! NSMutableArray
                }else {
                    for _ in (self.wolfModelDict?.players)! {
                        radioDict.setValue("false", forKey: "radioFirst")
                        radioDict.setValue("false", forKey: "radioSecond")
                        self.radioSelDict.add(radioDict)
                        self.wolfRadioSelArray.add("false")
                    }
                    UserDefaults.standard.setValue("false", forKey: "isSubmitBtnClicked")
                }
            }
            self.thruLbl.text = "Thru \(self.wolfModelDict?.thru ?? "")"
            self.holeTeamSubmitBtn.setTitle("Hole \(self.wolfModelDict?.nextHole ?? "0") Team", for: .normal)
            UserDefaults.standard.setValue(self.wolfModelDict?.nextHole ?? "0", forKey: "nextHoleValue")
            self.numberOfRows = 1
            self.longShortTV.tableFooterView = self.submitView
            
            
            print(self.radioSelDict)
            self.longShortTV.reloadData()
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
