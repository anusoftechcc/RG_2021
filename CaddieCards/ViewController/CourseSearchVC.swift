//
//  CourseSearchVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 02/07/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

protocol SearchCourseDelegateProtocol {
    func sendCourseNameToCreteGameVC(courseName: String)
}

class CourseSearchVC: BaseViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate {
    
    var delegate: SearchCourseDelegateProtocol? = nil
    
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var  searchResultArr = NSMutableArray()
    var  courseResultArray = NSMutableArray()
    @IBOutlet weak var searchCorseTV: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchTxtFiled: UITextField!
    var searchedResult = Bool()
    var searchStr: String!
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        searchTxtFiled.setLeftPaddingPoints(10)
        searchTxtFiled.becomeFirstResponder()
        
//        searchTxtFiled.delegate = self
//        searchTxtFiled.isUserInteractionEnabled = true
//        searchTxtFiled.isHidden = false
//       // searchTxtFiled.becomeFirstResponder()
      //  searchTxtFiled.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 1.0)
        
        //Registering nib classes
        searchCorseTV.delegate = self
        searchCorseTV.dataSource = self
        searchCorseTV.isScrollEnabled  = true
        searchCorseTV.tableFooterView = UIView()
        searchedResult = false
        
        
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
                            self.getSearchResultWS(searchText: searchStr, pageCount: 10, pageNo: 1)
                        }else {
                            self.getSearchResultWS(searchText: searchStr, pageCount: 20, pageNo: 1)
                        }
                    }
                }
            }
        }else {
            self.searchResultArr.removeAllObjects()
            searchedResult = true
            searchStr = textField.text!+string
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(searchText: searchStr, pageCount: 10, pageNo: 1)
            }else {
                self.getSearchResultWS(searchText: searchStr, pageCount: 20, pageNo: 1)
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
                self.getSearchResultWS(searchText: textField.text!, pageCount: 10, pageNo: 1)
            }else {
                self.getSearchResultWS(searchText: textField.text!, pageCount: 20, pageNo: 1)
            }
            return true
        }
        return true
    }
    
    
    //MARK: - Button Action Methods
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchTextActionMethod(_ sender: Any) {
        if searchTxtFiled.text != "" {
            //  self.getSearchResultWS(userId: userId, searchTxtFiled: searchBar.text!)
        }
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
        
        let sCCell = tableView.dequeueReusableCell(withIdentifier: "SearchCourseNameTVCell", for: indexPath) as! SearchCourseNameTVCell
        
        sCCell.updateLabels(searchDict as! NSDictionary)
        
        return sCCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            let searchDict  = self.searchResultArr[indexPath.row] as! NSDictionary
            let cName =  (searchDict["CourseName"] as? String ?? "")
            self.delegate?.sendCourseNameToCreteGameVC(courseName: cName)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Web Service Methods
    
    func getSearchResultWS(searchText: String, pageCount: NSInteger, pageNo: NSInteger) {
        
        let params: Parameters = [
            "term": searchText,
            "pageCount": pageCount,
            "PageNumber": pageNo
        ]
        print("Get Course Names Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().getCourseNamesAjaxSearchUrl, urlParams: params as [String : AnyObject]) { (response) in
            
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
                    let resultArray = (dict as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for (_, item2) in resultArray.enumerated() {
                        self.isLoadingList = false
                        let courseDict = item2 as? NSDictionary
                        self.searchResultArr.add(courseDict as Any)
                    }
                }
                self.searchCorseTV.reloadData()
            }else {
                self.searchResultArr.removeAllObjects()
                self.searchCorseTV.reloadData()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            currentPage += 1
            if UIDevice.current.userInterfaceIdiom == .phone {
                self.getSearchResultWS(searchText: searchStr, pageCount: 10, pageNo: currentPage)
            }else {
                self.getSearchResultWS(searchText: searchStr, pageCount: 20, pageNo: currentPage)
            }
        }
    }
}
