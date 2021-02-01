//
//  SelectMembersVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/06/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

protocol SelectedMembersDelegateProtocol {
    func sendMembersToCreteGameVC(members: String, count: NSInteger)
}

class SelectMembersVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,MyDataSendingDelegateProtocol {
    
    var delegate: SelectedMembersDelegateProtocol? = nil
    
    @IBOutlet weak var sMembersTV: UITableView!
    @IBOutlet weak var groupBtn: UIButton!
    @IBOutlet weak var friendsBtn: UIButton!
    var friendSel = Bool()
    var groupSel = Bool()
    var groupsArray = NSMutableArray()
    var  groupMembersArr = NSMutableArray()
    var selctedMembersArr = NSMutableArray()
    var  groupDetailsArr = NSMutableArray()
    var profileDataArray = GameViewDetailsModel(JSONString: "")
    var groupID: Int = 0
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    
    var editOrReplayDict = EditOrReplayGameModel(JSONString: "")
    var isEditReply = Bool()
    let groupsIds = NSMutableArray()
    var playersArray = NSMutableArray()
    
    var editReplayGameId: NSNumber = 0
    var isReplayVC : Bool = false
    let notificationsBtn = BadgedButtonItem(with: UIImage(named: "mini-bell"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Replace the default back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        //    self.backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "arrow_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
        self.title = "SELECT PLAYERS"
        self.navigationItem.rightBarButtonItem = notificationsBtn
        //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SUBMIT", style: UIBarButtonItem.Style.plain, target: self, action: #selector(submitBtnTapped))
        
        friendSel = false
        //  groupSel = true
        groupSel = false
        groupBtn.setTitle("Select Group", for: .normal)
        if isEditReply == false {
            friendsBtn.setTitle("Add Players", for: .normal)
        }
        //  groupBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        
        sMembersTV.tableFooterView = UIView()
        sMembersTV.register(UINib(nibName: "GroupYouTVCell", bundle: nil), forCellReuseIdentifier: "GroupYouTVCell")
        
        //  let groupsIds = NSMutableArray()
        if isEditReply == false {
            for group in (self.profileDataArray?.groups)! {
                groupsIds.add(group.groupId)
            }
            
            if UserDefaults.contains("groupDetailsArr") {
                let detailsArr = (UserDefaults.standard.object(forKey: "groupDetailsArr") as! NSArray).mutableCopy() as! NSMutableArray
                if detailsArr.count > 0 {
                    self.groupDetailsArr = detailsArr.mutableCopy() as! NSMutableArray
                    //  UserDefaults.standard.removeObject(forKey: "groupDetailsArr")
                }else {
                    
                    let dict = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
                    let customeId = UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
                    
                    let firstName = dict["FirstName"] as? String ?? ""
                    let lastName = dict["LastName"] as? String ?? ""
                    
                    var nameStr: String = ""
                    if lastName != "" {
                        nameStr = firstName + " " + lastName
                    }else {
                        nameStr = firstName
                    }
                    let dict2 = NSMutableDictionary()
                    dict2.setValue(String(customeId), forKey: "CustomerId")
                    dict2.setValue(nameStr, forKey: "FirstName")
                    self.groupDetailsArr.add(dict2)
                }
            }else {
                let dict = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
                let customeId = UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
                
                let firstName = dict["FirstName"] as? String ?? ""
                let lastName = dict["LastName"] as? String ?? ""
                
                var nameStr: String = ""
                if lastName != "" {
                    nameStr = firstName + " " + lastName
                }else {
                    nameStr = firstName
                }
                let dict2 = NSMutableDictionary()
                dict2.setValue(String(customeId), forKey: "CustomerId")
                dict2.setValue(nameStr, forKey: "FirstName")
                self.groupDetailsArr.add(dict2)
            }
        }else {
            for group in (self.editOrReplayDict?.groups)! {
                groupsIds.add(group.groupId)
            }
            for player in (self.editOrReplayDict?.players)! {
                let dict = NSMutableDictionary()
                print("Customer Id = \(String(describing: player.customerId)) and firstName = \(player.firstName ?? "")")
                dict.setValue(player.customerId!, forKey: "CustomerId")
                dict.setValue(player.firstName, forKey: "FirstName")
                self.groupDetailsArr.add(dict)
            }
        }
        sMembersTV.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sMembersTV.reloadData()
        self.getunReadNotificationsCount()
    }
    // Then handle the button selection
    @objc func goBack() {
        // Here we just remove the back button, you could also disabled it or better yet show an activityIndicator
        self.navigationItem.leftBarButtonItem = nil
        
        
        let alert = UIAlertController(title: "Save Your Changes?", message: "", preferredStyle: .alert)
        alert.view.tintColor = GlobalConstants.APPGREENCOLOR
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                // Don't forget to re-enable the interactive gesture
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.submitBtnTapped(UIButton.init())
                // self.navigationController?.popViewController(animated: true)
                
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                // Don't forget to re-enable the interactive gesture
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationController?.popViewController(animated: true)
                // self.navigationItem.leftBarButtonItem = self.backButton
                
            case .destructive:
                print("destructive")
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
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
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
         if (friendSel == true || groupSel == true) && self.groupDetailsArr.count > 0 {
         return 2
         }else if friendSel == true || groupSel == true {
         return 1
         }
         */
        if groupSel == true && self.groupDetailsArr.count > 0 {
            return 2
        }else if friendSel == true || groupSel == true {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && groupSel == true { //(friendSel == true || groupSel == true) {
            return 1
        }else {
            return self.groupDetailsArr.count
        }
        /*else if section == 0 && (friendSel == false || groupSel == false) {
         return self.groupDetailsArr.count
         }else if section == 1 {
         return self.groupDetailsArr.count
         }
         return 0
         */
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && groupSel == true {
            /*
             if friendSel == true {
             
             let sFCell = tableView.dequeueReusableCell(withIdentifier: "SearchFrndCell", for: indexPath) as! SearchFrndCell
             
             sFCell.searchFrndBtn.addTarget(self, action: #selector(searchFrndBtnTapped(_:)), for: .touchUpInside)
             
             sFCell.searchFrndBtn.layer.cornerRadius = 5.0
             sFCell.searchFrndBtn.layer.borderWidth = 1.0
             sFCell.searchFrndBtn.layer.borderColor = UIColor.lightGray.cgColor
             sFCell.searchFrndBtn.clipsToBounds = true
             
             return sFCell
             }else
             */
            if groupSel == true {
                
                let sGCell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupCell", for: indexPath) as! SelectGroupCell
                //  sGCell.groupDWBtn.setTitle(groupsArray[indexPath.row] as? String, for: .normal)
                sGCell.groupDWBtn.addTarget(self, action: #selector(selectGroupBtnTapped(_:)), for: .touchUpInside)
                
                return sGCell
            }else {
                if  indexPath.row < self.groupDetailsArr.count {
                    let groupFrndDict  = self.groupDetailsArr[indexPath.row] as! NSDictionary
                    let mCell = tableView.dequeueReusableCell(withIdentifier: "MembersCell", for: indexPath) as! MembersCell
                    
                    let firstName =  (groupFrndDict["FirstName"] as? String ?? "")
                    let lastName = (groupFrndDict["LastName"] as? String ?? "")
                    var nameStr: String = ""
                    if lastName != "" {
                        nameStr = firstName + " " + lastName
                    }else {
                        nameStr = firstName
                    }
                    mCell.mTitle.text = "Player " + "\(indexPath.row + 1)" + ":"
                    mCell.mName.text = nameStr
                    
                    //                    let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
                    //                    mCell.cancelBtn.setImage(image, for: .normal)
                    //                    mCell.cancelBtn.tintColor = UIColor.red
                    
                    mCell.cancelBtn.addTarget(self, action: #selector(cancelFrndBtnTapped(_:)), for: .touchUpInside)
                    
                    return mCell
                }
            }
        }
        if indexPath.row < self.groupDetailsArr.count {
            let groupFrndDict  = self.groupDetailsArr[indexPath.row] as! NSDictionary
            let userType =  (groupFrndDict["UserType"] as? String ?? "")
            if userType == "You" {
                let gYouCell = tableView.dequeueReusableCell(withIdentifier: "GroupYouTVCell", for: indexPath) as! GroupYouTVCell
                let firstName =  (groupFrndDict["FirstName"] as? String ?? "")
                gYouCell.nameLbl.text = firstName
                
                return gYouCell
            }else {
                let mCell = tableView.dequeueReusableCell(withIdentifier: "MembersCell", for: indexPath) as! MembersCell
                
                let firstName =  (groupFrndDict["FirstName"] as? String ?? "")
                let lastName = (groupFrndDict["LastName"] as? String ?? "")
                var nameStr: String = ""
                if lastName != "" {
                    nameStr = firstName + " " + lastName
                }else {
                    nameStr = firstName
                }
                mCell.mTitle.text = "Player " + "\(indexPath.row + 1)" + ":"
                mCell.mName.text = nameStr
                
                //                let image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
                //                mCell.cancelBtn.setImage(image, for: .normal)
                //                mCell.cancelBtn.tintColor = UIColor.red
                
                mCell.cancelBtn.addTarget(self, action: #selector(cancelFrndBtnTapped(_:)), for: .touchUpInside)
                
                return mCell
            }
        }
        return UITableViewCell()
    }
    
    //MARK: - Button Action Method
    @IBAction func friendsBtnTapped(_ sender: Any) {
        friendSel = true
        groupSel = false
        if isEditReply == false {
            friendsBtn.setTitle("Add Players", for: .normal)
        }else {
            friendsBtn.setTitle("Edit Players", for: .normal)
        }
        friendsBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        groupBtn.setTitle("Select Group", for: .normal)
        groupBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        
        // sMembersTV.reloadData()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aFrndVCObj = storyboard.instantiateViewController(withIdentifier: "AddFriendVC") as! AddFriendVC
        aFrndVCObj.delegate = self
        aFrndVCObj.isFromSMVC = true
        aFrndVCObj.isEditReply = isEditReply
        aFrndVCObj.selctedFrndsArr = groupMembersArr
        aFrndVCObj.totalFrndsArr = self.groupDetailsArr
        aFrndVCObj.editReplayGameId = editReplayGameId
        self.navigationController?.pushViewController(aFrndVCObj, animated: true)
    }
    @IBAction func groupBtnTapped(_ sender: Any) {
        friendSel = false
        groupSel = true
        
        if isEditReply == false {
            friendsBtn.setTitle("Add Players", for: .normal)
        }else {
            friendsBtn.setTitle("Edit Players", for: .normal)
        }
        friendsBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        groupBtn.setTitle("Select Group", for: .normal)
        groupBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        
        sMembersTV.reloadData()
        
        if   groupSel == true {
            if isEditReply == false {
                let indexPath = NSIndexPath(row: 0, section: 0)
                let cell = self.sMembersTV.cellForRow(at: indexPath as IndexPath) as! SelectGroupCell
                cell.groupDWBtn.setTitle(self.groupsArray[0] as? String, for: .normal)
                
                let gID: String = groupsIds[0] as! String
                self.groupID = Int(gID)!
                self.getGroupDetailsWS(userId: self.userId, groupId: self.groupID)
            }else {
                let indexPath = NSIndexPath(row: 0, section: 0)
                let cell = self.sMembersTV.cellForRow(at: indexPath as IndexPath) as! SelectGroupCell
                cell.groupDWBtn.setTitle(self.groupsArray[0] as? String, for: .normal)
            }
        }
    }
    @objc func searchFrndBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aFrndVCObj = storyboard.instantiateViewController(withIdentifier: "AddFriendVC") as! AddFriendVC
        aFrndVCObj.delegate = self
        aFrndVCObj.isFromSMVC = true
        aFrndVCObj.selctedFrndsArr = groupMembersArr
        self.navigationController?.pushViewController(aFrndVCObj, animated: true)
    }
    @objc func cancelFrndBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.sMembersTV)
        let indexPath = self.sMembersTV.indexPathForRow(at: buttonPosition)
        
        self.groupDetailsArr.removeObject(at: (indexPath?.row)!)
        self.sMembersTV.reloadData()
    }
    @objc func selectGroupBtnTapped(_ sender: UIButton) {
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
        FTPopOverMenu.showForSender(sender: sender as UIView,
                                    with: self.groupsArray as! [String],
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        
                                        /*
                                         let groupsIds = NSMutableArray()
                                         // let groupNames = NSMutableArray()
                                         if self.isEditReply == false {
                                         for group in (self.profileDataArray?.groups)! {
                                         groupsIds.add(group.groupId)
                                         //  groupNames.add(group.groupName)
                                         }
                                         }else {
                                         for group in (self.editOrReplayDict?.groups)! {
                                         groupsIds.add(group.groupId)
                                         }
                                         }
                                         */
                                        if selectedIndex < self.groupsArray.count {
                                            let indexPath = NSIndexPath(row: 0, section: 0)
                                            // let cell = self.sMembersTV.cellForRow(at: indexPath as IndexPath)
                                            let cell = self.sMembersTV.cellForRow(at: indexPath as IndexPath) as! SelectGroupCell
                                            cell.groupDWBtn.setTitle(self.groupsArray[selectedIndex] as? String, for: .normal)
                                            let gID: String = self.groupsIds[selectedIndex - 1] as! String
                                            self.groupID = Int(gID)!
                                            self.getGroupDetailsWS(userId: self.userId, groupId: self.groupID)
                                        }
        }){
        }
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.groupDetailsArr.count <= 5 {
            
            UserDefaults.standard.setValue(self.groupDetailsArr, forKey: "groupDetailsArr")
            UserDefaults.standard.synchronize()
            
            for (index2, item2) in self.groupDetailsArr.enumerated() {
                print("Found \(item2) at position \(index2)")
                let secondDict = item2 as? NSDictionary
                let userID = secondDict?["UserId"] as? String ?? ""
                let custmerID = secondDict?["CustomerId"]
                if userID == "" {
                    selctedMembersArr.add(custmerID!)
                }else {
                    selctedMembersArr.add(userID)
                }
            }
            var membersStr =   self.selctedMembersArr.componentsJoined(by: ",")
            if  membersStr.contains("\(userId)") == false {
                membersStr = membersStr + ",\(userId)"
            }
            // membersStr.removeDuplicates()
            
            if self.delegate != nil {
                let membersCount = self.groupDetailsArr.count
                self.delegate?.sendMembersToCreteGameVC(members: membersStr, count: membersCount)
                
                if isEditReply == true {
                    var courseTitle = ""
                    var gameTitle = ""
                    var teeTitle = ""
                    
                    if let text = self.editOrReplayDict?.course {
                        print(text)
                        courseTitle = text
                    }
                    if let text = self.editOrReplayDict?.game {
                        print(text)
                        gameTitle = text
                    }
                    if let text = self.editOrReplayDict?.teeName{
                        print(text)
                        teeTitle = text
                    }
                    
                    var params: Parameters = [
                        "CustomerId": userId,
                        "GameName": self.editOrReplayDict?.gameName ?? "",
                        "Course": courseTitle as Any,
                        "Game": gameTitle as Any,
                        "TeeName": teeTitle as Any
                    ]
                    if self.editOrReplayDict?.playNow == "1" {
                        params["PlayNow"] = true
                    }else {
                        params["PlayNow"] = false
                    }
                    params["IsPermanent"] = false
                    if self.isReplayVC == true {
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yyyy"
                        let dateStr = formatter.string(from: date)
                        
                        let time = date.addingTimeInterval(TimeInterval(10.0 * 60.0))
                        formatter.dateFormat = "hh:mm a"
                        let timeStr = formatter.string(from: time)
                        params["ScheduleDate"] = dateStr
                        params["ScheduleTime"] = timeStr
                    }else {
                        let dateStr = self.editOrReplayDict?.scheduleDate ?? ""
                        let timeStr = self.editOrReplayDict?.scheduleTime ?? ""
                        params["ScheduleDate"] = dateStr
                        params["ScheduleTime"] = timeStr
                    }
                    params["Members"] = membersStr
                    
                    if self.editOrReplayDict?.caddieCards == "1" {
                        params["CaddieCards"] = true
                    }else {
                        params["CaddieCards"] = false
                    }
                    
                    if self.editOrReplayDict?.animals == "1" {
                        params["Animals"] = true
                    }else {
                        params["Animals"] = false
                    }
                    
                    if self.editOrReplayDict?.scoreType  == "0" {
                        params["ScoreType"] = false
                    }else {
                        params["ScoreType"] = true
                    }
                    params["GameId"] = NSInteger(truncating: editReplayGameId)
                    
                    print("Create Game View Parameters = \(params)")
                    
                    self.startLoadingIndicator(loadTxt: "Loading...")
                    
                    ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().replayOrEditGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
                        print(response as Any)
                        
                        if(response.isSuccess){
                            print("Create Group Responce = \(response.responseDictionary)")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            self.errorAlert("Only 5 players are allowed in a game")
            // self.show(message: "Groups are limited to 5 players. To add more players, select “more groups”", controller: self)
        }
    }
    @objc func submitBtnTapped() {
    }
    //MARK: - Delegate Method
    func sendDataToCreteGroupVC(dict: NSDictionary) {
        print(dict)
        let firstName =  (dict["FirstName"] as? String ?? "")
        //   selctedMembersArr.add(dict["userId"] as Any)
        if self.groupDetailsArr.count <= 5 {  //Added Players Count Max 5
            groupMembersArr.add(firstName)
            //  self.groupDetailsArr.add(dict)
        }else {
            self.errorAlert("Only 5 players are allowed in a game")
            //  self.show(message: "Groups are limited to 5 players. To add more players, select “more groups”", controller: self)
        }
        sMembersTV.reloadData()
    }
    
    // MARK: - Web Service Methods
    func getGroupDetailsWS(userId: NSInteger, groupId: NSInteger) {
        let urlString :  String =  MyStrings().getGroupDetailsUrl + "\(groupId)" + "&UserId=" + "\(userId)"
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
                
                self.groupDetailsArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                for (index, element) in (self.groupDetailsArr).enumerated() {
                    let dict = element as! NSDictionary
                    let userType =  (dict["UserType"] as? String ?? "")
                    if userType == "You" {
                        self.groupDetailsArr.removeObject(at: index)
                        break
                    }
                }
                self.sMembersTV.reloadData()
            }else {
                self.groupDetailsArr.removeAllObjects()
                self.sMembersTV.reloadData()
            }
        }
    }
    
}
extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}
