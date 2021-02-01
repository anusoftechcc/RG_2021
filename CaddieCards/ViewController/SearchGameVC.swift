//
//  SearchGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 28/03/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class SearchGameVC: BaseViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchTxtFiled: UITextField!
    @IBOutlet weak var searchGameTV: UITableView!
    
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  searchResultArr = NSMutableArray()
    var searchedResult = Bool()
    var searchStr: String!
    var searchTypeName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = true
        
        // Do any additional setup after loading the view.
        self.title = "Search Game"
        //Registering nib classes
        searchGameTV.delegate = self
        searchGameTV.dataSource = self
        searchGameTV.isScrollEnabled  = true
        searchGameTV.tableFooterView = UIView()
        searchedResult = false
        
        searchTxtFiled.setLeftPaddingPoints(10)
        
        searchGameTV.register(UINib(nibName: "ScheduledTVCell", bundle: nil), forCellReuseIdentifier: "ScheduledTVCell")
        searchGameTV.register(UINib(nibName: "GameHistoryTVCell", bundle: nil), forCellReuseIdentifier: "GameHistoryTVCell")
        searchGameTV.register(UINib(nibName: "ActiveGameTVCell", bundle: nil), forCellReuseIdentifier: "ActiveGameTVCell")
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
                            print(string)
                            searchStr = ""
                        }else {
                            searchStr = string
                        }
                        self.searchResultArr.removeAllObjects()
                        
                        self.getSearchResultWS(searchText: searchStr, searchType : searchTypeName)
                    }
                }
            }
        }else {
            self.searchResultArr.removeAllObjects()
            searchedResult = true
            searchStr = textField.text!+string
            
            self.getSearchResultWS(searchText: searchStr, searchType : searchTypeName)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchedResult = true
        if textField.text != "" {
            textField.resignFirstResponder()
            searchStr = textField.text!
            
            self.getSearchResultWS(searchText: textField.text!, searchType :searchTypeName)
            return true
        }
        return true
    }
    
    
    //MARK: - Button Action Methods
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResultArr.count <= 0
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
        
        if searchTypeName == "scheduled" {
            if self.searchResultArr.count != 0 && indexPath.row < self.searchResultArr.count {
                let scheduleDict  = self.searchResultArr[indexPath.row]
                let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "ScheduledTVCell", for: indexPath) as! ScheduledTVCell
                
                scheduleCell.updateLabels(scheduleDict as! NSDictionary)
                
                scheduleCell.imOutBtn.addTarget(self, action: #selector(playBtnTapped(_:)), for: .touchUpInside)
                scheduleCell.messageBtn.addTarget(self, action: #selector(messageBtnTapped(_:)), for: .touchUpInside)
                
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
        }else if searchTypeName == "history" {
            if self.searchResultArr.count != 0 && indexPath.row < self.searchResultArr.count {
                let scheduleDict  = self.searchResultArr[indexPath.row]
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
            if self.searchResultArr.count != 0 && indexPath.row < self.searchResultArr.count {
            let scheduleDict  = self.searchResultArr[indexPath.row]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Web Service Methods
    
    func getSearchResultWS(searchText: String, searchType: String) {
        
        let params: Parameters = [
            "Term": searchText,
            "CustomerId": userId,
            "SearchType": searchType
        ]
        print("Get Course Names Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().getgamesNamesAjaxSearchUrl, urlParams: params as [String : AnyObject]) { (response) in
            
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
                    
                    let jsonData = try! JSONSerialization.data(withJSONObject: response.customModel, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    let friends = Mapper<FriendsModel>().map(JSONString: jsonString)
                    print(friends?.firstName ?? "")
                }
                self.searchGameTV.reloadData()
                
            }else {
                self.searchResultArr.removeAllObjects()
                self.searchGameTV.reloadData()
            }
        }
    }
    func endGameWS(userId: String, gameId: String) {
        let urlString :  String =  MyStrings().endGameWSUrl + "\(userId)" + "&GameId=" + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
               self.getSearchResultWS(searchText: self.searchStr, searchType : self.searchTypeName)
            }else {
                self.errorAlert("Unable to end this game")
                //  self.show(message: "Unable to add to group", controller: self)
            }
        }
    }
    
    //MARK: - Schedule Action Methods
    @objc func playBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        let gameId =  (dict["GameId"] as? String ?? "")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(playVCObj, animated: true)
        
    }
    @objc func messageBtnTapped(_ sender: UIButton) {
    }
    
    @objc func editScheduleBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    
    //MARK: - History Action Methods
    
    @objc func scoresBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScorebordVC") as! ScorebordVC
        let gameId =  (dict["GameId"] as? String ?? "")
        scoresVCObj.gameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(scoresVCObj, animated: true)
    }
    @objc func replayBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        cGameVCObj.isReplayVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    
    //MARK: - Active Action Methods
    
    @objc func resumeBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
        playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        self.navigationController?.pushViewController(playVCObj, animated: true)
    }
    @objc func editBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
        let gameId =  (dict["GameId"] as? String ?? "")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    @objc func endBtnTapped(_ sender: UIButton) {
     
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.searchGameTV)
        let indexPath = self.searchGameTV.indexPathForRow(at: buttonPosition)
        let dict  = self.searchResultArr[indexPath!.row] as! NSDictionary
        
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
}
