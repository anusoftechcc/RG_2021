//
//  FriendsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class FriendsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tabBtnsList: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    var friendsSel = Bool()
    var requestsSel = Bool()
    var groupsSel = Bool()
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    // var castDataArray = [FriendsModel]()
    var  friendsListArr = NSMutableArray()
    var refreshControl = UIRefreshControl()
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "FRIENDS"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "person_add_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(searchBtnTapped))
        for btn in tabBtnsList
        {
            btn.setTitleColor(.white, for: .normal)
        }
        tabBtnsList[0].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FriendsTVCell", bundle: nil), forCellReuseIdentifier: "FriendsTVCell")
        tableView.register(UINib(nibName: "RequestTVCell", bundle: nil), forCellReuseIdentifier: "RequestTVCell")
        tableView.register(UINib(nibName: "GroupTVCell", bundle: nil), forCellReuseIdentifier: "GroupTVCell")
        tableView.register(UINib(nibName: "CreateGroupTVCell", bundle: nil), forCellReuseIdentifier: "CreateGroupTVCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        friendsSel = true
        requestsSel = false
        groupsSel  = false
        self.getFriendsDetailsWS(userId: userId)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        if self.friendsSel == true {
            self.getFriendsDetailsWS(userId: self.userId)
        }else if self.requestsSel == true {
            self.getFriendsRequestsWS(userId: self.userId)
        }else {
            self.getGroupsWS(userId: self.userId)
        }
    }
    
    //MARK: - Button Action Methods
    
    @objc func searchBtnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactVCObj = storyboard.instantiateViewController(withIdentifier: "SearchFriendsVC") as! SearchFriendsVC
        self.navigationController?.pushViewController(contactVCObj, animated: true)
    }
    
    @IBAction func FriendsBtnTapped(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
        for btn in tabBtnsList
        {
            btn.setTitleColor(.white, for: .normal)
        }
        tabBtnsList[0].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
        friendsSel = true
        requestsSel = false
        groupsSel  = false
        self.getFriendsDetailsWS(userId: userId)
    }
    @IBAction func RequestsBtnTapped(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
        for btn in tabBtnsList
        {
            btn.setTitleColor(.white, for: .normal)
        }
        tabBtnsList[1].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
        friendsSel = false
        requestsSel = true
        groupsSel  = false
        //Added by andy dev 04292019
        friendsListArr.removeAllObjects()
        self.getFriendsRequestsWS(userId: userId)
    }
    @IBAction func GroupsBtnTapped(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
        for btn in tabBtnsList
        {
            btn.setTitleColor(.white, for: .normal)
        }
        tabBtnsList[2].setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
        friendsSel = false
        requestsSel = false
        groupsSel  = true
        self.getGroupsWS(userId: userId)
    }
    @objc func refresh(sender: Any) {
        if self.friendsSel == true {
            self.getFriendsDetailsWS(userId: self.userId)
        }else if self.requestsSel == true {
            self.getFriendsRequestsWS(userId: self.userId)
        }else {
            self.getGroupsWS(userId: self.userId)
        }
    }
    
    //MARK: - Alert Controller
    func showSimpleAlert(userId : NSInteger, groupId: String) {
        let alert = UIAlertController(title: "Alert", message: "Delete this group?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.deleteGroupWS(userId: userId, groupId: groupId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Friends Action Methods
    @objc func gameInviteBtnTapped(_ sender: UIButton) {
    }
    @objc func messageBtnTapped(_ sender: UIButton) {
    }
    @objc func groupBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let dict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gVCObj = storyboard.instantiateViewController(withIdentifier: "GroupVC") as! GroupVC
        gVCObj.frndDict = dict
        self.navigationController?.pushViewController(gVCObj, animated: true)
    }
    @objc func deleteBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let friendDict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        let friendId =  (friendDict["UserId"] as? String ?? "")
        self.addOrConfirmOrDeleteFriendWS(purpose: "delete", frndId: friendId)
    }
    //MARK: - Requests Action Methods
    @objc func acceptBtnTapped(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        print(String(describing: buttonTitle))
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let friendDict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        let friendId =  (friendDict["UserId"] as? String ?? "")
        
        if buttonTitle == "Remind" {
            self.errorAlert("Latter will send you notifications")
           // self.show(message: "Latter will send you notifications", controller: self)
        }else {
            self.addOrConfirmOrDeleteFriendWS(purpose: "confirm", frndId: friendId)
        }
    }
    @objc func deleteReqBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let friendDict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        let friendId =  (friendDict["UserId"] as? String ?? "")
        self.addOrConfirmOrDeleteFriendWS(purpose: "cancel", frndId: friendId)
    }
    //MARK: - Group Action Methods
    @objc func createGroupBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGroupVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        self.navigationController?.pushViewController(cGroupVCObj, animated: true)
    }
    @objc func gameInviteGroupBtnTapped(_ sender: UIButton) {
    }
    @objc func messageGroupBtnTapped(_ sender: UIButton) {
    }
    @objc func deleteGroupBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let groupDict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        //Modified by andy dev 04292019
        // let groupID =  (groupDict["UserId"] as? NSInteger)
        let groupID =  (groupDict["GroupId"] as? String)
        
        //Added by andy dev 04292019
        if groupID != nil {
            //  self.deleteGroupWS(userId: userId, groupId: groupID!)
            self.showSimpleAlert(userId: userId, groupId: groupID!)
        }
    }
    @objc func groupNameNavBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let groupDict  = self.friendsListArr[indexPath!.row] as! NSDictionary
        let groupName =  (groupDict["GroupName"] as? String ?? "")
        let groupID =  (groupDict["GroupId"] as? String ?? "")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gDetailsVCObj = storyboard.instantiateViewController(withIdentifier: "GroupDetailsVC") as! GroupDetailsVC
        gDetailsVCObj.groupName = groupName
        gDetailsVCObj.groupId = NSInteger(groupID)!
        self.navigationController?.pushViewController(gDetailsVCObj, animated: true)
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if friendsSel == true {
            return 1
        }else if requestsSel == true {
            return 1
        }else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendsSel == true {
            return self.friendsListArr.count
        }else if requestsSel == true {
            return self.friendsListArr.count
        }else {
            if section == 0 {
                return 1
            }
            return self.friendsListArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if friendsSel == true {
            let friendDict  = self.friendsListArr[indexPath.row]
            let fCell = tableView.dequeueReusableCell(withIdentifier: "FriendsTVCell", for: indexPath) as! FriendsTVCell
            
            fCell.updateLabels(friendDict as! NSDictionary)
            
            fCell.gameInviteBtn.addTarget(self, action: #selector(gameInviteBtnTapped(_:)), for: .touchUpInside)
            fCell.messageBtn.addTarget(self, action: #selector(messageBtnTapped(_:)), for: .touchUpInside)
            fCell.groupBtn.addTarget(self, action: #selector(groupBtnTapped(_:)), for: .touchUpInside)
            fCell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(_:)), for: .touchUpInside)
            
            return fCell
        }else if requestsSel == true {
            let friendDict  = self.friendsListArr[indexPath.row]
            let rCell = tableView.dequeueReusableCell(withIdentifier: "RequestTVCell", for: indexPath) as! RequestTVCell
            
            rCell.updateLabels(friendDict as! NSDictionary)
            
            rCell.acceptBtn.addTarget(self, action: #selector(acceptBtnTapped(_:)), for: .touchUpInside)
            rCell.deleteBtn.addTarget(self, action: #selector(deleteReqBtnTapped(_:)), for: .touchUpInside)
            
            return rCell
        }else {
            if indexPath.section == 0 {
                let cgCell = tableView.dequeueReusableCell(withIdentifier: "CreateGroupTVCell", for: indexPath) as! CreateGroupTVCell
                cgCell.createGroupBtn.addTarget(self, action: #selector(createGroupBtnTapped(_:)), for: .touchUpInside)
                
                return cgCell
            }else {
                let groupDict  = self.friendsListArr[indexPath.row]
                let gCell = tableView.dequeueReusableCell(withIdentifier: "GroupTVCell", for: indexPath) as! GroupTVCell
                
                gCell.updateLabels(groupDict as! NSDictionary)
                gCell.groupNavBtn.addTarget(self, action: #selector(groupNameNavBtnTapped(_:)), for: .touchUpInside)
                gCell.gameInviteBtn.addTarget(self, action: #selector(gameInviteGroupBtnTapped(_:)), for: .touchUpInside)
                gCell.messageBtn.addTarget(self, action: #selector(messageGroupBtnTapped(_:)), for: .touchUpInside)
                gCell.deleteGroupBtn.addTarget(self, action: #selector(deleteGroupBtnTapped(_:)), for: .touchUpInside)
                
                return gCell
            }
        }
    }
    
    //MARK: - Web Service Methods
    func getFriendsDetailsWS(userId: NSInteger) {
        
        
        //let urlString :  String =  MyStrings().getFriendDetailsUrl + "\(userId)"
        let urlString :  String = MyStrings().getFriendDetailsUrl + "?UserId=\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                print(response as Any)
                self.refreshControl.endRefreshing()
                
                let isError = response.isSuccess
                print(isError)
                guard isError == true else {
                    let message = response.responseDictionary["ErrorMessage"] as? String
                    print(message as Any)
                   self.errorAlert(message!)
                 //   self.show(message: message!, controller: self)
                    return
                }
                print(response.responseDictionary)
                let dict = response.customModel
                
                self.friendsListArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                
                let jsonData = try! JSONSerialization.data(withJSONObject: response.customModel, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                let friends = Mapper<FriendsModel>().map(JSONString: jsonString)
                print(friends?.firstName ?? "")
                
                self.tableView.reloadData()
                
            }else {
                self.friendsListArr.removeAllObjects()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        //    ApiCall.postCall(url: urlString, httpMethod: .get, loading: self) { (response, error) in
        //        let castData = WebCastModel(JSONString: response!)
        //        print(WebCastModel(JSONString: response!) as Any)
        //        self.castDataArray = (castData?.success)! as! [FriendsModel]
        //        }
    }
    func getFriendsRequestsWS(userId: NSInteger) {
        let urlString :  String =  MyStrings().getFriendRequestsUrl + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                print(response as Any)
                self.refreshControl.endRefreshing()
                
                let isError = response.isSuccess
                print(isError)
                guard isError == true else {
                    let message = response.responseDictionary["ErrorMessage"] as? String
                    print(message as Any)
                    self.errorAlert(message!)
                   // self.show(message: message!, controller: self)
                    return
                }
                print(response.responseDictionary)
                let dict = response.customModel
                
                self.friendsListArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
            }else {
                self.friendsListArr.removeAllObjects()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    func  addOrConfirmOrDeleteFriendWS(purpose : String, frndId: String) {
        // let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        
        let params: Parameters = [
            "UserId": String(userId),
            "FriendId": frndId,
            "Purpose": purpose
        ]
        print("addOrConfirmOrDeleteFriend Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().addOrConfirmOrDeleteFriendUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                if self.friendsSel == true {
                    self.getFriendsDetailsWS(userId: self.userId)
                }else if self.requestsSel == true {
                    self.getFriendsRequestsWS(userId: self.userId)
                }else {
                }
                /*
                 let message = response.responseDictionary["ErrorMessage"] as? String
                 print(message as Any)
                 let isError = response.responseDictionary["IsError"] as! Bool
                 print(isError)
                 guard isError == false else {
                 self.errorAlert(message!)
                 return
                 }
                 print("addOrConfirmOrDeleteFriend Responce = \(response.responseDictionary)")
                 */
            }else {
                self.errorAlert("something went wrong, try again")
              //  self.show(message: "something went wrong, try again", controller: self)
            }
            
        }
    }
    func getGroupsWS(userId: NSInteger) {
        let urlString :  String =  MyStrings().getGroupsUrl + "\(userId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                print(response as Any)
                self.refreshControl.endRefreshing()
                
                let isError = response.isSuccess
                print(isError)
                guard isError == true else {
                    let message = response.responseDictionary["ErrorMessage"] as? String
                    print(message as Any)
                    self.errorAlert(message!)
                  //  self.show(message: message!, controller: self)
                    return
                }
                print(response.responseDictionary)
                let dict = response.customModel
                
                self.friendsListArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
            }else {
                self.friendsListArr.removeAllObjects()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    func  deleteGroupWS(userId : NSInteger, groupId: String) {
        let urlString :  String =  MyStrings().deleteGroupUrl + "\(userId)" + "&GroupId=" + "\(groupId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                self.getGroupsWS(userId: userId)
            }else {
                self.errorAlert("Unable to delete this group,try gain")
               // self.show(message: "Unable to delete this group,try gain", controller: self)
            }
        }
    }
}
