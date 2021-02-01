//
//  ProfilePerDetailsEditVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class ProfilePerDetailsEditVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var perDetailsTV: UITableView!
    var isVCName :  String!
    var profileDataArray = ProfileModel(JSONString: "")
    var scoresArray = [String]()
    var statesArray = NSMutableArray()
    var statesArray2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        if isVCName != "avgScore" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveBtnTapped))
            self.title = "PERSONAL DETAILS"
        }else {
            self.title = "EDIT AVERAGE SCORE"
        }
        
        perDetailsTV.delegate = self
        perDetailsTV.dataSource = self
        perDetailsTV.tableFooterView = UIView()
        scoresArray = scoreValues() as! [String]
        registerForKeyboardWillShowNotification(perDetailsTV)
        registerForKeyboardWillHideNotification(perDetailsTV)
        
        callStatesApi()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        let yOffset = UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.size.height
        //        perDetailsTV.scrollIndicatorInsets = UIEdgeInsets(top: yOffset, left: 0, bottom: 0, right: 0)
    }
    
    func callStatesApi() {
        
        ApiCall.postServercall(onView:self, url: MyStrings().getStatesUrl, httpMethod: .get, loading: self) { (response) in
            
            if(response.isSuccess){
                print(response as Any)
                
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
                
                self.statesArray = (dict as! NSArray).mutableCopy() as! NSMutableArray
                for (index,object1) in self.statesArray.enumerated() {
                    let dict6 = self.statesArray[index] as! NSDictionary
                    self.statesArray2.append(dict6["State"] as! String)
                }
                
            }
        }
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isVCName == "avgScore" {
            let avgCell = tableView.dequeueReusableCell(withIdentifier: "EditAvgScoreTVCell", for: indexPath) as! EditAvgScoreTVCell
            
            avgCell.avgScoreDWBtn.setTitle(self.profileDataArray?.averageScore ?? "", for: .normal)
            avgCell.avgScoreDWBtn.addTarget(self, action: #selector(avgScoreDWBtnTapped(_:)), for: .touchUpInside)
            avgCell.submitBtn.addTarget(self, action: #selector(avdScoreSubmitBtnTapped(_:)), for: .touchUpInside)
            
            return avgCell
        }else {
            let addressCell = tableView.dequeueReusableCell(withIdentifier: "EditAddressDetailsTVCell", for: indexPath) as! EditAddressDetailsTVCell
            addressCell.address1TxtFiled.text = self.profileDataArray?.address1 ?? ""
            addressCell.address2TxtFiled.text = self.profileDataArray?.address2 ?? ""
            addressCell.cityTxtFiled.text = self.profileDataArray?.city ?? ""
            addressCell.stateTxtFiled.text = self.profileDataArray?.state ?? ""
            addressCell.zipTxtFiled.text = self.profileDataArray?.zip ?? ""
            
            addressCell.zipTxtFiled.tag = 3
            addressCell.zipTxtFiled.delegate = self
            addressCell.cityTxtFiled.tag = 4
            addressCell.cityTxtFiled.delegate = self
            addressCell.stateTxtFiled.tag = 5
            addressCell.stateTxtFiled.delegate = self
            
            return addressCell
        }
    }
    
    //MARK:- Button Action Methods
    @objc func avgScoreDWBtnTapped(_ sender: UIButton) {
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
                                    with: self.scoresArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        let indexPath = IndexPath(row: 0, section: 0)
                                        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAvgScoreTVCell
                                        cell.avgScoreDWBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
        }) {
            
        }
    }
    @objc func avdScoreSubmitBtnTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAvgScoreTVCell
        
        var avgScore: String = ""
        if let text = cell.avgScoreDWBtn.titleLabel?.text {
            print(text)
            avgScore = text
        }
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let oldPwd: String = self.profileDataArray?.password ?? ""
        let userName: String = self.profileDataArray?.userName ?? ""
        let courcesArray = NSMutableArray()
        let courceDict = NSMutableDictionary()
        for course in (self.profileDataArray?.courseNames)! {
            courceDict.setValue(course.courseName, forKey: "CourseName")
            courcesArray.add(courceDict)
        }
        
        let params: Parameters = [
            "CustomerId": customeId,
            "UserName": userName,
            "Password": oldPwd,
            "FirstName": self.profileDataArray?.firstName ?? "",
            "LastName": self.profileDataArray?.lastName ?? "",
            "DOB": self.profileDataArray?.dob ?? "",
            "Age": self.profileDataArray?.age ?? "",
            "Phone": self.profileDataArray?.phone ?? "",
            "Gender": self.profileDataArray?.gender ?? "",
            "HandiCap": self.profileDataArray?.handiCap ?? "",
            "HomeCourse": self.profileDataArray?.homeCourse ?? "",
            "AverageScore": avgScore,
            "Address1": profileDataArray?.address1 ?? "",
            "Address2": profileDataArray?.address2 ?? "",
            "City": profileDataArray?.city ?? "",
            "State": profileDataArray?.state ?? "",
            "Zip": profileDataArray?.zip ?? "",
            "CourseNames": courcesArray
        ]
        print("Edit profile avg score Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().saveEditProfileUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            //Modified by andy dev 03232019 5:22pm
            //added If condition to avoid crash when sending data to server failed.
            if(response.isSuccess){
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
                guard isError == false else {
                    self.errorAlert(message!)
                    return
                }
                print("Edit profile Responce = \(response.responseDictionary)")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    @objc func saveBtnTapped() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        
        guard let address1 = cell.address1TxtFiled.text, address1.count > 0, address1.whiteSpaceBeforeString(name: cell.address1TxtFiled.text!) else {
            self.errorAlert("Please enter address")
          //  self.show(message: "Please enter address", controller: self)
            return
        }
        guard let city = cell.cityTxtFiled.text, city.count > 0, city.whiteSpaceBeforeString(name: cell.cityTxtFiled.text!) else {
            self.errorAlert("Please enter city")
          //  self.show(message: "Please enter city", controller: self)
            return
        }
        guard let state = cell.stateTxtFiled.text, state.count > 0, state.whiteSpaceBeforeString(name: cell.stateTxtFiled.text!) else {
           self.errorAlert("Please enter state")
          //  self.show(message: "Please enter state", controller: self)
            return
        }
        guard let zip = cell.zipTxtFiled.text, zip.count > 0, zip.whiteSpaceBeforeString(name: cell.zipTxtFiled.text!) else {
            self.errorAlert("Please enter zip code")
          //  self.show(message: "Please enter zip code", controller: self)
            return
        }
        let address2 = cell.address2TxtFiled.text
        
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let oldPwd: String = self.profileDataArray?.password ?? ""
        let userName: String = self.profileDataArray?.userName ?? ""
        let courcesArray = NSMutableArray()
        let courceDict = NSMutableDictionary()
        for course in (self.profileDataArray?.courseNames)! {
            courceDict.setValue(course.courseName, forKey: "CourseName")
            courcesArray.add(courceDict)
        }
        
        let params: Parameters = [
            "CustomerId": customeId,
            "UserName": userName,
            "Password": oldPwd,
            "FirstName": self.profileDataArray?.firstName ?? "",
            "LastName": self.profileDataArray?.lastName ?? "",
            "DOB": self.profileDataArray?.dob ?? "",
            "Age": self.profileDataArray?.age ?? "",
            "Phone": self.profileDataArray?.phone ?? "",
            "Gender": self.profileDataArray?.gender ?? "",
            "HandiCap": self.profileDataArray?.handiCap ?? "",
            "HomeCourse": self.profileDataArray?.homeCourse ?? "",
            "AverageScore": profileDataArray?.averageScore ?? "",
            "Address1": address1,
            "Address2": address2 as Any,
            "City": city,
            "State": state,
            "Zip": zip,
            "CourseNames": courcesArray
        ]
        print("Edit profile address Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().saveEditProfileUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            //Modified by andy dev 03232019 5:22pm
            //added If condition to avoid crash when sending data to server failed.
            if(response.isSuccess){
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
                guard isError == false else {
                    self.errorAlert(message!)
                    return
                }
                print("Edit profile Responce = \(response.responseDictionary)")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    //MARK: - Custom Methods
    func scoreValues() -> NSArray {
        var array = [String]()
        for i in 72...108 {
            array.append(String(i))
        }
        return array as NSArray
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        if textField == cell.zipTxtFiled {
            if cell.zipTxtFiled.text != "" {
                self.zipCodeDetailsWS(zipCode: cell.zipTxtFiled.text!)
            }
        }
//        if cell.stateTxtFiled.tag == 5 {
//            cell.stateTxtFiled.resignFirstResponder()
//        }
        else if textField == cell.stateTxtFiled {
            cell.stateTxtFiled.resignFirstResponder()
        }else if textField == cell.cityTxtFiled {
            cell.cityTxtFiled.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        if textField == cell.cityTxtFiled  {
            textField.resignFirstResponder()
        }
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        
        if textField == cell.stateTxtFiled  {
//            cell.stateTxtFiled.resignFirstResponder()
//            cell.cityTxtFiled.resignFirstResponder()
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        for label in cell.linesLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        //need to verify this with madhu
        //        let txtTag: Int = textField.tag
        //        if txtTag < 25 {
        //            cell.linesLblArray[txtTag-20].backgroundColor = GlobalConstants.EDITPROFILELINECOLOR
        //        }
        if textField == cell.zipTxtFiled {
            self.addDoneButtonOnNumpad(textField: textField)
        }
        if textField == cell.stateTxtFiled {
            cell.cityTxtFiled.resignFirstResponder()
            cell.stateTxtFiled.resignFirstResponder()
            let configuration = FTConfiguration.shared
            let cellConfi = FTCellConfiguration()
            configuration.menuRowHeight = 40
            configuration.menuWidth =  250
            configuration.backgoundTintColor = UIColor.lightGray
            cellConfi.textColor = UIColor.white
            cellConfi.textFont = .systemFont(ofSize: 13)
            configuration.borderColor = UIColor.lightGray
            configuration.menuSeparatorColor = UIColor.white
            configuration.borderWidth = 0.5
            cellConfi.textAlignment = NSTextAlignment.center
            FTPopOverMenu.showForSender(sender: cell.stateTxtFiled as! UIView,
                                        with: self.statesArray2 as! [String],
                                        done: { (selectedIndex) -> () in
                                            print(selectedIndex)
                                            cell.stateTxtFiled.text = self.statesArray2[selectedIndex] as! String
                                            cell.cityTxtFiled.resignFirstResponder()
                                            cell.stateTxtFiled.resignFirstResponder()
                                            cell.zipTxtFiled.text = ""
                                            cell.cityTxtFiled.text = ""
                                            
            }) {
            }
        }
        
        return true
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        
        if textField == cell.address1TxtFiled {
            cell.address2TxtFiled.becomeFirstResponder()
        }else if textField == cell.address2TxtFiled {
            cell.cityTxtFiled.becomeFirstResponder()
        }else if textField == cell.cityTxtFiled {
            cell.stateTxtFiled.resignFirstResponder()
        }else if textField == cell.zipTxtFiled {
            cell.cityTxtFiled.becomeFirstResponder()
        }else if textField == cell.stateTxtFiled {
            cell.stateTxtFiled.resignFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func zipCodeDetailsWS(zipCode : String) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        
        let urlString :  String =  MyStrings().zipCodeUrl + "\(zipCode ?? "")"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.getServercall(onView: self, isBody: true, urlString: urlString) { (response) in
            print(response as Any)
            
            if response.object(forKey: "State") != nil {
                cell.stateTxtFiled.text = response.object(forKey: "State") as? String
                cell.cityTxtFiled.text = response.object(forKey: "City") as? String
            }
        }
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        let nextTxt : String = "Done"
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: nextTxt, style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar
    }
    
    @objc func doneWithNumberPad() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.perDetailsTV.cellForRow(at: indexPath as IndexPath) as! EditAddressDetailsTVCell
        //Done with number pad
        cell.zipTxtFiled.resignFirstResponder()
    }
}
