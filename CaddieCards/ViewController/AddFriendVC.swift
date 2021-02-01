//
//  AddFriendVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToCreteGroupVC(dict: NSDictionary)
}

class AddFriendVC: BaseViewController,UITableViewDelegate,UITableViewDataSource , UITextFieldDelegate, UISearchBarDelegate {
    
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    @IBOutlet weak var tableView: UITableView!
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  friendsArr = NSMutableArray()
    var selctedFrndsArr = NSMutableArray()
    var totalFrndsArr = NSMutableArray()
    let frndsNamesArray = NSMutableArray()
    var groupId: NSInteger = 0
    var vcName: String = ""
    var isFromSMVC = Bool()
    var searchedResult = Bool()
    var searchStr: String!
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var membersCount: Int = 0
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    var isEditReply = Bool()
    @IBOutlet weak var submitBtn_BottomConst: NSLayoutConstraint!
    var searchBar = UISearchBar()
    var frndsNamesArray2 = [String]()
    var  friendsArr2 = NSMutableArray()
    var  friendsArr3 = NSMutableArray()
    var editReplayGameId: NSNumber = 0
    let notificationsBtn = BadgedButtonItem(with: UIImage(named: "mini-bell"))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SELECT PLAYERS"
        
        //  tableView.tableFooterView = submitView
        // tableView.register(UINib(nibName: "SelectFrndTVCell", bundle: nil), forCellReuseIdentifier: "SelectFrndTVCell")
        //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ Guest", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addGuestBtnTapped))
        // let customFont = UIFont(name: "customFontName", size: 17.0)!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search_white"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchBtnTapped))
        
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!], for: .normal)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        print(editReplayGameId)
        for (index, item) in totalFrndsArr.enumerated() {
            print("Found \(item) at position \(index)")
            let dict = item as? NSDictionary
            frndsNamesArray.add(dict?["FirstName"] ?? "")
           // friendsArr3.add(dict)
        }
        subscribeToShowKeyboardNotifications()
        self.navigationItem.rightBarButtonItem = notificationsBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getFriendsDetailsWS(userId: userId)
