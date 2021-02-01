//
//  HomeCourseNamesVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 23/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

protocol HomeCourseDelegateProtocol {
    func sendCourseNameToCreteGameVC(courseName: String)
}

class HomeCourseNamesVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var delegate: HomeCourseDelegateProtocol? = nil
    
   // let userId=UserDefaults.standard.object(forKey: "CustomerId") as? NSInteger
    var  searchResultArr = NSMutableArray()
    var  courseResultArray = NSMutableArray()
    @IBOutlet weak var searchCorseTV: UITableView!
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    var searchedResult = Bool()
    var searchStr: String!
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    @IBOutlet weak var searchHCTxtFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //Registering nib classes
        searchCorseTV.delegate = self
        searchCorseTV.dataSource = self
        searchCorseTV.isScrollEnabled  = true
        searchCorseTV.tableFooterView = UIView()
        searchCorseTV.isHidden = true
        searchHCTxtFiled.delegate = self
        searchedResult = false
        
        /*
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.tag = 200
        self.view.addGestureRecognizer(tap)
 */
    }
    override func viewDidLayoutSubviews() {
        
        searchCorseTV.layer.borderColor = UIColor.lightGray.cgColor
        searchCorseTV.layer.borderWidth = 1.0
    }
    
    //MARK: - Button Action Methods
    @IBAction func okBtnTapped(_ sender: Any) {
        
        if self.delegate != nil {
            let cName  = searchHCTxtFiled.text ?? ""
            self.delegate?.sendCourseNameToCreteGameVC(courseName: cName)
        }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent() 
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if self.delegate != nil {
            self.delegate?.sendCourseNameToCreteGameVC(courseName: "")
        }
        if let tap = sender {
            let point = tap.location(in: courseView)
            if courseView.point(inside: point, with: nil) == false {
                // write your stuff here
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
        
    }
    //MARK: - TextFiled Delegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchCorseTV.isHidden = false
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
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResultArr.count <= 0 && searchedResult == true
        {
//            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            noDataLabel.text          = "No Results"
//            noDataLabel.textColor     = UIColor.black
//            noDataLabel.font = UIFont.boldSystemFont(ofSize: 17)
//            noDataLabel.textAlignment = .center
//            tableView.backgroundView  = noDataLabel
//            tableView.separatorStyle  = .none
             searchCorseTV.isHidden = true
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
        let searchDict  = self.searchResultArr[indexPath.row] as! NSDictionary
        searchHCTxtFiled.text = (searchDict["CourseName"] as? String ?? "")
        searchCorseTV.isHidden = true
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
                }else {
                   // No Home Course
                    self.searchHCTxtFiled.text = "No Home Course"
                    self.searchCorseTV.isHidden = true
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
