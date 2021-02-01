//
//  SearchFriendsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 19/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SearchFriendsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{
    
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  searchResultArr = NSMutableArray()
    @IBOutlet weak var searchFrndTV: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchCancelBtn: UIButton!
    @IBOutlet weak var searchTxtFiled: UITextField!
    var searchedResult = Bool()
    var searchStr: String!
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        //Registering nib classes
        searchFrndTV.delegate = self
        searchFrndTV.dataSource = self
        searchFrndTV.isScrollEnabled  = true
        searchFrndTV.tableFooterView = UIView()
        searchFrndTV.register(UINib(nibName: "SearchFrndTVCell", bundle: nil), forCellReuseIdentifier: "SearchFrndTVCell")
        searchedResult = false
        
        let origImage = UIImage(named: "arrow_white")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tintedImage, for: .normal)
        backBtn.tintColor = UIColor.blue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.navigationBar.isHidden = false
    }
    //MARK: - TextFiled Delegate Method
    /*
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     searchedResult = true
     if textField.text != "" {
     textField.resignFirstResponder()
     self.getSearchResultWS(userId: userId, searchText: textField.text!)
     return true
     }
     return true
     }
     */
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
                        self.searchResultArr.removeAllObjects()
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            
                            self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 10, pageNo: 1)
                        }else {
                            self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 20, pageNo: 1)
                        }
                    }
                }
            }
        }else {
            self.searchResultArr.removeAllObjects()
            searchedResult = true
            searchStr = textField.text!+string
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 10, pageNo: 1)
            }else {
                self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 20, pageNo: 1)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchedResult = true
        if textField.text != "" {
            textField.resignFirstResponder()
            searchStr = textField.text!
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 10, pageNo: 1)
            }else {
                self.getSearchResultWS(userId: userId, searchText: searchStr, pageCount: 20, pageNo: 1)
            }
            return true
        }
        return true
    }
    
    //MARK: - Button Action Methods
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchTextCancelBtnTapped(_ sender: Any) {
        searchTxtFiled.text = ""
        searchTxtFiled.becomeFirstResponder()
        self.searchResultArr.removeAllObjects()
        self.searchFrndTV.reloadData()
    }
    @IBAction func searchTextActionMethod(_ sender: Any) {
        if searchTxtFiled.text != "" {
            //  self.getSearchResultWS(userId: userId, searchTxtFiled: searchBar.text!)
        }
    }
    
    @objc func acceptBtnTapped(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        print(String(describing: buttonTitle))
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchFrndTV)
        let indexPath = self.searchFrndTV.indexPathForRow(at: buttonPosition)
        let friendDict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        let friendId =  (friendDict["UserId"] as? String ?? "")
        
        if buttonTitle == "Add Friend" {
            self.addOrConfirmOrDeleteFriendWS(purpose: "add", frndId: friendId)
        }else if buttonTitle == "Request Sent" {
            self.errorAlert("Request already sent")
          //  self.show(message: "Request already sent", controller: self)
        }else if buttonTitle == "Accept" {
            self.addOrConfirmOrDeleteFriendWS(purpose: "confirm", frndId: friendId)
        }
    }
    @objc func friendsBtnTapped(_ sender: UIButton) {
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResultArr.count <= 0 && searchedResult == true
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Results"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.font = UIFont.boldSystemFont(ofSize: 17)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }else {
            tableView.backgroundView  = nil
        }
        return self.searchResultArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchDict  = self.searchResultArr[indexPath.row]
        
        let sFCell = tableView.dequeueReusableCell(withIdentifier: "SearchFrndTVCell", for: indexPath) as! SearchFrndTVCell
        
        sFCell.updateLabels(searchDict as! NSDictionary)
        
        sFCell.acceptBtn.addTarget(self, action: #selector(acceptBtnTapped(_:)), for: .touchUpInside)
        sFCell.FriendsBtn.addTarget(self, action: #selector(friendsBtnTapped(_:)), for: .touchUpInside)
        
        return sFCell
    }
    
    // MARK: - Web Service Methods
    
    func getSearchResultWS(userId: NSInteger, searchText: String, pageCount: NSInteger, pageNo: NSInteger) {
        
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
                    self.searchResultArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
                }
                self.searchFrndTV.reloadData()
            }else {
                self.searchResultArr.removeAllObjects()
                self.searchFrndTV.reloadData()
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
                
                if self.searchTxtFiled.text != "" {
                    self.searchResultArr.removeAllObjects()
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        
                        self.getSearchResultWS(userId: self.userId, searchText: self.searchStr, pageCount: 10, pageNo: 1)
                    }else {
                        self.getSearchResultWS(userId: self.userId, searchText: self.searchStr, pageCount: 20, pageNo: 1)
                    }
                }
                
                // self.navigationController?.popViewController(animated: true)
            }else {
                self.errorAlert("something went wrong, try again")
               // self.show(message: "something went wrong, try again", controller: self)
            }
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
         if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
         self.isLoadingList = true
         currentPage += 1
         if UIDevice.current.userInterfaceIdiom == .phone {
         self.getSearchResultWS(userId: self.userId, searchText: self.searchStr, pageCount: 10, pageNo: 1)
         }else {
         self.getSearchResultWS(userId: self.userId, searchText: self.searchStr, pageCount: 20, pageNo: 1)
         }
         }
         */
    }
}

