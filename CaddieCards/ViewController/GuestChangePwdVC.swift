//
//  GuestChangePwdVC.swift
//  CaddieCards
//
//  Created by Mounika Reddy on 22/01/21.
//  Copyright © 2021 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class GuestChangePwdVC: BaseViewController {

    @IBOutlet weak var cpwdTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "CREATE PASSWORD"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.pwdTxtField.isFirstResponder {
            self.pwdTxtField.resignFirstResponder()
        }
        if self.cpwdTxtField.isFirstResponder {
            self.cpwdTxtField.resignFirstResponder()
        }
        guard let nameText = pwdTxtField.text, !nameText.isEmpty else {
            self.errorAlert("Please enter password")
            return // or throw
        }
        guard let emailText = cpwdTxtField.text, !emailText.isEmpty else {
            self.errorAlert("Please enter confirm password")
            return // or throw
        }
        if nameText != emailText {
            self.errorAlert("Password and confirm doesn't match")
            return
        }
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        
        let params: Parameters = [
            "CustomerId": String(customeId),
            "NewPassword": nameText,
        ]
        print(params)
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().changePwdUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GuestChangePwdVC : UITextFieldDelegate {
    //MARK: - TextView Delegate Methods
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pwdTxtField {
            self.cpwdTxtField.becomeFirstResponder()
        }else if textField == cpwdTxtField {
            self.cpwdTxtField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == pwdTxtField {
            return newLength <= 10
        }else if textField == cpwdTxtField {
            return newLength <= 10
        }
        return false
    }
}
