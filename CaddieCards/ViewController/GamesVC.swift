//
//  GamesVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 16/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import SideMenu

class GamesVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleGameBtn: UIButton!
    @IBOutlet weak var joinGameBtn: UIButton!
    @IBOutlet weak var createGameBtn: UIButton!
    @IBOutlet var lineLblArray: [UILabel]!
    @IBOutlet var barBtnsArray: [UIButton]!
    @IBOutlet weak var gamesTV: UITableView!
    var activeSel = Bool()
    var scheduleSel = Bool()
    var historySel = Bool()
    
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  scheduleArr = NSMutableArray()
    let notificationsBtn = BadgedButtonItem(with: UIImage(named: "mini-bell"))
    let searchImage   = UIImage(named: "search_icon")!
    
    @IBOutlet var noActiveGamesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "Games"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!]
        historySel = false
        scheduleSel = false
        activeSel = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = false
        setupSideMenu()
        
        gamesTV.tableFooterView = UIView()
        gamesTV.register(UINib(nibName: "ScheduledTVCell", bundle: nil), forCellReuseIdentifier: "ScheduledTVCell")
        gamesTV.register(UINib(nibName: "GameHistoryTVCell", bundle: nil), forCellReuseIdentifier: "GameHistoryTVCell")
        gamesTV.register(UINib(nibName: "ActiveGameTVCell", bundle: nil), forCellReuseIdentifier: "ActiveGameTVCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = false
        
        for lbl in lineLblArray
        {
            lbl.backgroundColor = UIColor.white
        }
        lineLblArray[0].backgroundColor = GlobalConstants.APPCOLOR
        
        if activeSel == true  {
            getActiveDetailsWS(userId: userId)
        }else if scheduleSel == true  {
            for lbl in lineLblArray
            {
                lbl.backgroundColor = UIColor.white
            }
            lineLblArray[1].backgroundColor = GlobalConstants.APPCOLOR
            
            getScheduleDetailsWS(userId: userId)
        }else if historySel == true {
            for lbl in lineLblArray
            {
                lbl.backgroundColor = UIColor.white
            }
            lineLblArray[2].backgroundColor = GlobalConstants.APPCOLOR
            
            getHistoryDetailsWS(userId: userId)
        }else {
            
        }
        self.getunReadNotificationsCount()

        notificationsBtn.tapAction = {
                    //self.notificationsBtn.setBadge(with: 1)
                }
        let searchBtn   = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapsearchBtn))
        self.navigationItem.rightBarButtonItems = [searchBtn,notificationsBtn]

    }
    @objc func didTapsearchBtn(sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVCObj = storyboard.instantiateViewController(withIdentifier: "SearchGameVC") as! SearchGameVC
        if scheduleSel == true  {
            searchVCObj.searchTypeName = "scheduled"
        }else if historySel == true {
            searchVCObj.searchTypeName = "history"
        }else {
            searchVCObj.searchTypeName = "active"
        }
        self.navigationController?.pushViewController(searchVCObj, animated: true)
    }
    //MARK: - Webservice methods
    func getunReadNotificationsCount() {
        
        var urlString :  String = ""
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        urlString  =  MyStrings().getUnreadNotificationsUrl + "\(custId)"
        
        self.startLoadingIndicator(loadTxt: "Loading...") //Commented due to loading two indicators
        
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
            let count = response.customModel as? Int
//
//            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//            if jsonString != "" {
              //  let count = Int(jsonString) ?? 0
                if count ?? 0 != 0 {
                    DispatchQueue.main.async {
                    self.notificationsBtn.setBadge(with: count!)
                    }
                }
            //}
            
            
        }
    }
    //MARK: - Side Menu Method for displaying some more tabs
    
    fileprivate func setupSideMenu() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController;
      //  SideMenuManager.default.leftMenuNavigationController?.menuWidth = 100
        SideMenuManager.default.menuRightNavigationController = nil
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuFadeStatusBar = false
    }
    //MARK: - Button Action Methods
    @IBAction func createGameBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    @IBAction func activeBtnTapped(_ sender: Any) {
        for lbl in lineLblArray
        {
            lbl.backgroundColor = UIColor.white
        }
        lineLblArray[0].backgroundColor = GlobalConstants.APPCOLOR
        historySel = false
        scheduleSel = false
        activeSel = true
        scheduleArr.removeAllObjects()
        //joinSel = false //Will comment after api implemented.just for testing now this line.
        getActiveDetailsWS(userId: userId)
    }
    @IBAction func scheduleGameBtnTapped(_ sender: Any) {
        /*
         for btn in barBtnsArray
         {
         btn.setTitleColor(.white, for: .normal)
         }
         barBtnsArray[0].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
         */
        for lbl in lineLblArray
        {
            lbl.backgroundColor = UIColor.white
        }
        lineLblArray[1].backgroundColor = GlobalConstants.APPCOLOR
        historySel = false
        activeSel = false
        scheduleSel = true
        scheduleArr.removeAllObjects()
        getScheduleDetailsWS(userId: userId)
    }
    @IBAction func historyBtnTapped(_ sender: Any) {
        /*
         for btn in barBtnsArray
         {
         btn.setTitleColor(.white, for: .normal)
         }
         barBtnsArray[1].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
         */
        for lbl in lineLblArray
        {
            lbl.backgroundColor = UIColor.white
        }
        lineLblArray[2].backgroundColor = GlobalConstants.APPCOLOR
        historySel = true
        scheduleSel = false
        activeSel = false
        scheduleArr.removeAllObjects()
        getHistoryDetailsWS(userId: userId)
    }
    
    @IBAction func notificationsBtnTapped(_ sender: Any) {
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVCObj = storyboard.instantiateViewController(withIdentifier: "SearchGameVC") as! SearchGameVC
        if scheduleSel == true  {
            searchVCObj.searchTypeName = "scheduled"
        }else if historySel == true {
            searchVCObj.searchTypeName = "history"
        }else {
            searchVCObj.searchTypeName = "active"
        }
        self.navigationController?.pushViewController(searchVCObj, animated: true)
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
         if scheduleSel == true {
         return 1
         }else  {
         return 1
         }
         */
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scheduleArr.count > 0 && (scheduleSel == true || historySel == true || activeSel == true) {
            tableView.backgroundView  = nil
            return self.scheduleArr.count
        }else  {
            if self.scheduleArr.count <= 0 && (scheduleSel == false || historySel == false || activeSel == false)
            {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                if activeSel == true {
                    tableView.backgroundView  = noActiveGamesView
                }else {
                    noDataLabel.text          = "Coming Soon"
                    tableView.backgroundView  = noDataLabel
                }
                noDataLabel.textColor     = UIColor.black
                noDataLabel.font = UIFont.boldSystemFont(ofSize: 17)
                noDataLabel.textAlignment = .center
                tableView.separatorStyle  = .none
            }else {
                tableView.backgroundView  = nil
                return self.scheduleArr.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if scheduleSel == true {
            if self.scheduleArr.count > 0 {
                let scheduleDict  = self.scheduleArr[indexPath.row]
                let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTVCell", for: indexPath) as! ScheduledTVCell
                
                scheduleCell.updateLabels(scheduleDict as! NSDictionary)
                
                // scheduleCell.imOutBtn.addTarget(self, action: #selector(imOutBtnTapped(_:)), for: .touchUpInside)
                scheduleCell.imOutBtn.addTarget(self, action: #selector(playBtnTapped(_:)), for: .touchUpInside)
                scheduleCell.messageBtn.addTarget(self, action: #selector(messageBtnTapped(_:)), for: .touchUpInside)
                /*
                 scheduleCell.editTimeBtn.isHidden = false
                 scheduleCell.editTimeBtn.addTarget(self, action: #selector(editScheduleBtnTapped(_:)), for: .touchUpInside)
                 */
                scheduleCell.scoresBtn.addTarget(self, action: #selector(editScheduleBtnTapped(_:)), for: .touchUpInside)
                scheduleCell.cardView.layer.cornerRadius = 5.0
                scheduleCell.cardView.layer.borderWidth = 1.0
                scheduleCell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                scheduleCell.cardView.clipsToBounds = true
                
                return scheduleCell
            }else {
                let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTVCell", for: indexPath) as! ScheduledTVCell
                return scheduleCell
            }
        }else if historySel == true  {
            if self.scheduleArr.count > 0 {
                let scheduleDict  = self.scheduleArr[indexPath.row]
                let historyCell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryTVCell", for: indexPath) as! GameHistoryTVCell
                
                historyCell.updateLabels(scheduleDict as! NSDictionary)
                
                historyCell.replayBtn.addTarget(self, action: #selector(replayBtnTapped(_:)), for: .touchUpInside)
                historyCell.scoresBtn.addTarget(self, action: #selector(scoresBtnTapped(_:)), for: .touchUpInside)
                
                historyCell.cardView.layer.cornerRadius = 5.0
                historyCell.cardView.layer.borderWidth = 1.0
                historyCell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                historyCell.cardView.clipsToBounds = true
                
                return historyCell
            }else {
                let historyCell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryTVCell", for: indexPath) as! GameHistoryTVCell
                return historyCell
            }
        }else {
            if self.scheduleArr.count > 0 {
                let scheduleDict  = self.scheduleArr[indexPath.row]
                let activeCell = tableView.dequeueReusableCell(withIdentifier: "ActiveGameTVCell", for: indexPath) as! ActiveGameTVCell
                
                activeCell.updateLabels(scheduleDict as! NSDictionary)
                
                activeCell.resumeBtn.addTarget(self, action: #selector(resumeBtnTapped(_:)), for: .touchUpInside)
                activeCell.editBtn.addTarget(self, action: #selector(editBtnTapped(_:)), for: .touchUpInside)
                activeCell.endBtn.addTarget(self, action: #selector(endBtnTapped(_:)), for: .touchUpInside)
                
                activeCell.cardView.layer.cornerRadius = 5.0
                activeCell.cardView.layer.borderWidth = 1.0
                activeCell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                activeCell.cardView.clipsToBounds = true
                
                return activeCell
            }else {
                let activeCell = tableView.dequeueReusableCell(withIdentifier: "ActiveGameTVCell", for: indexPath) as! ActiveGameTVCell
                return activeCell
            }
        }
    }
    
    //MARK: - Web Service Methods
    func getScheduleDetailsWS(userId: NSInteger) {
        
        let urlString :  String =  MyStrings().getScheduleDetailsUrl + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
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
                let dict = response.customModel
                
                self.scheduleArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response.customModel, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                let friends = Mapper<FriendsModel>().map(JSONString: jsonString)
                print(friends?.firstName ?? "")
                self.gamesTV.reloadData()
                
            }else {
                self.scheduleArr.removeAllObjects()
                self.gamesTV.reloadData()
            }
        }
    }
    func getActiveDetailsWS(userId: NSInteger) {
        
        let urlString :  String =  MyStrings().getActiveDetailsUrl + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
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
                let dict = response.customModel
                
                self.scheduleArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response.customModel, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                let friends = Mapper<FriendsModel>().map(JSONString: jsonString)
                print(friends?.firstName ?? "")
                self.gamesTV.reloadData()
                
            }else {
                self.scheduleArr.removeAllObjects()
                self.gamesTV.reloadData()
            }
        }
    }
    func getHistoryDetailsWS(userId: NSInteger) {
        
        let urlString :  String =  MyStrings().getHistoryGameDataUrl + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
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
                let dict = response.customModel
                
                self.scheduleArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                self.gamesTV.reloadData()
                
            }else {
                self.scheduleArr.removeAllObjects()
                self.gamesTV.reloadData()
            }
        }
    }
    func  imOutWS(gameId: String) {
        
        let params: Parameters = [
            "GameId": gameId,
            "Players": "1",
            "Purpose": "delete"
        ]
        print("Edit game data ( im out) Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().deletePlayerUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.getScheduleDetailsWS(userId: self.userId)
            }
        }
    }
    func endGameWS(userId: String, gameId: String) {
        let urlString :  String =  MyStrings().endGameWSUrl + "\(userId)" + "&GameId=" + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
                self.getActiveDetailsWS(userId: self.userId)
            }else {
                self.errorAlert("Unable to end this game")
                //  self.show(message: "Unable to add to group", controller: self)
            }
        }
    }
    func deleteGameWS(gameId: String) {
        let urlString :  String =  MyStrings().deleteScheduleGameWSUrl + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
                self.getScheduleDetailsWS(userId: self.userId)
            }else {
                self.errorAlert("Unable to delete this game")
                //  self.show(message: "Unable to add to group", controller: self)
            }
        }
    }
    
    //MARK: - Schedule Action Methods
    @objc func playBtnTapped(_ sender: UIButton) {
        /*
         let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
         let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
         let scheduleDict  = self.scheduleArr[indexPath!.row] as! NSDictionary
         self.showSimpleAlert(dict: scheduleDict)
         */
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        let gameId =  (dict["GameId"] as? String ?? "")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(playVCObj, animated: true)
        
    }
    @objc func messageBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        let gameId =  (dict["GameId"] as? String ?? "")
        
        let alert = UIAlertController(title: "Delete This Game?", message: "", preferredStyle: .alert)
        alert.view.tintColor = GlobalConstants.APPGREENCOLOR
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.deleteGameWS(gameId: gameId)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editScheduleBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let dtVCObj = storyboard.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
         //  dtVCObj.scheduleDict = dict
         let gameId =  (dict["GameId"] as? String ?? "")
         dtVCObj.gameId = NSNumber.init(value: Int32(gameId)!)
         self.navigationController?.pushViewController(dtVCObj, animated: true)
         */
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    
    //MARK: - History Action Methods
    
    @objc func scoresBtnTapped(_ sender: UIButton) {
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
//        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
//        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScorebordVC") as! ScorebordVC
//        let gameId =  (dict["GameId"] as? String ?? "")
//        scoresVCObj.gameId = NSNumber.init(value: Int32(gameId)!)
//        self.navigationController?.pushViewController(scoresVCObj, animated: true)
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        let gameId =  (dict["GameId"] as? String ?? "")
        
        UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
        UserDefaults.standard.removeObject(forKey: "radioSelDict")
        UserDefaults.standard.removeObject(forKey: "wolfRadioSelArray")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(playVCObj, animated: true)
    }
    @objc func replayBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        cGameVCObj.isReplayVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    
    //MARK: - Active Action Methods
    
    @objc func resumeBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        let gameId =  (dict["GameId"] as? String ?? "")
        
        UserDefaults.standard.removeObject(forKey: "isSubmitBtnClicked")
        UserDefaults.standard.removeObject(forKey: "radioSelDict")
        UserDefaults.standard.removeObject(forKey: "wolfRadioSelArray")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(playVCObj, animated: true)
    }
    @objc func editBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        // cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        if let myInteger = Int(gameId) {
            cGameVCObj.editReplayGameId  = NSNumber(value:myInteger)
        }
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    @objc func endBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.gamesTV)
        let indexPath = self.gamesTV.indexPathForRow(at: buttonPosition)
        let dict  = self.scheduleArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        
        let alert = UIAlertController(title: "Do you want to END this game?", message: "", preferredStyle: .alert)
        alert.view.tintColor = GlobalConstants.APPGREENCOLOR
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.endGameWS(userId: String(self.userId), gameId: gameId)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Alert Controller
    func showSimpleAlert(dict: NSDictionary) {
        let alert = UIAlertController(title: "Quit Game", message: "Do you really want to quit this game?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        let gameID =  (dict["GameId"] as? String ?? "")
                                        
                                        self.imOutWS(gameId: gameID)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
class BadgedButtonItem: UIBarButtonItem {

    public func setBadge(with value: Int) {
        self.badgeValue = value
    }

    private var badgeValue: Int? {
        didSet {
            if let value = badgeValue,
                value > 0 {
                lblBadge.isHidden = false
                lblBadge.text = "\(value)"
            } else {
                lblBadge.isHidden = true
            }
        }
    }

    var tapAction: (() -> Void)?

    private let filterBtn = UIButton()
    private let lblBadge = UILabel()

    override init() {
        super.init()
        setup()
    }

    init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(image: UIImage? = nil) {

        self.filterBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.filterBtn.adjustsImageWhenHighlighted = false
        self.filterBtn.setImage(image, for: .normal)
        self.filterBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        self.lblBadge.frame = CGRect(x: 20, y: -1, width: 15, height: 15)
        self.lblBadge.backgroundColor = .red
        self.lblBadge.clipsToBounds = true
        self.lblBadge.layer.cornerRadius = 7
        self.lblBadge.textColor = UIColor.white
        self.lblBadge.font = UIFont.systemFont(ofSize: 10)
        self.lblBadge.textAlignment = .center
        self.lblBadge.isHidden = true
        self.lblBadge.minimumScaleFactor = 0.1
        self.lblBadge.adjustsFontSizeToFitWidth = true
        self.filterBtn.addSubview(lblBadge)
        self.customView = filterBtn
    }

    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }

}
