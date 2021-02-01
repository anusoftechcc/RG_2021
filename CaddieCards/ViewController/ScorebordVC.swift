//
//  ScorebordVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/10/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ScorebordVC: BaseViewController {
    
    @IBOutlet weak var PlayerNamesView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var ply1Name: UILabel!
    @IBOutlet weak var ply2Name: UILabel!
    @IBOutlet weak var ply3Name: UILabel!
    @IBOutlet weak var ply4Name: UILabel!
    @IBOutlet weak var ply5Name: UILabel!
    var firstPName: String = ""
    var firstPCId : NSNumber = 0
    var secondPName : String = ""
    var secondPCId : NSNumber = 0
    var thardPName : String = ""
    var thardPCId : NSNumber = 0
    var fourthPName : String = ""
    var fourthPCId : NSNumber = 0
    var fifthPName : String = ""
    var fifthPCId : NSNumber = 0
    
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var gameId: NSNumber = 0
    
    var scoreboardDetailsDict = ScoreboardModel(JSONString: "")
    var gameModelDict = GameDataModel(JSONString: "")
    var playGameDetailsDict = NSDictionary()
    var gameDatadict = NSMutableDictionary()
    var scoreboardArray = NSMutableArray()
    var playersArray = NSMutableArray()
    var teamSelModelDict = TeamSelectionModel(JSONString: "")
    
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var playTypeLbl: UILabel!
    
    @IBOutlet weak var view_Yards: UIView!
    @IBOutlet weak var view_HCP: UIView!
    @IBOutlet weak var view_Par: UIView!
    @IBOutlet weak var view_Ply1: UIView!
    @IBOutlet weak var view_Ply2: UIView!
    @IBOutlet weak var view_Ply3: UIView!
    @IBOutlet weak var view_Ply4: UIView!
    @IBOutlet weak var view_Ply5: UIView!
    
    @IBOutlet weak var view2_Yards: UIView!
    @IBOutlet weak var view2_HCP: UIView!
    @IBOutlet weak var view2_Par: UIView!
    @IBOutlet weak var view2_Ply1: UIView!
    @IBOutlet weak var view2_Ply2: UIView!
    @IBOutlet weak var view2_Ply3: UIView!
    @IBOutlet weak var view2_Ply4: UIView!
    @IBOutlet weak var view2_Ply5: UIView!
    
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var slopeLbl: UILabel!
    @IBOutlet weak var handicapLbl: UILabel!
    @IBOutlet weak var netLbl: UILabel!
    
    var isFromPlayGameScore: Bool = false
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var endLbl: UIButton!
    @IBOutlet weak var playersNameView_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ply1Name_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ply2Name_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ply3Name_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ply4Name_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ply5Name_HeightConstraint: NSLayoutConstraint!
    
    var handicap = ""
    
    @IBOutlet weak var ViewPlay1_Height: NSLayoutConstraint!
    @IBOutlet weak var ViewPlay2_Height: NSLayoutConstraint!
    @IBOutlet weak var ViewPlay3_Height: NSLayoutConstraint!
    @IBOutlet weak var ViewPlay4_Height: NSLayoutConstraint!
    @IBOutlet weak var ViewPlay5_Height: NSLayoutConstraint!
    
    @IBOutlet weak var View2Play1_Height: NSLayoutConstraint!
    @IBOutlet weak var View2Play2_Height: NSLayoutConstraint!
    @IBOutlet weak var View2Play3_Height: NSLayoutConstraint!
    @IBOutlet weak var View2Play4_Height: NSLayoutConstraint!
    @IBOutlet weak var View2Play5_Height: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "SCORECARD"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        /*
         if isFromPlayGameScore == true {
         
         
         let courseName =  (playGameDetailsDict["Course"] ?? "") as! String
         self.courseNameLbl.text = courseName
         
         let date =  (playGameDetailsDict["ScheduleDate"] ?? "") as! String
         let time =  (playGameDetailsDict["ScheduleTime"] ?? "") as! String
         
         
         self.dateLbl.text = "\(date)"
         self.timeLbl.text = "\(time)"
         
         
         let handicaps = (playGameDetailsDict["Handicaps"] ?? "") as! String
         
         self.netLbl.text = "HCP %\n\(handicaps)"
         if handicaps == "" {
         self.netLbl.text = "HCP %\n000000"
         }
         
         let game =  (playGameDetailsDict["Game"] ?? "") as! String
         self.playTypeLbl.text = game
         
         getScoreboardDetailsWS()
         
         }else {
         */
        getScoreboardDetailsWS()
        //  }
    }
    override func viewDidLayoutSubviews() {
        mainView.cornerRadius = 3.0
        mainView.clipsToBounds = true
        
        gameInfoView.cornerRadius = 3.0
        gameInfoView.clipsToBounds  = true
    }
    //MARK: - Button action methods
    @IBAction func viewPly1Btns(_ sender: UIButton) {
        print("Button tag : \(sender.tag)")
        /*
         if let buttonTitle = sender.title(for: .normal) {
         print(buttonTitle)
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let ePScoreVCObj = storyboard.instantiateViewController(withIdentifier: "EditPlayerScoreVC") as! EditPlayerScoreVC
         ePScoreVCObj.name = self.firstPName
         if buttonTitle != "-" {
         ePScoreVCObj.score = buttonTitle
         }
         ePScoreVCObj.hole = String(sender.tag)
         let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-1].par
         ePScoreVCObj.par = par
         ePScoreVCObj.gameId = gameId
         ePScoreVCObj.customerId = self.firstPCId
         self.navigationController?.pushViewController(ePScoreVCObj, animated: true)
         }
         */
        let isValidation = self.checkingTeamHoleSel(btnIndex: (sender.tag - 100))
        if (isValidation == true && self.gameModelDict?.game == "Wolf") || (isValidation == true && self.gameModelDict?.game == "Longest Shortest") {
            self.errorAlert("Select team for Hole \((sender.tag + 1)-100)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
            gEPSVCObj.gameId = self.gameId
            gEPSVCObj.hole = String((sender.tag + 1)-100)
            let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-100].par
            gEPSVCObj.par = par ?? ""
            let hcp = self.scoreboardDetailsDict?.scoreBoard[sender.tag-100].hcp
            gEPSVCObj.hcp = hcp ?? ""
            gEPSVCObj.scoreHoleIndex = sender.tag-100
            self.navigationController?.pushViewController(gEPSVCObj, animated: true)
        }
    }
    @IBAction func viewPly2Btns(_ sender: UIButton) {
        print("Button tag : \(sender.tag)")
        
        let isValidation = self.checkingTeamHoleSel(btnIndex: (sender.tag - 200))
        if (isValidation == true && self.gameModelDict?.game == "Wolf") || (isValidation == true && self.gameModelDict?.game == "Longest Shortest") {
            self.errorAlert("Select team for Hole \((sender.tag + 1)-200)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
            gEPSVCObj.gameId = self.gameId
            gEPSVCObj.hole = String((sender.tag + 1)-200)
            let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-200].par
            gEPSVCObj.par = par ?? ""
            let hcp = self.scoreboardDetailsDict?.scoreBoard[sender.tag-200].hcp
            gEPSVCObj.hcp = hcp ?? ""
            gEPSVCObj.scoreHoleIndex = sender.tag-200
            self.navigationController?.pushViewController(gEPSVCObj, animated: true)
        }
    }
    @IBAction func viewPly3Btns(_ sender: UIButton) {
        print("Button tag : \(sender.tag)")
        let isValidation = self.checkingTeamHoleSel(btnIndex: (sender.tag - 300))
        if (isValidation == true && self.gameModelDict?.game == "Wolf") || (isValidation == true && self.gameModelDict?.game == "Longest Shortest") {
            self.errorAlert("Select team for Hole \((sender.tag + 1)-300)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
            gEPSVCObj.gameId = self.gameId
            gEPSVCObj.hole = String((sender.tag + 1)-300)
            let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-300].par
            gEPSVCObj.par = par ?? ""
            let hcp = self.scoreboardDetailsDict?.scoreBoard[sender.tag-300].hcp
            gEPSVCObj.hcp = hcp ?? ""
            gEPSVCObj.scoreHoleIndex = sender.tag-300
            self.navigationController?.pushViewController(gEPSVCObj, animated: true)
        }
    }
    @IBAction func viewPly4Btns(_ sender: UIButton) {
        print("Button tag : \(sender.tag)")
        let isValidation = self.checkingTeamHoleSel(btnIndex: (sender.tag - 400))
        if (isValidation == true && self.gameModelDict?.game == "Wolf") || (isValidation == true && self.gameModelDict?.game == "Longest Shortest") {
            self.errorAlert("Select team for Hole \((sender.tag + 1)-400)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
            gEPSVCObj.gameId = self.gameId
            gEPSVCObj.hole = String((sender.tag + 1)-400)
            let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-400].par
            gEPSVCObj.par = par ?? ""
            let hcp = self.scoreboardDetailsDict?.scoreBoard[sender.tag-400].hcp
            gEPSVCObj.hcp = hcp ?? ""
            gEPSVCObj.scoreHoleIndex = sender.tag-400
            self.navigationController?.pushViewController(gEPSVCObj, animated: true)
        }
    }
    @IBAction func viewPly5Btns(_ sender: UIButton) {
        print("Button tag : \(sender.tag)")
        let isValidation = self.checkingTeamHoleSel(btnIndex: (sender.tag - 500))
        if (isValidation == true && self.gameModelDict?.game == "Wolf") || (isValidation == true && self.gameModelDict?.game == "Longest Shortest") {
            self.errorAlert("Select team for Hole \((sender.tag + 1)-500)")
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
            gEPSVCObj.gameId = self.gameId
            gEPSVCObj.hole = String((sender.tag + 1)-500)
            let par = self.scoreboardDetailsDict?.scoreBoard[sender.tag-500].par
            gEPSVCObj.par = par ?? ""
            let hcp = self.scoreboardDetailsDict?.scoreBoard[sender.tag-500].hcp
            gEPSVCObj.hcp = hcp ?? ""
            gEPSVCObj.scoreHoleIndex = sender.tag-500
            self.navigationController?.pushViewController(gEPSVCObj, animated: true)
        }
    }
    
    @IBAction func endGameBtnTapped(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Do you want to END this game?", message: "", preferredStyle: .alert)
        alert.view.tintColor = GlobalConstants.APPGREENCOLOR
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.endGameWS(userId: String(self.userId), gameId: String(Int(truncating: self.gameId)))
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func checkingTeamHoleSel(btnIndex: Int) -> Bool {
        
        if btnIndex == 0 {
            if self.teamSelModelDict?.hole_1 == false {
                return true
            }else {
                return false
            }
        }else if btnIndex == 1 {
            if self.teamSelModelDict?.hole_2 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 2 {
            if self.teamSelModelDict?.hole_3 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 3 {
            if self.teamSelModelDict?.hole_4 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 4 {
            if self.teamSelModelDict?.hole_5 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 5 {
            if self.teamSelModelDict?.hole_6 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 6 {
            if self.teamSelModelDict?.hole_7 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 7 {
            if self.teamSelModelDict?.hole_8 == false {
                return true
            }else {
                return false
            }
        }else if btnIndex == 8 {
            if self.teamSelModelDict?.hole_9 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 9 {
            if self.teamSelModelDict?.hole_10 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 10 {
            if self.teamSelModelDict?.hole_11 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 11 {
            if self.teamSelModelDict?.hole_12 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 12 {
            if self.teamSelModelDict?.hole_13 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 13 {
            if self.teamSelModelDict?.hole_14 == false {
                return true
            }else {
                return false
            }
        }else if btnIndex == 14 {
            if self.teamSelModelDict?.hole_15 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 15 {
            if self.teamSelModelDict?.hole_16 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 16 {
            if self.teamSelModelDict?.hole_17 == false {
                return true
            }else {
                return false
            }
        }
        else if btnIndex == 17 {
            if self.teamSelModelDict?.hole_18 == false {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    //MARK: - Web Service Methods
    func getScoreboardDetailsWS() {
        
        //let urlString :  String =  MyStrings().getScoreCardsDataUrl + "\(gameId)"
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
            
            self.scoreboardDetailsDict = ScoreboardModel(JSONString: jsonString)
            
            let gameData = try! JSONSerialization.data(withJSONObject: dict["GameData"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let gameDataString = NSString(data: gameData, encoding: String.Encoding.utf8.rawValue)! as String
            self.gameModelDict = GameDataModel(JSONString: gameDataString)
            
            // teamSelectionDict
            let teamSData = try! JSONSerialization.data(withJSONObject: dict["TeamSelection"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let teamSDataString = NSString(data: teamSData, encoding: String.Encoding.utf8.rawValue)! as String
            self.teamSelModelDict = TeamSelectionModel(JSONString: teamSDataString)
            
            //  if self.isFromPlayGameScore == false {
            let courseName =  (self.gameModelDict?.course ?? "")
            self.courseNameLbl.text = courseName
            
            let date =  (self.gameModelDict?.scheduleDate ?? "")
            self.dateLbl.text = date
            
            let time =  (self.gameModelDict?.scheduleTime ?? "")
            self.timeLbl.text = time
            
            
            let handicaps = (self.gameModelDict?.handicaps ?? "")
            
            self.netLbl.text = "HCP %\n\(handicaps)"
            if self.gameModelDict?.handicaps == nil {
                self.netLbl.text = "HCP %\n000000"
            }
            let game =  self.gameModelDict?.game ?? ""
            self.playTypeLbl.text = game
            /*
             let gameType =  (self.gameModelDict?.gameType ?? "")
             if gameType == "1" {
             self.playTypeLbl.text = "Match Play"
             }else {
             self.playTypeLbl.text = "Stroke Play"
             }
             */
            
            //    }
            
            let scorecard = self.scoreboardDetailsDict?.scoreBoard[0]
            var i = 0
            for score in (scorecard!.players) {
                let cId = score.customerId ?? ""
                if i == 0 {
                    self.ply1Name.text = "\(self.getFirstLattersOfSting(name: score.name ?? "").uppercased()) \(score.hcp ?? "")"
                    self.firstPName = score.name ?? ""
                    self.firstPCId = Int(cId)! as NSNumber
                    
                }else if i == 1 {
                    self.ply2Name.text = "\(self.getFirstLattersOfSting(name: score.name ?? "").uppercased()) \(score.hcp ?? "")"
                    self.secondPName = score.name ?? ""
                    self.secondPCId = Int(cId)! as NSNumber
                }else if i == 2 {
                    self.ply3Name.text = "\(self.getFirstLattersOfSting(name: score.name ?? "").uppercased()) \(score.hcp ?? "")"
                    self.thardPName = score.name ?? ""
                    self.thardPCId = Int(cId)! as NSNumber
                }else if i == 3 {
                    self.ply4Name.text = "\(self.getFirstLattersOfSting(name: score.name ?? "").uppercased()) \(score.hcp ?? "")"
                    self.fourthPName = score.name ?? ""
                    self.fourthPCId = Int(cId)! as NSNumber
                }else if i == 4 {
                    self.ply5Name.text = "\(self.getFirstLattersOfSting(name: score.name ?? "").uppercased()) \(score.hcp ?? "")"
                    self.fifthPName = score.name ?? ""
                    self.fifthPCId = Int(cId)! as NSNumber
                }
                i += 1
            }
            
            self.loadScoreboardData()
        }
    }
    
    func loadScoreboardData(){
        
        let yrads:[UIButton] = view_Yards.subviews.compactMap{ $0 as? UIButton }
        
        var i = 0
        for score in (self.scoreboardDetailsDict?.scoreBoard)! {
            if i < yrads.count {
                let button: UIButton = yrads[i]
                button.setTitle(score.yards ?? "", for: .normal)
                i += 1
            }
        }
        
        let hcp:[UIButton] = view_HCP.subviews.compactMap{ $0 as? UIButton }
        
        i = 0
        for score in (self.scoreboardDetailsDict?.scoreBoard)! {
            if i < hcp.count {
                let button: UIButton = hcp[i]
                button.setTitle(score.hcp ?? "", for: .normal)
                i += 1
            }
        }
        
        let par:[UIButton] = view_Par.subviews.compactMap{ $0 as? UIButton }
        
        i = 0
        for score in (self.scoreboardDetailsDict?.scoreBoard)! {
            if i < par.count {
                let button: UIButton = par[i]
                button.setTitle(score.par ?? "", for: .normal)
                i += 1
            }
        }
        
        let ply1:[UIButton] = view_Ply1.subviews.compactMap{ $0 as? UIButton }
        let ply2:[UIButton] = view_Ply2.subviews.compactMap{ $0 as? UIButton }
        let ply3:[UIButton] = view_Ply3.subviews.compactMap{ $0 as? UIButton }
        let ply4:[UIButton] = view_Ply4.subviews.compactMap{ $0 as? UIButton }
        let ply5:[UIButton] = view_Ply5.subviews.compactMap{ $0 as? UIButton }
        
        //Assigneing tags to buttons for finding tag value while clicking button actions
        for i in 0...17 {
            
            let view1buttons: UIButton = ply1[i]
            view1buttons.tag = 100 + i
            let view2buttons: UIButton = ply2[i]
            view2buttons.tag = 200 + i
            let view3buttons: UIButton = ply3[i]
            view3buttons.tag = 300 + i
            let view4buttons: UIButton = ply4[i]
            view4buttons.tag = 400 + i
            let view5buttons: UIButton = ply5[i]
            view5buttons.tag = 500 + i
        }
        
        var j = 0
        for scorecard in (self.scoreboardDetailsDict?.scoreBoard)! {
            i = 0
            if j < ply1.count {
                for score in (scorecard.players)! {
                    if i == 0 {
                        let button: UIButton = ply1[j]
                        if score.score == "" {
                            button.setTitle("-", for: .normal)
                        }else {
                            button.setTitle(score.score ?? "", for: .normal)
                        }
                        if score.dots == 1 {
                            button.setBackgroundImage(UIImage.init(named: "dot"), for: .normal)
                        }else if score.dots == 2 {
                            button.setBackgroundImage(UIImage.init(named: "double_dot"), for: .normal)
                        }
                        if score.ColorCode != "" && score.ColorCode != nil {
                            button.backgroundColor = UIColor(red: 220.0/255.0, green: 240.0/255.0, blue: 207.0/255.0, alpha: 1.0)
                            button.borderColor = UIColor.white
                            button.borderWidth = 2.0
                        } else {
                            button.backgroundColor = UIColor.white
                        }
                        
                    }else if i == 1 {
                        let button: UIButton = ply2[j]
                        if score.score == "" {
                            button.setTitle("-", for: .normal)
                        }else {
                            button.setTitle(score.score ?? "", for: .normal)
                        }
                        if score.dots == 1 {
                            button.setBackgroundImage(UIImage.init(named: "dot"), for: .normal)
                        }else if score.dots == 2 {
                            button.setBackgroundImage(UIImage.init(named: "double_dot"), for: .normal)
                        }
                        if score.ColorCode != "" && score.ColorCode != nil {
                            button.backgroundColor = UIColor(red: 220.0/255.0, green: 240.0/255.0, blue: 207.0/255.0, alpha: 1.0)
                            button.borderColor = UIColor.white
                            button.borderWidth = 2.0
                        } else {
                            button.backgroundColor = UIColor.white
                        }
                    }else if i == 2 {
                        let button: UIButton = ply3[j]
                        if score.score == "" {
                            button.setTitle("-", for: .normal)
                        }else {
                            button.setTitle(score.score ?? "", for: .normal)
                        }
                        if score.dots == 1 {
                            button.setBackgroundImage(UIImage.init(named: "dot"), for: .normal)
                        }else if score.dots == 2 {
                            button.setBackgroundImage(UIImage.init(named: "double_dot"), for: .normal)
                        }
                        if score.ColorCode != "" && score.ColorCode != nil {
                            button.backgroundColor = UIColor(red: 220.0/255.0, green: 240.0/255.0, blue: 207.0/255.0, alpha: 1.0)
                            button.borderColor = UIColor.white
                            button.borderWidth = 2.0
                        } else {
                            button.backgroundColor = UIColor.white
                        }
                    }else if i == 3 {
                        let button: UIButton = ply4[j]
                        if score.score == "" {
                            button.setTitle("-", for: .normal)
                        }else {
                            button.setTitle(score.score ?? "", for: .normal)
                        }
                        if score.dots == 1 {
                            button.setBackgroundImage(UIImage.init(named: "dot"), for: .normal)
                        }else if score.dots == 2 {
                            button.setBackgroundImage(UIImage.init(named: "double_dot"), for: .normal)
                        }
                        if score.ColorCode != "" && score.ColorCode != nil {
                            button.backgroundColor = UIColor(red: 220.0/255.0, green: 240.0/255.0, blue: 207.0/255.0, alpha: 1.0)
                            button.borderColor = UIColor.white
                            button.borderWidth = 2.0
                        } else {
                            button.backgroundColor = UIColor.white
                        }
                    }else if i == 4 {
                        let button: UIButton = ply5[j]
                        if score.score == "" {
                            button.setTitle("-", for: .normal)
                        }else {
                            button.setTitle(score.score ?? "", for: .normal)
                        }
                        if score.dots == 1 {
                            button.setBackgroundImage(UIImage.init(named: "dot"), for: .normal)
                        }else if score.dots == 2 {
                            button.setBackgroundImage(UIImage.init(named: "double_dot"), for: .normal)
                        }
                        if score.ColorCode != "" && score.ColorCode != nil {
                            button.backgroundColor = UIColor(red: 220.0/255.0, green: 240.0/255.0, blue: 207.0/255.0, alpha: 1.0)
                            button.borderColor = UIColor.white
                            button.borderWidth = 2.0
                        } else {
                            button.backgroundColor = UIColor.white
                        }
                    }
                    i += 1
                }
            }
            j += 1
        }
        
        
        let yards2:[UILabel] = view2_Yards.subviews.compactMap{ $0 as? UILabel }
        let hcp2:[UILabel] = view2_HCP.subviews.compactMap{ $0 as? UILabel }
        let par2:[UILabel] = view2_Par.subviews.compactMap{ $0 as? UILabel }
        
        let ply11:[UILabel] = view2_Ply1.subviews.compactMap{ $0 as? UILabel }
        let ply22:[UILabel] = view2_Ply2.subviews.compactMap{ $0 as? UILabel }
        let ply33:[UILabel] = view2_Ply3.subviews.compactMap{ $0 as? UILabel }
        let ply44:[UILabel] = view2_Ply4.subviews.compactMap{ $0 as? UILabel }
        let ply55:[UILabel] = view2_Ply5.subviews.compactMap{ $0 as? UILabel }
        
        for scorecard in (self.scoreboardDetailsDict?.scoreBoard)! {
            i = 0
            if scorecard.holeName == "Out_Val" {
                
                let button: UILabel = yards2[0]
                if scorecard.yards == "" {
                    button.text = "_"
                }else {
                    button.text = scorecard.yards ?? ""
                }
                
                let button2: UILabel = hcp2[0]
                if scorecard.hcp == "" {
                    button2.text = "_"
                }else {
                    button2.text = scorecard.hcp ?? ""
                }
                
                let button3: UILabel = par2[0]
                if scorecard.par == "" {
                    button3.text = "_"
                }else {
                    button3.text = scorecard.par ?? ""
                }
                
                for score in (scorecard.players)! {
                    if i == 0 {
                        let button: UILabel = ply11[0]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 1 {
                        let button: UILabel = ply22[0]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 2 {
                        let button: UILabel = ply33[0]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 3 {
                        let button: UILabel = ply44[0]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 4 {
                        let button: UILabel = ply55[0]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }
                    i += 1
                }
            }
        }
        
        for scorecard in (self.scoreboardDetailsDict?.scoreBoard)! {
            i = 0
            if scorecard.holeName == "In_Val" {
                
                let button: UILabel = yards2[1]
                if scorecard.yards == "" {
                    button.text = "_"
                }else {
                    button.text = scorecard.yards ?? ""
                }
                
                let button2: UILabel = hcp2[1]
                if scorecard.hcp == "" {
                    button2.text = "_"
                }else {
                    button2.text = scorecard.hcp ?? ""
                }
                
                let button3: UILabel = par2[1]
                if scorecard.par == "" {
                    button3.text = "_"
                }else {
                    button3.text = scorecard.par ?? ""
                }
                
                for score in (scorecard.players)! {
                    if i == 0 {
                        let button: UILabel = ply11[1]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 1 {
                        let button: UILabel = ply22[1]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 2 {
                        let button: UILabel = ply33[1]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 3 {
                        let button: UILabel = ply44[1]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 4 {
                        let button: UILabel = ply55[1]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }
                    i += 1
                }
            }
        }
        
        for scorecard in (self.scoreboardDetailsDict?.scoreBoard)! {
            i = 0
            if scorecard.holeName == "Total" {
                
                let button: UILabel = yards2[2]
                if scorecard.yards == "" {
                    button.text = "_"
                }else {
                    button.text = scorecard.yards ?? ""
                }
                
                let button2: UILabel = hcp2[2]
                if scorecard.hcp == "" {
                    button2.text = "_"
                }else {
                    button2.text = scorecard.hcp ?? ""
                    handicap = scorecard.hcp ?? ""
                }
                
                let button3: UILabel = par2[2]
                if scorecard.par == "" {
                    button3.text = "_"
                }else {
                    button3.text = scorecard.par ?? ""
                }
                
                for score in (scorecard.players)! {
                    if i == 0 {
                        let button: UILabel = ply11[2]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 1 {
                        let button: UILabel = ply22[2]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 2 {
                        let button: UILabel = ply33[2]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 3 {
                        let button: UILabel = ply44[2]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }else if i == 4 {
                        let button: UILabel = ply55[2]
                        if score.score == "" || score.score == "0" {
                            button.text = "0"
                        }else {
                            button.text = score.score ?? ""
                        }
                    }
                    i += 1
                }
            }
        }
        
        for scorecard in (self.scoreboardDetailsDict?.scoreBoard)! {
            
            if scorecard.holeName == "Rating" {
                self.ratingLbl.text = "RATING\n\(scorecard.yards ?? "")"
            }else if scorecard.holeName == "Slope" {
                self.slopeLbl.text = "SLOPE\n\(scorecard.yards ?? "")"
            }
            // self.handicapLbl.text = "HANDICAP\n\(handicap)"
            
        }
        
        view_Ply1.isHidden = true
        view_Ply2.isHidden = true
        view_Ply3.isHidden = true
        view_Ply4.isHidden = true
        view_Ply5.isHidden = true
        
        view2_Ply1.isHidden = true
        view2_Ply2.isHidden = true
        view2_Ply3.isHidden = true
        view2_Ply4.isHidden = true
        view2_Ply5.isHidden = true
        
        ply1Name.isHidden = true
        ply2Name.isHidden = true
        ply3Name.isHidden = true
        ply4Name.isHidden = true
        ply5Name.isHidden = true
        
        if self.gameModelDict?.totalPlayers == 1 {
            view_Ply1.isHidden = false
            
            view2_Ply1.isHidden = false
            
            ply1Name.isHidden = false
            
            ply2Name_HeightConstraint.constant = 0
            ply3Name_HeightConstraint.constant = 0
            ply4Name_HeightConstraint.constant = 0
            ply5Name_HeightConstraint.constant = 0
            
            ViewPlay2_Height.constant = 0
            ViewPlay3_Height.constant = 0
            ViewPlay4_Height.constant = 0
            ViewPlay5_Height.constant = 0
            
            View2Play2_Height.constant = 0
            View2Play3_Height.constant = 0
            View2Play4_Height.constant = 0
            View2Play5_Height.constant = 0
            
            
        }else if self.gameModelDict?.totalPlayers == 2 {
            view_Ply1.isHidden = false
            view_Ply2.isHidden = false
            
            view2_Ply1.isHidden = false
            view2_Ply2.isHidden = false
            
            ply1Name.isHidden = false
            ply2Name.isHidden = false
            
            ply3Name_HeightConstraint.constant = 0
            ply4Name_HeightConstraint.constant = 0
            ply5Name_HeightConstraint.constant = 0
            
            ViewPlay3_Height.constant = 0
            ViewPlay4_Height.constant = 0
            ViewPlay5_Height.constant = 0
            
            View2Play3_Height.constant = 0
            View2Play4_Height.constant = 0
            View2Play5_Height.constant = 0
            
            
        }else if self.gameModelDict?.totalPlayers == 3 {
            view_Ply1.isHidden = false
            view_Ply2.isHidden = false
            view_Ply3.isHidden = false
            
            view2_Ply1.isHidden = false
            view2_Ply2.isHidden = false
            view2_Ply3.isHidden = false
            
            ply1Name.isHidden = false
            ply2Name.isHidden = false
            ply3Name.isHidden = false
            
            ply4Name_HeightConstraint.constant = 0
            ply5Name_HeightConstraint.constant = 0
            
            ViewPlay4_Height.constant = 0
            ViewPlay5_Height.constant = 0
            
            View2Play4_Height.constant = 0
            View2Play5_Height.constant = 0
            
        }else if self.gameModelDict?.totalPlayers == 4 {
            view_Ply1.isHidden = false
            view_Ply2.isHidden = false
            view_Ply3.isHidden = false
            view_Ply4.isHidden = false
            
            view2_Ply1.isHidden = false
            view2_Ply2.isHidden = false
            view2_Ply3.isHidden = false
            view2_Ply4.isHidden = false
            
            ply1Name.isHidden = false
            ply2Name.isHidden = false
            ply3Name.isHidden = false
            ply4Name.isHidden = false
            
            ply5Name_HeightConstraint.constant = 0
            
            ViewPlay5_Height.constant = 0
            
            View2Play5_Height.constant = 0
        }else if self.gameModelDict?.totalPlayers == 5 {
            view_Ply1.isHidden = false
            view_Ply2.isHidden = false
            view_Ply3.isHidden = false
            view_Ply4.isHidden = false
            view_Ply5.isHidden = false
            
            view2_Ply1.isHidden = false
            view2_Ply2.isHidden = false
            view2_Ply3.isHidden = false
            view2_Ply4.isHidden = false
            view2_Ply5.isHidden = false
            
            ply1Name.isHidden = false
            ply2Name.isHidden = false
            ply3Name.isHidden = false
            ply4Name.isHidden = false
            ply5Name.isHidden = false
        }else {
            
            view_Ply1.isHidden = false
            view_Ply2.isHidden = false
            view_Ply3.isHidden = false
            view_Ply4.isHidden = false
            view_Ply5.isHidden = false
            
            view2_Ply1.isHidden = false
            view2_Ply2.isHidden = false
            view2_Ply3.isHidden = false
            view2_Ply4.isHidden = false
            view2_Ply5.isHidden = false
            
            ply1Name.isHidden = false
            ply2Name.isHidden = false
            ply3Name.isHidden = false
            ply4Name.isHidden = false
            ply5Name.isHidden = false
        }
        
    }
    func endGameWS(userId: String, gameId: String) {
        let urlString :  String =  MyStrings().endGameWSUrl + "\(userId)" + "&GameId=" + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }else {
                self.errorAlert("Unable to end this game")
                //  self.show(message: "Unable to add to group", controller: self)
            }
        }
    }
}
