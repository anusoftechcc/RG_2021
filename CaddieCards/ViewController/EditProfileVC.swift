//
//  EditProfileVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 17/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class EditProfileVC: BaseViewController,UITextFieldDelegate,HomeCourseDelegateProtocol {
    
    var profileDataArray = ProfileModel(JSONString: "")
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtFiled: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var handicapBtn: UIButton!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var homeCourseBtn: UIButton!
    @IBOutlet weak var rightHandedBtn: UIButton!
    @IBOutlet weak var leftHandedBtn: UIButton!
    @IBOutlet weak var averageScoreBtn: UIButton!
    
    @IBOutlet var lineLblArray: [UILabel]!
    
    var handicapArray = [String]()
    var scoresArray = [String]()
    var gender : String = ""
    var handicap :  String = ""
    var score :  String = ""
    var phoneNo: String = ""
    var handed: String = ""
    var dictToSave = [String: String]()
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveBtnTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        gender = self.profileDataArray?.gender ?? ""
        handicap = self.profileDataArray?.handiCap ?? ""
        handicapArray = handicapValues() as! [String]
        phoneNo = self.profileDataArray?.phone ?? ""
        score = self.profileDataArray?.averageScore ?? ""
        scoresArray = scoreValues() as! [String]
        handed = self.profileDataArray?.handed ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.layoutIfNeeded()
        let layer = scrollView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPersonalDetail()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    // MARK: - Personal Details loading Method
    func loadPersonalDetail() {
        
        firstNameTxtField.text = profileDataArray?.firstName ?? ""
        lastNameTxtField.text = profileDataArray?.lastName ?? ""
        phoneTxtFiled.text = profileDataArray?.phone ?? ""
        if profileDataArray?.gender == "male" {
            maleBtn.setTitle("Male", for: .normal)
            maleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            femaleBtn.setTitle("Female", for: .normal)
            femaleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        }else {
            maleBtn.setTitle("Male", for: .normal)
            maleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            femaleBtn.setTitle("Female", for: .normal)
            femaleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        }
        let dobStr : String = profileDataArray?.dob ?? ""
        let dobStrArr : [String] = dobStr.components(separatedBy: " ")
        let dobFirstStr : String = dobStrArr[0]
        dobTxtField.text = dobFirstStr
        handicapBtn.setTitle(profileDataArray?.handiCap ?? "", for: .normal)
        homeCourseBtn.setTitle(profileDataArray?.homeCourse ?? "", for: .normal)
        averageScoreBtn.setTitle(profileDataArray?.averageScore ?? "", for: .normal)
        if profileDataArray?.handed == "right" {
            rightHandedBtn.setTitle("Right", for: .normal)
            rightHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            leftHandedBtn.setTitle("Left", for: .normal)
            leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        } else  if profileDataArray?.handed == "left" {
            rightHandedBtn.setTitle("Right", for: .normal)
            rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            leftHandedBtn.setTitle("Left", for: .normal)
            leftHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        } else {
            rightHandedBtn.setTitle("Right", for: .normal)
            rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            leftHandedBtn.setTitle("Left", for: .normal)
            leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        }
    }
    //MARK: - Delegate Method
    func sendCourseNameToCreteGameVC(courseName: String) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if courseName != "" {
        self.homeCourseBtn.setTitle(courseName, for: .normal)
        }
    }
    //MARK: - Button Action Methods
    @IBAction func handicapBtnTapped(_ sender: Any) {
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
    
    @IBAction func rightHandedBtnTapped(_ sender: Any) {
        leftHandedBtn.isSelected = false
        rightHandedBtn.setTitle("Right", for: .normal)
        if rightHandedBtn.isSelected {
            rightHandedBtn.isSelected = false
            rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            handed = ""
            
        } else {
            rightHandedBtn.isSelected = true
            rightHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            handed = "right"
        }
        
        leftHandedBtn.setTitle("Left", for: .normal)
        leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
    }
    
    @IBAction func leftHandedBtnTapped(_ sender: Any) {
        rightHandedBtn.isSelected = false
        leftHandedBtn.setTitle("Left", for: .normal)
        if leftHandedBtn.isSelected {
            leftHandedBtn.isSelected = false
            leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            handed = ""
            
        } else {
            leftHandedBtn.isSelected = true
            leftHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            handed = "left"
        }
        
        rightHandedBtn.setTitle("Right", for: .normal)
        rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
    }
    
    @IBAction func averageScoreBtnTapped(_ sender: Any) {
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
                                    with: self.scoresArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.averageScoreBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
                                        self.score = self.scoresArray[selectedIndex]
                                        
        }) {
        }
    }
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        femaleBtn.isSelected = false
        maleBtn.setTitle("Male", for: .normal)
        if maleBtn.isSelected {
            maleBtn.isSelected = false
            maleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            gender = ""
            
        } else {
            maleBtn.isSelected = true
            maleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            gender = "male"
        }
        
        femaleBtn.setTitle("Female", for: .normal)
        femaleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
    }
    
    @IBAction func homeCourseBtnTapped(_ sender: Any) {
        let controller:HomeCourseNamesVC =
            self.storyboard!.instantiateViewController(withIdentifier: "HomeCourseNamesVC") as!
        HomeCourseNamesVC
        controller.delegate = self
        controller.view.frame = self.view.bounds;
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    
    @IBAction func femaleBtnTapped(_ sender: Any) {
        maleBtn.isSelected = false
        femaleBtn.setTitle("Female", for: .normal)
        if femaleBtn.isSelected {
            femaleBtn.isSelected = false
            femaleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            gender = ""
            
        } else {
            femaleBtn.isSelected = true
            femaleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            gender = "female"
        }
        
        maleBtn.setTitle("Male", for: .normal)
        maleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
    }
    
    @objc func saveBtnTapped() {
        
        guard let firstName = self.firstNameTxtField.text, firstName.count > 0, firstName.whiteSpaceBeforeString(name: self.firstNameTxtField.text!) else {
            self.errorAlert("Please enter your first name")
          //  self.show(message: "Please enter your first name", controller: self)
            return
        }
        guard let lastName = self.lastNameTxtField.text, lastName.count > 0, lastName.whiteSpaceBeforeString(name: self.lastNameTxtField.text!) else {
            self.errorAlert("Please enter your last name")
          //  self.show(message: "Please enter your last name", controller: self)
            return
        }
//        guard let dob = self.dobTxtField.text, dob.count > 0 else {
//            self.errorAlert("Please select your date of birth")
//          //  self.show(message: "Please select your date of birth", controller: self)
//            return
//        }
//        guard let phNo = self.phoneTxtFiled.text, phNo.count > 0, phNo.whiteSpaceBeforeString(name: self.phoneTxtFiled.text!) else {
//            self.errorAlert("Please enter phone number")
//          //  self.show(message: "Please enter phone number", controller: self)
//            return
//        }
//        if self.gender == "" {
//            self.errorAlert("Please select your gender")
//           // self.show(message: "Please select your gender", controller: self)
//            return
//        }
//        else if self.handicap == "" {
//            self.errorAlert("Please select your handicap")
//          //  self.show(message: "Please select your handicap", controller: self)
//            return
//        }else
           self.phoneNo = self.phoneTxtFiled.text ?? ""
            if self.phoneNo.count > 0, self.phoneNo.count < 10 {
            self.errorAlert("Please enter a 10 digit phone number")
          //  self.show(message: "Please enter a 10 digit phone number", controller: self)
            return
        }
        
        var age:String = ""
        var dob: String = self.dobTxtField.text ?? ""
        if dob.count > 0 {
            age = self.calcAge(birthday: dob)
        }
       // let age:String = self.calcAge(birthday: dob)
        //Modified by andy dev 031919 6:15pm
        
        //  let customerId: String = self.profileDataArray?.customerId ?? ""
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let oldPwd: String = self.profileDataArray?.password ?? ""
        let userName: String = self.profileDataArray?.userName ?? ""
        
        let courcesArray = NSMutableArray()
        let courceDict = NSMutableDictionary()
        for course in (self.profileDataArray?.courseNames)! {
            courceDict.setValue(course.courseName, forKey: "CourseName")
            courcesArray.add(courceDict)
        }
        print("Cources Array = \(courcesArray)")
        if handicap == "No" {
            handicap = ""
        }
        var homeCourse = ""
        if let text = homeCourseBtn.titleLabel?.text {
            print(text)
            homeCourse = text
        }
        
        let params: Parameters = [
            "CustomerId": customeId,
            "UserName": userName,
            "Password": oldPwd,
            "FirstName": firstName,
            "LastName": lastName,
            "DOB": dob,
            "Age": age,
            "Phone": phoneNo,
            "Gender": gender,
            "HandiCap": handicap,
            "Handed": handed,
            "HomeCourse": homeCourse,
            "AverageScore": score,
            "Address1": profileDataArray?.address1 ?? "",
            "Address2": profileDataArray?.address2 ?? "",
            "City": profileDataArray?.city ?? "",
            "State": profileDataArray?.state ?? "",
            "Zip": profileDataArray?.zip ?? "",
            "CourseNames": courcesArray
        ]
        print("Edit profile Parameters = \(params)")
        
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
                  //  self.show(message: message!, controller: self)
                    return
                }
                print("Edit profile Responce = \(response.responseDictionary)")
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
        if txtTag < 704 {
            lineLblArray[txtTag-700].backgroundColor = GlobalConstants.EDITPROFILELINECOLOR
        }
        if textField == phoneTxtFiled {
            self.addDoneButtonOnNumpad(textField: textField)
        }else if textField == dobTxtField {
            pickerViewSetup()
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
                //self.errorAlert("Please enter valid phone number")
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTxtField {
            self.lastNameTxtField.becomeFirstResponder()
        }else if textField == lastNameTxtField {
            self.dobTxtField.becomeFirstResponder()
        }else if textField == dobTxtField {
            self.phoneTxtFiled.becomeFirstResponder()
        }else if textField == phoneTxtFiled {
            self.phoneTxtFiled.resignFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom Methods
    func handicapValues() -> NSArray {
        var array = [String]()
        array.append("No")
        for i in 0...36 {
            array.append(String(i))
        }
        return array as NSArray
    }
    func scoreValues() -> NSArray {
        var array = [String]()
        for i in 72...108 {
            array.append(String(i))
        }
        return array as NSArray
    }
    private func pickerViewSetup() {
        
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0.0, y:UIScreen.main.bounds.height-200, width:pickerSize.width, height:200)
        picker.backgroundColor = UIColor.white
        dobTxtField.inputView = picker
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))]
        numberToolbar.sizeToFit()
        dobTxtField.inputAccessoryView = numberToolbar
        
    }
    @objc func doneClick() {
        dobTxtField.resignFirstResponder()
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // dobBtn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        dobTxtField.text = dateFormatter.string(from: sender.date)
    }
    func calcAge(birthday: String) -> String {
        
        //Modified by andy dev 03232019 5:22pm
        //added this code  to avoid crash when sending data to server.
        var dob: String=""
        let dateArr = birthday.components(separatedBy: " ")
        
        if(dateArr.count>0){
            dob = dateArr[0]
        }else{
            dob=birthday
        }
        print("dob::",dob)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        
        let birthdayDate = dateFormater.date(from: dob)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        //Modified by andy dev 031919 5:58pm
        //This age calculation crashes the app as you are not formatting the date data that you got from the service response
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        
        return String(age!)
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
