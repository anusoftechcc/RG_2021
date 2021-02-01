//
//  ChangePasswordVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newPwdTxtField: UITextField!
    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet var lineLblsArray: [UILabel]!
    var profileDataArray = ProfileModel(JSONString: "")
    
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "CHANGE PASSWORD"
        
        
        newPwdTxtField.delegate = self
        confirmPwdTxtField.delegate = self
        for label in lineLblsArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        lineLblsArray[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        submitBtn.backgroundColor = GlobalConstants.APPCOLOR
        submitBtn.setTitleColor(UIColor.white, for: .normal)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.layoutIfNeeded()
        let layer = mainView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
    }
    
    
    //MARK: - Submit Button Action Method
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard let pwd = self.newPwdTxtField.text, pwd.count > 0,pwd.whiteSpaceBeforeString(name: self.newPwdTxtField.text!) else {
            self.errorAlert("Please enter password")
          //  self.show(message: "Please enter password", controller: self)
            return
        }
        guard let confirmPwd = self.confirmPwdTxtField.text, confirmPwd.count > 0,confirmPwd.whiteSpaceBeforeString(name: self.confirmPwdTxtField.text!) else {
            self.errorAlert("Please enter confirm password")
           // self.show(message: "Please enter confirm password", controller: self)
            return
        }
        if self.newPwdTxtField.text != self.confirmPwdTxtField.text {
            self.errorAlert("Password and Confirm Password are mismatch")
          //  self.show(message: "Password and Confirm Password are mismatch", controller: self)
            return
        }
        
        //Modified by Andy dev 031919 5:45pm
        
        //  let customerId: String = self.profileDataArray?.customerId ?? ""
        // let oldPwd: String = self.profileDataArray?.password ?? ""
        
        
        //        let params: Parameters = [
        //            "CustomerId": customerId,
        //            "OldPassword": oldPwd,
        //            "NewPassword": pwd,
        //            "ConfirmPassword": confirmPwd
        //        ]
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        
        let params: Parameters = [
            "CustomerId": String(customeId),
            "NewPassword": pwd,
            "Purpose": "password"
        ]
        
        
        print(params)
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().changePwdUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            self.navigationController?.popViewController(animated: true)
        }
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
        for label in lineLblsArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        let txtTag: Int = textField.tag
        lineLblsArray[txtTag-600].backgroundColor = GlobalConstants.APPGREENCOLOR
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == newPwdTxtField {
            confirmPwdTxtField.becomeFirstResponder()
        }else {
            confirmPwdTxtField.resignFirstResponder()
        }
        return true
    }
    
}