//        if UserDefaults.standard.object(forKey: "Guest Data") != nil {
//        let outData = UserDefaults.standard.data(forKey: "Guest Data")
//        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
//        let dictGuest = NSMutableDictionary()
//        dictGuest["FirstName"] = dict["FirstName"]
//        dictGuest["CustomerId"] = dict["CustomerId"]
//        self.totalFrndsArr.add(dictGuest)
//           UserDefaults.standard.removeObject(forKey: "Guest Data")
//           UserDefaults.standard.synchronize()
//        }
        self.getunReadNotificationsCount()
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
                if count ?? 0 != 0 {
                    DispatchQueue.main.async {
                    self.notificationsBtn.setBadge(with: count!)
                    }
                }
            //}
            
            
        }
    }
    @objc func searchBtnTapped() {
        self.navigationItem.rightBarButtonItem = nil
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search..."
        searchBar.becomeFirstResponder()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        //self.navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        let string:String = searchText
        if string.isEmpty
        {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    if string.count > 0 {
                       let string2 = string.replacingOccurrences(of: ConstantsString.InvisibleSign, with: "")
                        if string2.count == 1 {
                            //last visible character, if needed u can skip replacement and detect once even in empty text field
                            //for example u can switch to prev textField
                            //do stuff here
                            print(string2)
                            searchStr = ""
                        }else {
                            searchStr = string2
                        }
                        // self.friendsArr.removeAllObjects()
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            
                            self.getSearchResultWS(searchText: searchStr)
                        }else {
                            self.getSearchResultWS(searchText: searchStr)
                        }
                    }
                }
            }
        }else {
            self.friendsArr.removeAllObjects()
            //   searchedResult = true
            searchStr = string
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(searchText: searchStr)
            }else {
                self.getSearchResultWS(searchText: searchStr)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        navigationItem.titleView = nil
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_search_white"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchBtnTapped))
        getFriendsDetailsWS(userId: userId)
        
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let frndDict  = self.friendsArr[indexPath.row] as! NSDictionary
        let sFCell = tableView.dequeueReusableCell(withIdentifier: "SelectFrndTVCell", for: indexPath) as! SelectFrndTVCell
        
        
        sFCell.updateLabels(frndDict)
        let userId =  frndDict["UserId"] as? String ?? ""
        
        sFCell.addFrnd_switch.tag = 200 + indexPath.row
        sFCell.addFrnd_switch.isOn = false
        
//                let isSelected:Bool =  frndDict["IsSelected"] as? Bool ?? false
//                if isSelected {
//                   // sFCell.addFrnd_switch.isOn = true
//                }
        
        for (_, item) in self.totalFrndsArr.enumerated() {
            let dict = item as! NSDictionary
            print(dict)
            print(userId)
            var custId : String = ""
            if let customerId = dict["CustomerId"] {
                custId = String(describing: customerId)
            }
            //  print("user id's : \(userId) = \(custId)")
            if custId == userId {
                sFCell.addFrnd_switch.isOn = true
                break
            }
        }
        sFCell.addFrnd_switch.addTarget(self, action: #selector(switchChanged), for:UIControl.Event.valueChanged)
        // sFCell.addBtn.addTarget(self, action: #selector(addBtnTapped(_:)), for: .touchUpInside)
        sFCell.addFrnd_switch.tag = indexPath.row
        return sFCell
    }
    
    //MARK: - Button Action Methods
    @objc func switchChanged(mySwitch: UISwitch) {
        
        let frndDict  = self.friendsArr[mySwitch.tag] as! NSDictionary
        let userID =  (frndDict["UserId"] as? String ?? "")
        
        if mySwitch.isOn == true {
            if isEditReply == true {
                if vcName == "Groupdetails" {
                    self.addGroupMemberWS(userId: NSInteger(userID)!, groupId: groupId)
                }else {
                    if self.frndsNamesArray.count < 5 {
                        
                        let firstName =  (frndDict["FirstName"] as? String ?? "")
                        let lastName = (frndDict["LastName"] as? String ?? "")
                        let userID = (frndDict["UserId"] as? String ?? "")
                        
                        self.frndsNamesArray.add(firstName)
                        
                        var nameStr: String = ""
                        if lastName != "" {
                            nameStr = firstName + " " + lastName
                        }else {
                            nameStr = firstName
                        }
                        
                        self.friendsArr.removeObject(at: mySwitch.tag)
                        self.friendsArr.insert(frndDict, at: 0)
                        self.friendsArr2.add(frndDict)
                        let sortedArray = (self.friendsArr2 as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                        for (index, item) in sortedArray.enumerated() {
                            let dict = item as? NSDictionary
                            //dict.setValue(true, forKey: "IsSelected")
                            self.friendsArr.removeObject(at: index)
                            self.friendsArr.insert(item, at: index)
                        }
                        
                        let dictFrnd = NSMutableDictionary()
                        dictFrnd["name"] = nameStr
                        dictFrnd["userId"] = userID
                        
                        let dict = NSMutableDictionary()
                        dict["FirstName"] = nameStr
                        dict["CustomerId"] = userID
                        self.totalFrndsArr.add(dict)
                        
                        if self.delegate != nil && nameStr != "" {
                            if self.isFromSMVC == true {
                                self.delegate?.sendDataToCreteGroupVC(dict: frndDict)
                            }else {
                                self.delegate?.sendDataToCreteGroupVC(dict: dictFrnd)
                            }
                            if self.frndsNamesArray.count <= 5 {
                               // if self.frndsNamesArray.count == 4 || self.frndsNamesArray.count == 5 {
                                  self.showToast(message: "\(self.frndsNamesArray.count + self.membersCount) Players", font: .systemFont(ofSize: 20.0))
                               // }
                                self.tableView.reloadData()
                            }
                        }
                    }else {
                        self.errorAlert("Only 5 players are allowed in a game")
                       // self.showToast(message: "Only 5 players are allowed in a game", font: .systemFont(ofSize: 20.0))
                        self.tableView.reloadData()
                    }
                }
            }else {
                if vcName == "Groupdetails" {
                    self.addGroupMemberWS(userId: NSInteger(userID)!, groupId: groupId)
                }else {
                   // self.totalFrndsArr.removeAllObjects()
                    if (self.frndsNamesArray.count) < 5 {
                        
                        let firstName =  (frndDict["FirstName"] as? String ?? "")
                        let lastName = (frndDict["LastName"] as? String ?? "")
                        let userID = (frndDict["UserId"] as? String ?? "")
                        
                        self.frndsNamesArray.add(firstName)
                        
                        self.friendsArr.removeObject(at: mySwitch.tag)
                        self.friendsArr.insert(frndDict, at: 0)
                        self.friendsArr2.add(frndDict)
                        let sortedArray = (self.friendsArr2 as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                        for (index, item) in sortedArray.enumerated() {
                            self.friendsArr.removeObject(at: index)
                            self.friendsArr.insert(item, at: index)
                        }
                       // self.friendsArr2.removeAllObjects()
                        
                        var nameStr: String = ""
                        if lastName != "" {
                            nameStr = firstName + " " + lastName
                        }else {
                            nameStr = firstName
                        }
                        
                        let dictFrnd = NSMutableDictionary()
                        dictFrnd["name"] = nameStr
                        dictFrnd["userId"] = userID
                        
                        let dict = NSMutableDictionary()
                        dict["FirstName"] = nameStr
                        dict["CustomerId"] = userID
                        // self.totalFrndsArr.add(dict)
                        
                        /*  //Commented due to crash on 20/10/2020
                         for (_, item) in self.totalFrndsArr.enumerated() {
                         let dict2 = item as? NSDictionary
                         let firstName2 =  (dict2!["FirstName"] as? String ?? "")
                         if firstName2 == nameStr {
                         self.totalFrndsArr.remove(dict)
                         }else{
                         self.totalFrndsArr.add(dict)
                         }
                         }
                         */
                        self.totalFrndsArr.add(dict) //added this line for selected player switch green on 20/10/2020
                        
                        
                        if self.delegate != nil && nameStr != "" {
                            if self.isFromSMVC == true {
                                self.delegate?.sendDataToCreteGroupVC(dict: frndDict)
                            }else {
                                self.delegate?.sendDataToCreteGroupVC(dict: dictFrnd)
                            }
                            if (self.frndsNamesArray.count) <= 5 {
                               // if self.frndsNamesArray.count == 4 || self.frndsNamesArray.count == 5 {
                                    self.showToast(message: "\(self.frndsNamesArray.count + self.membersCount) Players", font: .systemFont(ofSize: 20.0))
                              //  }
                                self.tableView.reloadData()
                            }
                        }
                    }else {
                        self.errorAlert("Only 5 players are allowed in a game")
                       //  self.showToast(message: "Only 5 players are allowed in a game", font: .systemFont(ofSize: 20.0))
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            if vcName == "Groupdetails" {
                self.addGroupMemberWS(userId: NSInteger(userID)!, groupId: groupId)
            }else {
                let frndDict2  = self.friendsArr[mySwitch.tag] as! NSDictionary
                let userID2 =  (frndDict2["UserId"] as? String ?? "")
                for (index, item) in self.totalFrndsArr.enumerated() {
                    let dict = item as! NSDictionary
                    var custId : String = ""
                    if let customerId = dict["CustomerId"] {
                        custId = String(describing: customerId)
                    }
                    if custId == String(userID) {
                        //self.totalFrndsArr.removeObject(at: index)
                         self.totalFrndsArr.remove(item)
                        if self.frndsNamesArray.count > index {
                            self.frndsNamesArray.removeObject(at: index)
                        }
                        break
                    }
                }
                
                 self.friendsArr.remove(frndDict)
                self.friendsArr.add(frndDict)
//                self.friendsArr.removeObject(at: mySwitch.tag)
//                self.friendsArr.insert(frndDict, at: 0)
                let sortedArray = (self.friendsArr as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                for (index, item) in sortedArray.enumerated() {
                    //dict.setValue(true, forKey: "IsSelected")
                    // self.friendsArr.removeObject(at: index)
                    self.friendsArr.remove(item)
                    self.friendsArr.insert(item, at: index)
                }
                
                self.friendsArr2.remove(frndDict)
                if self.friendsArr2.count > 0 {
                    let sortedArray = (self.friendsArr2 as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                    for (index, item) in sortedArray.enumerated() {
                        //dict.setValue(true, forKey: "IsSelected")
                       // self.friendsArr.removeObject(at: index)
                        self.friendsArr.remove(item)
                        self.friendsArr.insert(item, at: index)
                    }
                } else {
                    let sortedArray = (self.friendsArr as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                    for (index, item) in sortedArray.enumerated() {
                        let dict = item as? NSDictionary
                        //dict.setValue(true, forKey: "IsSelected")
                        self.friendsArr.removeObject(at: index)
                        self.friendsArr.insert(item, at: index)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        submitBtn_BottomConst.constant = 20
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addGuestBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addGVCObj = storyboard.instantiateViewController(withIdentifier: "AddGuestVC") as! AddGuestVC
        self.navigationController?.pushViewController(addGVCObj, animated: true)
    }
    
    @objc func addGuestBtnTapped() {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addGVCObj = storyboard.instantiateViewController(withIdentifier: "AddGuestVC") as! AddGuestVC
        self.navigationController?.pushViewController(addGVCObj, animated: true)
    }
    
    //MARK: - Web Service Methods
    func getFriendsDetailsWS(userId: NSInteger) {
        
        //let urlString :  String =  MyStrings().getFriendDetailsUrl + "\(userId) \(editReplayGameId)"
        let urlString :  String = MyStrings().getFriendDetailsUrl + "?UserId=\(userId)"// + "&GameId=\(editReplayGameId)"
        //+ "?UserId="+userId+"&GameId="+editReplayGameId)
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
                
                self.friendsArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                // self.totalFrndsArr.removeAllObjects()
                if UserDefaults.standard.object(forKey: "Guest Data") != nil {
                    let outData = UserDefaults.standard.data(forKey: "Guest Data")
                    let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
                    let dictGuest = NSMutableDictionary()
                    dictGuest["FirstName"] = dict["FirstName"]
                    dictGuest["CustomerId"] = dict["CustomerId"]
                     self.totalFrndsArr.add(dictGuest)
                //    self.frndsNamesArray.removeAllObjects()
//                    for (index, item) in self.totalFrndsArr.enumerated() {
//                        print("Found \(item) at position \(index)")
//                        let dict = item as? NSDictionary
//                        self.frndsNamesArray.add(dict?["FirstName"] ?? "")
//                       // friendsArr3.add(dict)
//                    }
                    
                    
                   // self.frndsNamesArray.add(dictGuest["FirstName"] as! String)
                    UserDefaults.standard.removeObject(forKey: "Guest Data")
                    UserDefaults.standard.synchronize()
                    let frndDict  = self.friendsArr[0] as! NSDictionary
                    if self.frndsNamesArray.count < 5 {
                        let firstName =  (frndDict["FirstName"] as? String ?? "")
                        let lastName = (frndDict["LastName"] as? String ?? "")
                        let userID = (frndDict["UserId"] as? String ?? "")
                        
                        self.frndsNamesArray.add(firstName)
                        
                        var nameStr: String = ""
                        if lastName != "" {
                            nameStr = firstName + " " + lastName
                        }else {
                            nameStr = firstName
                        }
                        
                        let dictFrnd = NSMutableDictionary()
                        dictFrnd["name"] = nameStr
                        dictFrnd["userId"] = userID
                        
                        let dict2 = NSMutableDictionary()
                        dict2["FirstName"] = nameStr
                        dict2["CustomerId"] = userID
                       self.totalFrndsArr.add(dict2)
                        
                        if self.isFromSMVC == true {
                            self.delegate?.sendDataToCreteGroupVC(dict: frndDict)
                        }else {
                            self.delegate?.sendDataToCreteGroupVC(dict: dictFrnd)
                        }
                        if self.frndsNamesArray.count <= 5 {
                            //self.errorAlert("\(self.frndsNamesArray.count + self.membersCount) Players")
                            self.showToast(message: "\(self.frndsNamesArray.count + self.membersCount) Players", font: .systemFont(ofSize: 12.0))
                            self.tableView.reloadData()
                        }
                    }else {
                        self.errorAlert("Only 5 players are allowed in a game")
                        // self.showToast(message: "Only 5 players are allowed in a game", font: .systemFont(ofSize: 20.0))
                    }
                    
                }
                let selFrndSequenseArr = NSMutableArray()
                for (_, item) in self.friendsArr.enumerated() {
                    
                    let frndDict  = item as! NSDictionary
                    let userId =  frndDict["UserId"] as? String ?? ""
                    for (_, item2) in self.totalFrndsArr.enumerated() {
                        let dict = item2 as! NSDictionary
                        print(dict)
                        print(userId)
                        var custId : String = ""
                        if let customerId = dict["CustomerId"] {
                            custId = String(describing: customerId)
                        }
                        //  print("user id's : \(userId) = \(custId)")
                        if custId == userId {
                            selFrndSequenseArr.insert(item, at: 0)
                            self.friendsArr2.add(frndDict)  //Added by sudhakar on 10/21/20
                            break
                        }
                    }
                }
                for (_, item3) in selFrndSequenseArr.enumerated() {
                    for (_, item4) in self.friendsArr.enumerated() {
                        if item3 as! NSDictionary == item4 as! NSDictionary {
                            self.friendsArr.remove(item4)
                        }
                    }
                    self.friendsArr.insert(item3, at: 0)
                }
                
                print(self.friendsArr2.count)
                
                //                let sortedArray = (self.friendsArr as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                //                for (index, item) in sortedArray.enumerated() {
                //                    self.friendsArr.removeObject(at: index)
                //                    self.friendsArr.insert(item, at: index)
                //                }
                
                //                for (_, item) in self.friendsArr3.enumerated() {
                //
                //                    let frndDict  = item as! NSDictionary
                //                    let userId =  frndDict["FirstName"] as? String ?? ""
                //                    for (_, item2) in self.friendsArr.enumerated() {
                //                        let dict = item2 as! NSDictionary
                //                        print(dict)
                //                        print(userId)
                //                        var custId : String = ""
                //                        if let customerId = dict["FirstName"] {
                //                            custId = String(describing: customerId)
                //                        }
                //                        if custId == userId {
                //                            self.friendsArr2.insert(dict, at: 0)
                //                            break
                //                        }
                //                    }
                //                }
                //
                //                let sortedArray2 = (self.friendsArr2 as NSArray).sortedArray(using: [NSSortDescriptor(key: "FirstName", ascending: true)]) as! [[String:AnyObject]]
                //                for (index, item) in sortedArray2.enumerated() {
                //                    self.friendsArr.removeObject(at: index)
                //                    self.friendsArr.insert(item, at: index)
                //                }
                
                self.tableView.reloadData()
                
            }else {
                self.friendsArr.removeAllObjects()
                self.tableView.reloadData()
            }
        }
        
    }
    
    func addGroupMemberWS(userId: NSInteger, groupId: NSInteger) {
        let urlString :  String =  MyStrings().addGroupMemberUrl + "\(groupId)" + "&UserId=" + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }else {
                self.errorAlert("Unable to add to group")
                //  self.show(message: "Unable to add to group", controller: self)
            }
        }
    }
    
    func getSearchResultWS(searchText: String) {
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$-,/?%#[] ").inverted)
        let formattedString = searchText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        let urlString :  String =  MyStrings().getSerachResultUrl + "\(userId)" + "&term=" + "\(formattedString)"
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
                
                if dict != nil {
                    self.friendsArr.removeAllObjects()
                    self.friendsArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                }
                
                let selFrndSequenseArr = NSMutableArray()
                for (_, item) in self.friendsArr.enumerated() {
                    
                    let frndDict  = item as! NSDictionary
                    let userId =  frndDict["UserId"] as? String ?? ""
                    for (_, item2) in self.totalFrndsArr.enumerated() {
                        let dict = item2 as! NSDictionary
                        print(dict)
                        print(userId)
                        var custId : String = ""
                        if let customerId = dict["CustomerId"] {
                            custId = String(describing: customerId)
                        }
                        //  print("user id's : \(userId) = \(custId)")
                        if custId == userId {
                            selFrndSequenseArr.insert(item, at: 0)
                            break
                        }
                    }
                }
                for (_, item3) in selFrndSequenseArr.enumerated() {
                    for (_, item4) in self.friendsArr.enumerated() {
                        if item3 as! NSDictionary == item4 as! NSDictionary {
                            self.friendsArr.remove(item4)
                        }
                    }
                    self.friendsArr.insert(item3, at: 0)
                }
                
                self.tableView.reloadData()
            }else {
                self.friendsArr.removeAllObjects()
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - TextFiled Delegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty
        {
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    if var string = textField.text {
                        string = string.replacingOccurrences(of: ConstantsString.InvisibleSign, with: "")
                        if string.count == 1 {
                            //last visible character, if needed u can skip replacement and detect once even in empty text field
                            //for example u can switch to prev textField
                            //do stuff here
                            print(string)
                            searchStr = ""
                        }else {
                            searchStr = string
                        }
                        // self.friendsArr.removeAllObjects()
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            
                            self.getSearchResultWS(searchText: searchStr)
                        }else {
                            self.getSearchResultWS(searchText: searchStr)
                        }
                    }
                }
            }
        }else {
            self.friendsArr.removeAllObjects()
            //   searchedResult = true
            searchStr = textField.text!+string
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(searchText: searchStr)
            }else {
                self.getSearchResultWS(searchText: searchStr)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //   searchedResult = true
        if textField.text != "" {
            textField.resignFirstResponder()
            searchStr = textField.text!
            if UIDevice.current.userInterfaceIdiom == .phone {
                //  self.getSearchResultWS(searchText: textField.text!, pageCount: 10, pageNo: 1)
                self.getSearchResultWS(searchText: searchStr)
            }else {
                self.getSearchResultWS(searchText: searchStr)
            }
            return true
        }else {
            getFriendsDetailsWS(userId: userId)
            textField.resignFirstResponder()
            return true
        }
    }
    //MARK: - Keyboard Notification Methods
    func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        submitBtn_BottomConst.constant = 20 + keyboardHeight
        
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        submitBtn_BottomConst.constant = 20
        
        let userInfo = notification.userInfo
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AddFriendVC {
    
    func showToast(message : String, font: UIFont) {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (message as NSString).size(withAttributes: fontAttributes)
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-180, width: 150, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 25;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
