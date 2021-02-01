//
//  LoginVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 08/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var emailIconImg: UIImageView!
    @IBOutlet weak var pwdIconImg: UIImageView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var showPwdBtn: UIButton!
    
    
    lazy var deviceTokenStr : String = ""
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.title = "LOGIN"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        emailView.cornerRadius = 5.0
        emailView.borderWidth = 1.0
        emailView.borderColor = GlobalConstants.APPCOLOR
        emailView.clipsToBounds = true
        
        pwdView.cornerRadius = 5.0
        pwdView.borderWidth = 1.0
        pwdView.borderColor = UIColor.lightGray
        pwdView.clipsToBounds = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController = self
        showPwdBtn.setBackgroundImage(UIImage(named: "password_hide"), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        //emailTxt.text = "help2@sublet.com"
       //passwordTxt.text = "test123"
    }
    
    //MARK: - Button Action Methods
    
    @IBAction func showPwdBtnTapped(_ sender: Any) {
        if passwordTxt.isSecureTextEntry {
            passwordTxt.isSecureTextEntry = false
            showPwdBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
            showPwdBtn.setBackgroundImage(UIImage(named: "password_show"), for: .normal)
        } else {
            passwordTxt.isSecureTextEntry = true
            showPwdBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
            showPwdBtn.setBackgroundImage(UIImage(named: "password_hide"), for: .normal)
        }
    }
    @IBAction func forgotPwdBtnTapped(_ sender: Any) {
        
        self.emailTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changePwdVCObj = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(changePwdVCObj, animated: true)
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        guard let email = emailTxt.text, email.count > 0 else {
            errorAlert("Please enter email")
          //  self.show(message: "Please enter email", controller: self)
            return
        }
        guard let pwd = passwordTxt.text, pwd.count > 0 else {
            errorAlert("Please enter password")
           // self.show(message: "Please enter password", controller: self)
            return
        }
        let params: Parameters = [
            "DeviceToken": Token.fcmToken,
            "DeviceType": "IOS",
            "Password": pwd,
            "UserName": email
        ]
        
        startLoadingIndicator(loadTxt: "Loading...")
        
        
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().loginUrl, urlParams: params as [String : AnyObject]) { (response) in
            
            if response.responseDictionary.count != 0 {
                print(response as Any)
                //  self.stopLoadingIndicator()
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
                guard isError == false else {
                    if (self.emailTxt.text?.isValidEmail())! == false {
                        self.pwdView.borderColor = UIColor.lightGray
                        self.pwdIconImg.backgroundColor = UIColor.lightGray
                        self.errorAlert("Please enter valid email")
                        //  self.show(message: "Please enter valid email", controller: self)
                    }else {
                        self.errorAlert(message!)
                        // self.show(message: message!, controller: self)
                    }
                    return
                }
                print(response.responseDictionary)
                let dict = response.responseDictionary
                
                 UserDefaults.standard.set("Yes", forKey: "Login")
                
                let ResdataDict = ["userid":dict["CustomerId"]!,"UserName":self.emailTxt.text!,"FirstName":dict["FirstName"] ?? "","AccessToken":dict["AccessToken"]!,"LastName":dict["LastName"] ?? "","FriendsCount":dict["FriendsCount"]!,"RequestCount":dict["RequestCount"]!]
                UserDefaults.standard.setValue(ResdataDict, forKey: "userData")
                UserDefaults.standard.setValue(dict["CustomerId"]!, forKey: "CustomerId")
                UserDefaults.standard.setValue(self.emailTxt.text!, forKey: "CustomerEmail")
                UserDefaults.standard.synchronize()
                if dict["ChangePassword"] as! String == "Yes" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                    //  let topVc = initialViewController.viewControllers[0] as! DashboardVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = initialViewController
                    
                    let storyboard1 = UIStoryboard(name: "GuestChangepassword", bundle: nil)
                    let guestVCObj = storyboard1.instantiateViewController(withIdentifier: "GuestChangePwdVC") as! GuestChangePwdVC
                    initialViewController.pushViewController(guestVCObj, animated: true)
                    
                }else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                    //  let topVc = initialViewController.viewControllers[0] as! DashboardVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = initialViewController
                }
                
            }else {
                self.errorAlert("Please your internet connection and try again.")
                // self.show(message: "Please your internet connection and try again.", controller: self)
            }
        }
        
        
        /*
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().loginUrl, urlParams: params as [String : AnyObject]) { (response) in
            if response.responseDictionary.count != 0 {
                print(response as Any)
                //  self.stopLoadingIndicator()
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
                guard isError == false else {
                    if (self.emailTxt.text?.isValidEmail())! == false {
                        self.pwdView.borderColor = UIColor.lightGray
                        self.pwdIconImg.backgroundColor = UIColor.lightGray
                        self.errorAlert("Please enter valid email")
                      //  self.show(message: "Please enter valid email", controller: self)
                    }else {
                        self.errorAlert(message!)
                       // self.show(message: message!, controller: self)
                    }
                    return
                }
                print(response.responseDictionary)
                let dict = response.responseDictionary
                
                let ResdataDict = ["userid":dict["CustomerId"]!,"UserName":self.emailTxt.text!,"FirstName":dict["FirstName"] ?? "","AccessToken":dict["AccessToken"]!,"LastName":dict["LastName"] ?? "","FriendsCount":dict["FriendsCount"]!,"RequestCount":dict["RequestCount"]!]
                UserDefaults.standard.setValue(ResdataDict, forKey: "userData")
                UserDefaults.standard.setValue(dict["CustomerId"]!, forKey: "CustomerId")
                UserDefaults.standard.setValue(self.emailTxt.text!, forKey: "CustomerEmail")
                UserDefaults.standard.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                //  let topVc = initialViewController.viewControllers[0] as! DashboardVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
            }else {
                self.errorAlert("Please your internet connection and try again.")
               // self.show(message: "Please your internet connection and try again.", controller: self)
            }
        }
        */
    }
    @IBAction func createAnAccountBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVCObj = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.pushViewController(signUpVCObj, animated: true)
    }
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxt {
            pwdView.borderColor = UIColor.lightGray
            pwdIconImg.backgroundColor = UIColor.lightGray
            emailView.borderColor = GlobalConstants.APPCOLOR
            emailIconImg.backgroundColor = GlobalConstants.APPCOLOR
        }else {
            emailView.borderColor = UIColor.lightGray
            emailIconImg.backgroundColor = UIColor.lightGray
            pwdView.borderColor = GlobalConstants.APPCOLOR
            pwdIconImg.backgroundColor = GlobalConstants.APPCOLOR
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxt {
            passwordTxt.becomeFirstResponder()
        }else {
            passwordTxt.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom Methods
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    //MARK: - Getting Device token from Appdelegate
    
    /**
     post device token  in login api
     */
    func loadRequest(for deviceTokenString : String)
    {
        deviceTokenStr = Token.fcmToken!
    }
    
}
