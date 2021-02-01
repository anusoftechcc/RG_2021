//
//  GroupDetailsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 28/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GroupDetailsVC: BaseViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var groupName: String = ""
    var groupId: NSInteger = 0
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  groupDetailsArr = NSMutableArray()
    @IBOutlet weak var groupDetailsTV: UITableView!
    @IBOutlet var editGroupPopupView: UIView!
    @IBOutlet weak var editGroupDetailsView: UIView!
    @IBOutlet weak var editGroupNameTxtField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveGroupBtn: UIButton!
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = groupName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editBtnTapped))
        
        groupDetailsTV.tableFooterView = UIView()
        groupDetailsTV.register(UINib(nibName: "GroupDetailsTVCell", bundle: nil), forCellReuseIdentifier: "GroupDetailsTVCell")
        groupDetailsTV.register(UINib(nibName: "AddFriendTVCell", bundle: nil), forCellReuseIdentifier: "AddFriendTVCell")
        groupDetailsTV.register(UINib(nibName: "GroupYouTVCell", bundle: nil), forCellReuseIdentifier: "GroupYouTVCell")
        
        
        editGroupPopupView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        /*
         let navheight: CGFloat = self.navigationController!.navigationBar.frame.size.height
         let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
         let yAxis: CGFloat = navheight + statusBarHeight
         */
        editGroupPopupView.frame = CGRect.init(x: 0, y: 0, width: GlobalConstants.kScreen_width , height: GlobalConstants.kScreen_height)
        
        self.editGroupNameTxtField.delegate = self
        self.editGroupNameTxtField.setLeftPaddingPoints(5)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.editGroupNameTxtField.text = groupName
        getGroupDetailsWS(userId: userId, groupId: groupId)
    }
    override func viewDidLayoutSubviews() {
        self.editGroupDetailsView.layoutIfNeeded()
        let layer = self.editGroupDetailsView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.20
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.cornerRadius = 5.0
        
        self.editGroupNameTxtField.cornerRadius = 3.0
        self.editGroupNameTxtField.borderColor = UIColor.orange
        self.editGroupNameTxtField.borderWidth = 1.0
        self.editGroupNameTxtField.clipsToBounds = true
        
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupDetailsArr.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < self.groupDetailsArr.count {
            let groupFrndDict  = self.groupDetailsArr[indexPath.row] as! NSDictionary
            
            let userType =  (groupFrndDict["UserType"] as? String ?? "")
            if userType == "You" {
                let gYouCell = tableView.dequeueReusableCell(withIdentifier: "GroupYouTVCell", for: indexPath) as! GroupYouTVCell
                let firstName =  (groupFrndDict["FirstName"] as? String ?? "")
                gYouCell.nameLbl.text = firstName
                
                return gYouCell
            }else {
                let gFCell = tableView.dequeueReusableCell(withIdentifier: "GroupDetailsTVCell", for: indexPath) as! GroupDetailsTVCell
                
                gFCell.updateLabels(groupFrndDict)
                
                gFCell.messageBtn.addTarget(self, action: #selector(messageBtnTapped(_:)), for: .touchUpInside)
                gFCell.removeBtn.addTarget(self, action: #selector(removeBtnTapped(_:)), for: .touchUpInside)
                gFCell.addFrndBtn.addTarget(self, action: #selector(addFrndBtnTapped(_:)), for: .touchUpInside)
                
                return gFCell
            }
        }else {
            let addFCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendTVCell", for: indexPath) as! AddFriendTVCell
            
            addFCell.addFriendBtn.addTarget(self, action: #selector(addFriendBtnTapped(_:)), for: .touchUpInside)
            return addFCell
        }
    }
    
    //MARK: - Button Action Methods
    
    @objc func editBtnTapped() {
        // self.view.addSubview(self.editGroupPopupView)
        //  self.view.bringSubviewToFront(self.editGroupPopupView)
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self.editGroupPopupView)
    }
    @objc func messageBtnTapped(_ sender: UIButton) {
    }
    @objc func removeBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.groupDetailsTV)
        let indexPath = self.groupDetailsTV.indexPathForRow(at: buttonPosition)
        let groupDict  = self.groupDetailsArr[indexPath!.row] as! NSDictionary
        let groupUserId =  (groupDict["CustomerId"] as? String ?? "")
        let groupID =  (groupDict["GroupId"] as? String ?? "")
        
        self.deleteUserFromGroupWS(userID: NSInteger(groupUserId)!, groupID: NSInteger(groupID)!)
    }
    @objc func addFriendBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aFrndVCObj = storyboard.instantiateViewController(withIdentifier: "AddFriendVC") as! AddFriendVC
        aFrndVCObj.groupId = groupId
        aFrndVCObj.vcName = "Groupdetails"
        aFrndVCObj.selctedFrndsArr = groupDetailsArr
        self.navigationController?.pushViewController(aFrndVCObj, animated: true)
    }
    @IBAction func saveGroupBtnTapped(_ sender: Any) {
        
        guard let groupName = self.editGroupNameTxtField.text, groupName.count > 0, groupName.whiteSpaceBeforeString(name: self.editGroupNameTxtField.text!) else {
            self.errorAlert("Please enter group name")
          //  self.show(message: "Please enter group name", controller: self)
            return
        }
        
        let params: Parameters = [
            "GroupId": groupId,
            "GroupName": groupName
        ]
        print("Edit Group Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().editGroupNameByGroupIdUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                print("Edit Group Responce = \(response.responseDictionary)")
                self.editGroupPopupView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func cancelGroupPopupBtnTapped(_ sender: Any) {
        self.self.editGroupPopupView.removeFromSuperview()
    }
    @objc func addFrndBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.groupDetailsTV)
        let indexPath = self.groupDetailsTV.indexPathForRow(at: buttonPosition)
        let groupDict  = self.groupDetailsArr[indexPath!.row] as! NSDictionary
        let frndId =  (groupDict["CustomerId"] as? String ?? "")
        //addFriendWithOutReqUrl
        self.addFrndWithOutReqWS(userID: String(userId), friendID: frndId, purpose: "Add")
    }
    
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == self.editGroupNameTxtField {
            return newLength <= 25
        }
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
                self.groupDetailsTV.reloadData()
            }else {
                self.groupDetailsArr.removeAllObjects()
                self.groupDetailsTV.reloadData()
            }
        }
    }
    func  deleteUserFromGroupWS(userID : NSInteger, groupID: NSInteger) {
        //Modified by andy dev 04302019
        //Replaced deleteGroupUrl with getDeleteUserFromGroupUrl
        let urlString :  String =  MyStrings().getDeleteUserFromGroupUrl + "\(userID)" + "&GroupId=" + "\(groupID)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                self.getGroupDetailsWS(userId: self.userId, groupId: self.groupId)
            }else {
                self.errorAlert("Unable to delete user from this group,try gain")
              //  self.show(message: "Unable to delete user from this group,try gain", controller: self)
            }
        }
    }
    func addFrndWithOutReqWS(userID: String, friendID: String,  purpose: String) {
        let params: Parameters = [
            "UserId": userID,
            "FriendId": friendID,
            "Purpose": purpose
        ]
        print("Add Friend in Group Details Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().addFriendWithOutReqUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                print("Edit Group Responce = \(response.responseDictionary)")
                self.editGroupPopupView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
