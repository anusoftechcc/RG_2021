//
//  EditAddressDetailsTVCell.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class EditAddressDetailsTVCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var address1TxtFiled: UITextField!
    @IBOutlet weak var address2TxtFiled: UITextField!
    @IBOutlet weak var cityTxtFiled: UITextField!
    @IBOutlet weak var stateTxtFiled: UITextField!
    @IBOutlet weak var zipTxtFiled: UITextField!
    
    @IBOutlet var linesLblArray: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        address1TxtFiled.delegate = self
        address2TxtFiled.delegate = self
        cityTxtFiled.delegate = self
        stateTxtFiled.delegate = self
        zipTxtFiled.delegate = self
        
        for label in linesLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layoutIfNeeded()
        let layer = shadowView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
    }
    // MARK: -  TextField Delegate Methods
 /*   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        for label in linesLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        let txtTag: Int = textField.tag
        if txtTag < 25 {
            linesLblArray[txtTag-20].backgroundColor = GlobalConstants.EDITPROFILELINECOLOR
        }
        if textField == zipTxtFiled {
            self.addDoneButtonOnNumpad(textField: zipTxtFiled)
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == address1TxtFiled {
            self.address2TxtFiled.becomeFirstResponder()
        }else if textField == address2TxtFiled {
            self.cityTxtFiled.becomeFirstResponder()
        }else if textField == cityTxtFiled {
            self.stateTxtFiled.becomeFirstResponder()
        }else if textField == stateTxtFiled {
            self.zipTxtFiled.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
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
        self.zipTxtFiled.resignFirstResponder()
    } */
    
}
/*
 extension UITextField {
 
 open override func awakeFromNib() {
 super.awakeFromNib()
 self.addHideinputAccessoryView1()
 }
 
 func addHideinputAccessoryView1() {
 
 let toolbar = UIToolbar()
 toolbar.sizeToFit()
 let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
 target: self, action: #selector(self.resignFirstResponder))
 toolbar.setItems([item], animated: true)
 
 self.inputAccessoryView = toolbar
 }
 
 /* use the above functions with
 block, in case you want the trigger just after the keyboard
 hide or show which will return you the keyboard size also.
 */
 
 registerForKeyboardWillShowNotification(tableView) { (keyboardSize) in
 print("size 1 - \(keyboardSize!)")
 }
 registerForKeyboardWillHideNotification(tableView) { (keyboardSize) in
 print("size 2 - \(keyboardSize!)")
 }
 
 }
 */



