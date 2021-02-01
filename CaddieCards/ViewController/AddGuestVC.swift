//
//  AddGuestVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 23/08/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class AddGuestVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtFiled: UITextField!
    @IBOutlet weak var handicapBtn: UIButton!
    
    @IBOutlet var lineLblArray: [UILabel]!
    @IBOutlet weak var submitBtn: UIButton!
    
    var handicapArray = [String]()
    var scoresArray = [String]()
    var handicap :  String = ""
    var phoneNo: String = ""
    var gameId: String = ""
    var dictToSave = [String: String]()
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countryCodesBtn: UIButton!
    var countryCodesArr = ["+91","+44"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GUEST DETAILS"
        self.navigationController?.navigationBar.isHidden = false
        
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        handicapArray = handicapValues() as! [String]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.handicapBtn.setTitle("Select Handicap", for: .normal)
        self.handicap = "Select Handicap"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.layoutIfNeeded()
        let layer = backView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
        
        countryCodesBtn.layer.borderColor = UIColor.lightGray.cgColor
        countryCodesBtn.layer.borderWidth = 1
        countryCodesBtn.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    //MARK: - Button Action Methods
    @IBAction func handicapBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
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
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.handicapArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.handicapBtn.setTitle(self.handicapArray[selectedIndex], for: .normal)
                                        self.handicap = self.handicapArray[selectedIndex]
                                        
        }) {
        }
    }
    @IBAction func countryCodesBtnTapped(_ sender: Any) {
        let configuration = FTConfiguration.shared
        let cellConfi = FTCellConfiguration()
        configuration.menuRowHeight = 40
        configuration.menuWidth =  100
        configuration.backgoundTintColor = UIColor.lightGray
        cellConfi.textColor = UIColor.white
        cellConfi.textFont = .systemFont(ofSize: 13)
        configuration.borderColor = UIColor.lightGray
        configuration.menuSeparatorColor = UIColor.white
        configuration.borderWidth = 0.5
        cellConfi.textAlignment = NSTextAlignment.center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.countryCodesArr,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.countryCodesBtn.setTitle(self.countryCodesArr[selectedIndex], for: .normal)
        }) {
        }
    }
    @IBAction func submitBtnTapped(_ sender: Any) {
        let gameId = UserDefaults.standard.object(forKey: "GameId") as! NSInteger
        var guestEmailId : String = ""
        if emailTxtField.text == nil || emailTxtField.text?.count ?? 0 == 0 {
            guestEmailId = String(format: "guest_%d@golfputz.com", gameId)
        }else {
            guestEmailId = self.emailTxtField.text!
        }
//        if let emailid = emailTxtField.text, emailid.count > 0 else {
//            //self.errorAlert("Please enter valid email")
//
//           // return
//        }
        guard let password = self.passwordTxtField.text, password.count > 0, password.whiteSpaceBeforeString(name: self.passwordTxtField.text!) else {
            self.errorAlert("Please enter password")
            return
        }
        guard let firstName = self.firstNameTxtField.text, firstName.count > 0, firstName.whiteSpaceBeforeString(name: self.firstNameTxtField.text!) else {
            self.errorAlert("Please enter your first name")
            return
        }
        if self.handicap == "Select Handicap" {
            self.errorAlert("Please select handicap")
            return
        }else if self.phoneNo.count > 0, self.phoneNo.count < 10 {
            self.errorAlert("Please enter a 10 digit phone number")
            return
        }
        
        //  let customerId: String = self.profileDataArray?.customerId ?? ""
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let lastName:String = self.lastNameTxtField.text ?? ""
        let params: Parameters = [
            "CustomerId": customeId,
            "UserName": guestEmailId,
            "Password": password,
            "FirstName": firstName,
            "LastName": lastName,
            "Phone": phoneNo,
            "HandiCap": handicap,
            "GameId":gameId
            ]
        print("Guest Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().saveGuestDetailsUrl, urlParams: params as [String : AnyObject]) { (response) in
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
                    //  self.show(message: message!, controller: self)
                    return
                }
                print("Guest Responce = \(response.responseDictionary)")
                let dict  = response.responseDictionary as NSDictionary
                //                UserDefaults.standard.setValue(dict, forKey: "Guest Data")
                //                UserDefaults.standard.synchronize()
                let data = NSKeyedArchiver.archivedData(withRootObject: dict)
                UserDefaults.standard.set(data, forKey: "Guest Data")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    // MARK: -  TextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*
         let currentString: NSString = textField.text! as NSString
         let newString: NSString =
         currentString.replacingCharacters(in: range, with: string) as NSString
         */
        if textField == phoneTxtFiled {
            /*
             if newString.length > 10 {
             return false
             } else if newString.length <= 10 {
             phoneNo = newString as String
             return true
             }
             return true
             */
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedNumber(number: newString)
            return false
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        let txtTag: Int = textField.tag
        lineLblArray[txtTag-200].backgroundColor = GlobalConstants.EDITPROFILELINECOLOR
        if textField == phoneTxtFiled {
            self.addDoneButtonOnNumpad(textField: textField)
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTxtFiled {
            let currentString = textField.text!
            let test = String(currentString.filter { !" ()-".contains($0) })
            // phoneTxtFiled.text = self.phoneNumberFormate(phNo: phoneNo)
            if test.count > 0 && test.count == 10 {
                phoneNo = test as String
            }else {
                self.errorAlert("Please enter valid phone number")
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField {
            self.passwordTxtField.becomeFirstResponder()
        }else if textField == passwordTxtField {
            self.firstNameTxtField.becomeFirstResponder()
        }else if textField == firstNameTxtField {
            self.lastNameTxtField.becomeFirstResponder()
        }else if textField == lastNameTxtField {
            self.phoneTxtFiled.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom Methods
    func handicapValues() -> NSArray {
        var array = [String]()
        array.append("Select Handicap")
        for i in 0...36 {
            array.append(String(i))
        }
        return array as NSArray
    }
    func phoneNumberFormate(phNo: String) -> String {
        if phNo.count == 10 {
            let subStr1 = phNo.substring(0..<3)
            let subStr2 = phNo.substring(3..<6)
            let subStr3 = phNo.substring(6..<10)
            let phNoFormate = "(\(subStr1))" + " \(subStr2)" + "-\(subStr3)"
            return phNoFormate
        }else {
            return ""
        }
    }
    
    //MARK: - Keyboard Notification Methods
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        //Done with number pad
        self.phoneTxtFiled.resignFirstResponder()
    }
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
