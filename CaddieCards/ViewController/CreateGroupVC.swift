//
//  CreateGroupVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 28/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class CreateGroupVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MyDataSendingDelegateProtocol {
    
    
    @IBOutlet weak var tableView: UITableView!
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  groupMembersArr = NSMutableArray()
    @IBOutlet weak var groupNameTxtField: UITextField!
    @IBOutlet var lineLbl: UILabel!
    var dictToSave = [String: String]()
    var selctedFrndsArr = NSMutableArray()
    var isFromGroupVC = Bool()
    var frndDict = NSDictionary()
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "Create Group"
        lineLbl.backgroundColor = GlobalConstants.APPGREENCOLOR
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "GroupMembersTVCell", bundle: nil), forCellReuseIdentifier: "GroupMembersTVCell")
        tableView.register(UINib(nibName: "AddFrndGroupTVCell", bundle: nil), forCellReuseIdentifier: "AddFrndGroupTVCell")
        
        if isFromGroupVC == true {
            selctedFrndsArr.add(frndDict["UserId"] as Any)
            let firstName =  (frndDict["FirstName"] as? String ?? "")
            let lastName = (frndDict["LastName"] as? String ?? "")
            var nameStr: String = ""
            if lastName != "" {
                nameStr = firstName + " " + lastName
            }else {
                nameStr = firstName
            }
            groupMembersArr.add(nameStr)
            isFromGroupVC = false
        }
        
    }
    
    //MARK: - Delegate Method
    func sendDataToCreteGroupVC(dict: NSDictionary) {
         print(dict)
        selctedFrndsArr.add(dict["userId"] as Any)
        groupMembersArr.add(dict["name"] as Any)
        tableView.reloadData()
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupMembersArr.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < self.groupMembersArr.count {
            let gMCell = tableView.dequeueReusableCell(withIdentifier: "GroupMembersTVCell", for: indexPath) as! GroupMembersTVCell
            
            let numberGroup = indexPath.row + 1

            gMCell.GroupMemberCountLbl.text = "Group Member " + "\(numberGroup)" + " :"
          //  let groupMemberKey:String = "Member" + "\(numberGroup)"
          //  dictToSave[groupMemberKey] = self.selctedFrndsArr[indexPath.row] as? String ?? ""
            gMCell.updateLabels(self.groupMembersArr[indexPath.row] as? String ?? "")
            
            return gMCell
        }else {
            let addFCell = tableView.dequeueReusableCell(withIdentifier: "AddFrndGroupTVCell", for: indexPath) as! AddFrndGroupTVCell
            //This will be hidding and unhidding add friend button
            /*
            if self.groupMembersArr.count == 5 {
                addFCell.addFrndTop_LayoutConstraint.constant = 0
                addFCell.addFrndHeight_LayoutConstraint.constant = 0
                
            }else {
                addFCell.addFrndTop_LayoutConstraint.constant = 15
                addFCell.addFrndHeight_LayoutConstraint.constant = 40
                
                addFCell.addFriendBtn.addTarget(self, action: #selector(addFriendBtnTapped(_:)), for: .touchUpInside)
            }
 */
            addFCell.addFriendBtn.addTarget(self, action: #selector(addFriendBtnTapped(_:)), for: .touchUpInside)
            addFCell.submitBtn.addTarget(self, action: #selector(submitBtnTapped(_:)), for: .touchUpInside)
            return addFCell
        }
    }
    
    //MARK: - Button Action Methods
    
    @objc func addFriendBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGroupVCObj = storyboard.instantiateViewController(withIdentifier: "AddFriendVC") as! AddFriendVC
        cGroupVCObj.delegate = self
        cGroupVCObj.selctedFrndsArr = groupMembersArr
        self.navigationController?.pushViewController(cGroupVCObj, animated: true)
    }
    @objc func submitBtnTapped(_ sender: UIButton) {
        guard let groupName = self.groupNameTxtField.text, groupName.count > 0, groupName.whiteSpaceBeforeString(name: self.groupNameTxtField.text!) else {
            self.errorAlert("Please enter group name")
          //  self.show(message: "Please enter group name", controller: self)
            return
        }
    let membersStr =   self.selctedFrndsArr.componentsJoined(by: ",")
        if self.groupMembersArr.count > 0 {
            let params: Parameters = [
                "CustomerId": userId,
                "GroupName": groupName,
                "Members": membersStr,
                "GroupMembers":dictToSave
            ]
            print("Create Group Parameters = \(params)")
            
            self.startLoadingIndicator(loadTxt: "Loading...")
            ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().createGroupUrl, urlParams: params as [String : AnyObject]) { (response) in
                print(response as Any)
                
                if(response.isSuccess){
                    print("Create Group Responce = \(response.responseDictionary)")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            self.errorAlert("Please select atleast one group member")
          //  self.show(message: "Please select atleast one group member", controller: self)
        }
    }
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == groupNameTxtField {
            return newLength <= 25
        }
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        lineLbl.backgroundColor = GlobalConstants.APPGREENCOLOR
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
