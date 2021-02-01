//
//  ContactUsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit


class ContactUsVC: BaseViewController {

    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var commentsTxtView: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var subjectTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    var alert = UIAlertController()
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "CONTACT US"
        
        
        bgView.layer.cornerRadius = 3.0
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        bgView.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sentBtnTapped(_ sender: Any) {
        if self.emailTxtField.isFirstResponder {
            self.emailTxtField.resignFirstResponder()
        }
        if self.nameTxtField.isFirstResponder {
            self.nameTxtField.resignFirstResponder()
        }
        if self.subjectTxtField.isFirstResponder {
            self.subjectTxtField.resignFirstResponder()
        }
        if self.commentsTxtView.isFirstResponder {
            self.commentsTxtView.resignFirstResponder()
        }
        guard let nameText = nameTxtField.text, !nameText.isEmpty else {
            self.errorAlert("Please enter name")
            return // or throw
        }
        guard let emailText = emailTxtField.text, !emailText.isEmpty else {
            self.errorAlert("Please enter valid email")
            return // or throw
        }
        guard let emailid = emailTxtField.text, emailid.count > 0, emailid.isValidEmail() else {
            self.errorAlert("Please enter valid email")
           // self.show(message: "Please enter valid email", controller: self)
            return
        }
        guard let subjectText = subjectTxtField.text, !subjectText.isEmpty else {
            self.errorAlert("Please enter subject")
            return // or throw
        }
        guard let comments = commentsTxtView.text, !comments.isEmpty else {
            self.errorAlert("Please enter message")
            return // or throw
        }
        self.makeContactUSCall()
        
        
        
    }
   
    func makeContactUSCall() {
        
        let params: Parameters = [
            "FirstName": self.nameTxtField.text!,
            "ContactMailId": self.emailTxtField.text!,
            "Subject" : self.subjectTxtField.text!,
            "Message" : self.commentsTxtView.text!
        ]
        
        print("Send Putz Card Parameters = \(params) and url = \(MyStrings().contactUsUrl)")
        //if isSelectedPlayer == true {
            self.startLoadingIndicator(loadTxt: "Loading...")
            ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().contactUsUrl, urlParams: params as [String : AnyObject]) { (response) in
                print(response as Any)
                
                if(response.isSuccess){
                    if response.responseCode != 200 {
                        self.errorAlert("Sending message failed. Please try again")
                        return
                    }else {
                        DispatchQueue.main.async {
                        print("Send Putz Card Responce = \(response.responseDictionary)")
                        
                        self.alert = UIAlertController(title: " Success", message: "Message has been sent", preferredStyle: UIAlertController.Style.alert)
                     
                        self.alert.addAction(UIAlertAction(title: "OK",
                                                           style: UIAlertAction.Style.default,
                                                           handler: {(_: UIAlertAction!) in
                                                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(self.alert, animated: true, completion: nil)
                    }
                    }
                }
            }

    }
    //MARK: - Keyboard Notification Methods
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrlView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrlView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrlView.contentInset = contentInset
    }

}
extension ContactUsVC : UITextViewDelegate,UITextFieldDelegate {
    //MARK: - TextView Delegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if newText == "\n" {
                textView.resignFirstResponder()
                return false
            }
        return numberOfChars < 500
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTxtField {
            self.emailTxtField.becomeFirstResponder()
        }else if textField == emailTxtField {
            self.subjectTxtField.becomeFirstResponder()
        }else if textField == subjectTxtField {
            self.commentsTxtView.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == nameTxtField {
            return newLength <= 30
        }else if textField == emailTxtField {
            return newLength <= 52
        }else if textField == subjectTxtField {
            return newLength <= 52
        }
        return false
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
