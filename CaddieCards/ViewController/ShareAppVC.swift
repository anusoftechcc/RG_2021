//
//  ShareAppVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 18/04/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ShareAppVC: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var lineLblArray: [UILabel]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Share the App"
        
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        lineLblArray[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        messageTxtView.layer.cornerRadius = 3.0
        messageTxtView.layer.borderWidth = 1.0
        messageTxtView.layer.borderColor = UIColor.darkGray.cgColor
        messageTxtView.clipsToBounds = true
    }
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == firstNameTxtField {
            return newLength <= 15
        }else if textField == emailTxtField {
            return newLength <= 52
        }
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        let txtTag: Int = textField.tag
        if txtTag < 502 {
            lineLblArray[txtTag-500].backgroundColor = GlobalConstants.APPGREENCOLOR
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxtField {
            self.emailTxtField.becomeFirstResponder()
        }else if textField == emailTxtField {
            self.emailTxtField.resignFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 1000
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
    
    //MARK: - Button Action Methods
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard let firstName = self.firstNameTxtField.text, firstName.count > 0, firstName.whiteSpaceBeforeString(name: self.firstNameTxtField.text!) else {
            self.errorAlert("Please enter your first name")
          //  self.show(message: "Please enter your first name", controller: self)
            return
        }
        guard let emailid = emailTxtField.text, emailid.count > 0, emailid.isValidEmail() else {
            self.errorAlert("Please enter valid email")
           // self.show(message: "Please enter valid email", controller: self)
            return
        }
        guard let message = self.messageTxtView.text, message.count > 0, message.whiteSpaceBeforeString(name: self.messageTxtView.text!) else {
            self.errorAlert("Please enter message")
           // self.show(message: "Please enter message", controller: self)
            return
        }
        
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let customerEmail: String = UserDefaults.standard.object(forKey: "CustomerEmail") as! String
        
        let params: Parameters = [
            "CustomerId": String(customeId),
            "CustomerEmail": customerEmail,
            "FirstName": firstName,
            "Email": emailid,
            "Message": message
        ]
        print("Edit profile Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().shareAppUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
                guard isError == false else {
                    self.errorAlert(message!)
                    return
                }
                print("Share App Responce = \(response.responseDictionary)")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
}
