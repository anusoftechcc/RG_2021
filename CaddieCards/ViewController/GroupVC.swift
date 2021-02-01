//
//  GroupVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/06/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GroupVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var createGroupBtn: UIButton!
    @IBOutlet weak var groupsTV: UITableView!
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  groupsArr = NSMutableArray()
    var frndDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "SELECT GROUP"
        
        groupsTV.tableFooterView = UIView()
        groupsTV.register(UINib(nibName: "SelectGroupTVCell", bundle: nil), forCellReuseIdentifier: "SelectGroupTVCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getGroupDetailsWS()
    }
    //MARK: - Button Action Methods
    
    @IBAction func createNewGroupBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cgVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        cgVCObj.frndDict = frndDict
        cgVCObj.isFromGroupVC = true
        self.navigationController?.pushViewController(cgVCObj, animated: true)
    }
    @objc func addGroupBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.groupsTV)
        let indexPath = self.groupsTV.indexPathForRow(at: buttonPosition)
        let dict  = self.groupsArr[indexPath!.row] as! NSDictionary
        let grpId =  (dict["GroupId"] as? String ?? "")
        let friendId =  (frndDict["UserId"] as? String ?? "")
        
        addFrinedToGroupDirect(friendID: friendId, groupID: grpId)
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let groupDict  = self.groupsArr[indexPath.row]
        let groupCell = tableView.dequeueReusableCell(withIdentifier: "SelectGroupTVCell", for: indexPath) as! SelectGroupTVCell
        
        groupCell.updateLabels(groupDict as! NSDictionary)
        
        groupCell.addGroupBtn.addTarget(self, action: #selector(addGroupBtnTapped(_:)), for: .touchUpInside)
        
        return groupCell
    }
    // MARK: - Web Service Methods
    
    func getGroupDetailsWS() {
        let friendId =  (frndDict["UserId"] as? String ?? "")
        let urlString :  String =  MyStrings().getGroupDataListUrl + "\(friendId)" + "&UserId=" + "\(userId)"
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
                
                self.groupsArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                self.groupsTV.reloadData()
            }else {
                self.groupsArr.removeAllObjects()
                self.groupsTV.reloadData()
            }
        }
    }
    func  addFrinedToGroupDirect(friendID: String, groupID: String) {
        
        let params: Parameters = [
            "UserId": userId,
            "FriendId": friendID,
            "GroupId": groupID
        ]
        print("add Frined To Group Direct Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().addFrndGroupDirectUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
