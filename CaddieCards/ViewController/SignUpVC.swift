//
//  SignUpVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class SignUpVC: BaseViewController,UITextFieldDelegate,UITextViewDelegate,HomeCourseDelegateProtocol {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var address1TxtField: UITextField!
    @IBOutlet weak var address2TxtField: UITextField!
    @IBOutlet weak var zipCodeTxtField: UITextField!
    @IBOutlet weak var stateTxtFiled: UITextField!
    @IBOutlet weak var phoneTxtFiled: UITextField!
    @IBOutlet weak var cityTxtFiled: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var rightHandBtn: UIButton!
    @IBOutlet weak var leftHandBtn: UIButton!
    @IBOutlet weak var handicapBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var HomeCourseTxtView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet var txtFiledLineLbl: [UILabel]!
    var handicapArray = [String]()
    var scoresArray = [String]()
    
    var gender : String = ""
    var handed : String = ""
    var phoneNo: String = ""
    var handicap :  String = ""
    var score :  String = ""
    var zipTF = Bool()
    var dictSocialLogin = [String: String]()
    var isFromScocialLogin = Bool()
    var statesArray = NSMutableArray()
    var statesArray2 = [String]()
    
    @IBOutlet weak var scoreView_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreDW: UIImageView!
    @IBOutlet weak var scoreView_ToplayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dobTxtField: UITextField!
    
    @IBOutlet weak var calendarImgView: UIImageView!
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SIGN UP"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!]
        
        
        handicapArray = handicapValues() as! [String]
        scoresArray = scoreValues() as! [String]
        maleBtn.cornerRadius = 5.0
        maleBtn.borderWidth = 1.0
        maleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        maleBtn.clipsToBounds = true
        
        femaleBtn.cornerRadius = 5.0
        femaleBtn.borderWidth = 1.0
        femaleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        femaleBtn.clipsToBounds = true
        
        rightHandBtn.cornerRadius = 5.0
        rightHandBtn.borderWidth = 1.0
        rightHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        rightHandBtn.clipsToBounds = true
        
        leftHandBtn.cornerRadius = 5.0
        leftHandBtn.borderWidth = 1.0
        leftHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        leftHandBtn.clipsToBounds = true
        
        dobBtn.cornerRadius = 5.0
        dobBtn.borderWidth = 1.0
        dobBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        dobBtn.clipsToBounds = true
        
//        let maleImage = UIImage(named: "male_icon");
//        let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        maleBtn.setImage(mtintedImage, for: .normal)
//        maleBtn.tintColor = GlobalConstants.APPCOLOR
//        maleBtn.setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
        
//        let rightHImage = UIImage(named: "golfer_right_hand");
//        let rtintedImage = rightHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        rightHandBtn.setImage(rtintedImage, for: .normal)
//        rightHandBtn.tintColor = GlobalConstants.APPCOLOR
//        rightHandBtn.setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
//
        for label in txtFiledLineLbl
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        self.handicapBtn.setTitle("Select Handicap", for: .normal)
        gender = ""
        handed = ""
        self.handicap = "Select Handicap"
        score = "Select Average Score"
        
        HomeCourseTxtView.text = "No Home Course"
        //HomeCourseTxtView.textColor = UIColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        callStatesApi()
        

        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
        } else {
            print("Dark mode")
            let maleImage = UIImage(named: "male_icon");
            let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            maleBtn.setImage(mtintedImage, for: .normal)
            maleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
            maleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
            maleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
            
            let femaleImage = UIImage(named: "female_icon");
            let ftintedImage = femaleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            femaleBtn.setImage(ftintedImage, for: .normal)
            femaleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
            femaleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
            femaleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
            
            let rightHImage = UIImage(named: "golfer_right_hand");
            let rtintedImage = rightHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            rightHandBtn.setImage(rtintedImage, for: .normal)
            rightHandBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
            rightHandBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
            rightHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
            
            let leftHImage = UIImage(named: "golfer_left_hand_icon");
            let ltintedImage = leftHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            leftHandBtn.setImage(ltintedImage, for: .normal)
            leftHandBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
            leftHandBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
            leftHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
            
        }
        
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            super.traitCollectionDidChange(previousTraitCollection)
//            if traitCollection.userInterfaceStyle == .dark {
//                let maleImage = UIImage(named: "male_icon");
//                let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//                maleBtn.setImage(mtintedImage, for: .normal)
//                maleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                maleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
//                maleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                
//                let femaleImage = UIImage(named: "female_icon");
//                let ftintedImage = femaleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//                femaleBtn.setImage(ftintedImage, for: .normal)
//                femaleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                femaleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
//                femaleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
//            }
//            else {
//                let maleImage = UIImage(named: "male_icon");
//                let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//                maleBtn.setImage(mtintedImage, for: .normal)
//                maleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                maleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
//                maleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                
//                let femaleImage = UIImage(named: "female_icon");
//                let ftintedImage = femaleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//                femaleBtn.setImage(ftintedImage, for: .normal)
//                femaleBtn.tintColor = .black
//                femaleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
//                femaleBtn.borderColor = .black
//                
//                let rightHImage = UIImage(named: "golfer_right_hand");
//                let rtintedImage = rightHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//                rightHandBtn.setImage(rtintedImage, for: .normal)
//                rightHandBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                rightHandBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
//                rightHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
//                
//            }
//        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        if isFromScocialLogin == true {
            emailTxtField.text = dictSocialLogin["email"]
            firstNameTxtField.text = dictSocialLogin["givenName"]
            lastNameTxtField.text = dictSocialLogin["familyName"]
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    override func viewDidLayoutSubviews() {
    }
    
    func callStatesApi() {
        
        ApiCall.postServercall(onView:self, url: MyStrings().getStatesUrl, httpMethod: .get, loading: self) { (response) in
            
            if(response.isSuccess){
                print(response as Any)
                
                let isError = response.isSuccess
                print(isError)
                guard isError == true else {
                    let message = response.responseDictionary["ErrorMessage"] as? String
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
    
    //MARK: - Button Action Methods
    @IBAction func maleBtnTapped(_ sender: UIButton) {
        femaleBtn.isSelected = false
        let femaleImage = UIImage(named: "female_icon");
        let ftintedImage = femaleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        femaleBtn.setImage(ftintedImage, for: .normal)
        femaleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
        femaleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
        femaleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        
        let maleImage = UIImage(named: "male_icon");
        let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        maleBtn.setImage(mtintedImage, for: .normal)
        if maleBtn.isSelected {
            gender = ""
            maleBtn.isSelected = false
            selectButtonAction(isSelected: false, sender: maleBtn)
        } else {
            gender = "male"
            maleBtn.isSelected = true
           selectButtonAction(isSelected: true, sender: maleBtn)
        }
    }
    
    func selectButtonAction(isSelected: Bool, sender: UIButton) {
        if isSelected {
            sender.tintColor = GlobalConstants.APPCOLOR
            sender.setTitleColor(GlobalConstants.APPCOLOR, for: .normal)
            sender.borderColor = GlobalConstants.APPCOLOR
        } else {
            sender.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
            sender.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
            sender.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        
    }
    @IBAction func femaleBtnTapped(_ sender: UIButton) {
        maleBtn.isSelected = false
        let maleImage = UIImage(named: "male_icon");
        let mtintedImage = maleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        maleBtn.setImage(mtintedImage, for: .normal)
        maleBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
        maleBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
        maleBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        
        let femaleImage = UIImage(named: "female_icon");
        let ftintedImage = femaleImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        femaleBtn.setImage(ftintedImage, for: .normal)
        if sender.isSelected {
            gender = ""
            sender.isSelected = false
            selectButtonAction(isSelected: false, sender: sender)
        } else {
            gender = "female"
            sender.isSelected = true
            selectButtonAction(isSelected: true, sender: sender)
        }
    }
    @IBAction func dobBtnTapped(_ sender: Any) {
        // pickerViewSetup()
    }
    @IBAction func rightHandBtnTapped(_ sender: Any) {
        leftHandBtn.isSelected = false
        let rightHImage = UIImage(named: "golfer_right_hand");
        let rtintedImage = rightHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        rightHandBtn.setImage(rtintedImage, for: .normal)
        if rightHandBtn.isSelected {
             handed = ""
            rightHandBtn.isSelected = false
            selectButtonAction(isSelected: false, sender: rightHandBtn)
        } else {
            handed = "right"
            rightHandBtn.isSelected = true
            selectButtonAction(isSelected: true, sender: rightHandBtn)
        }
        
        let leftHImage = UIImage(named: "golfer_left_hand_icon");
        let ltintedImage = leftHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        leftHandBtn.setImage(ltintedImage, for: .normal)
        leftHandBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
        leftHandBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
        leftHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
    
    }
    @IBAction func leftHandBtnTapped(_ sender: Any) {
        rightHandBtn.isSelected = false
        let rightHImage = UIImage(named: "golfer_right_hand");
        let rtintedImage = rightHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        rightHandBtn.setImage(rtintedImage, for: .normal)
        rightHandBtn.tintColor = GlobalConstants.APPLIGHTGRAYCOLOR
        rightHandBtn.setTitleColor(GlobalConstants.APPLIGHTGRAYCOLOR, for: .normal)
        rightHandBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
        
        let leftHImage = UIImage(named: "golfer_left_hand_icon");
        let ltintedImage = leftHImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        leftHandBtn.setImage(ltintedImage, for: .normal)
        if leftHandBtn.isSelected {
            handed = ""
            leftHandBtn.isSelected = false
            selectButtonAction(isSelected: false, sender: leftHandBtn)
        } else {
            handed = "left"
            leftHandBtn.isSelected = true
            selectButtonAction(isSelected: true, sender: leftHandBtn)
        }
    }
    
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
                                        if self.handicapArray[selectedIndex] != "Select Handicap" {
                                            self.scoreView_ToplayoutConstraint.constant = 0
                                            self.scoreView_HeightConstraint.constant = 0
                                            self.scoreBtn.isHidden = true
                                            self.scoreDW.isHidden = true
                                            self.score = ""
                                        }else {
                                            self.scoreView_ToplayoutConstraint.constant = 20
                                            self.scoreView_HeightConstraint.constant = 45
                                            self.scoreBtn.isHidden = false
                                            self.scoreDW.isHidden = false
                                        }
                                        
        }) {
            
        }
    }
    @IBAction func scoreBtnTapped(_ sender: Any) {
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
        cellConfi.textAlignment = .center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.scoresArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.scoreBtn.setTitle(self.scoresArray[selectedIndex], for: .normal)
                                        self.score = self.scoresArray[selectedIndex]
                                        
        }) {
            
        }
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
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard let emailid = emailTxtField.text, emailid.count > 0, emailid.isValidEmail() else {
            self.errorAlert("Please enter valid email")
            // self.show(message: "Please enter valid email", controller: self)
            return
        }
        self.userExistCheckingWS(emailId: emailid)
        
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
        zipTF = false
        for label in txtFiledLineLbl
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        let txtTag: Int = textField.tag
        if txtTag < 512 {
            txtFiledLineLbl[txtTag-500].backgroundColor = GlobalConstants.APPCOLOR
        }
        if textField == zipCodeTxtField {
            self.addDoneButtonOnNumpad(textField: textField)
            zipTF = true
        }else if textField == phoneTxtFiled {
            self.addDoneButtonOnNumpad(textField: textField)
        }else if textField == dobTxtField {
            dobBtn.borderColor = GlobalConstants.APPCOLOR
            calendarImgView.tintColor = GlobalConstants.APPCOLOR
            pickerViewSetup()
        }else  if textField == stateTxtFiled  {
            cityTxtFiled.resignFirstResponder()
            textField.resignFirstResponder()
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
            FTPopOverMenu.showForSender(sender: stateTxtFiled as! UIView,
                                        with: self.statesArray2 as! [String],
                                        done: { (selectedIndex) -> () in
                                            print(selectedIndex)
                                            self.stateTxtFiled.text = self.statesArray2[selectedIndex] as! String
                                            textField.resignFirstResponder()
                                            self.zipCodeTxtField.text = ""
                                            self.cityTxtFiled.text = ""
                                            
            }) {
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == zipCodeTxtField {
            self.zipCodeDetailsWS(zipCode: zipCodeTxtField.text!)
        }else if textField == phoneTxtFiled {
            let currentString = textField.text!
            let test = String(currentString.filter { !" ()-".contains($0) })
            // phoneTxtFiled.text = self.phoneNumberFormate(phNo: phoneNo)
            if test.count > 0 && test.count == 10 {
                phoneNo = test as String
            } else if test.count > 0 && test.count < 10 {
                self.errorAlert("Please enter valid phone number")
            }
//            else {
//                self.errorAlert("Please enter valid phone number")
//            }
        }else if textField == stateTxtFiled {
            textField.resignFirstResponder()
        }else if textField == cityTxtFiled {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cityTxtFiled  {
            textField.resignFirstResponder()
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == stateTxtFiled  {
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxtField {
            self.passwordTxtField.becomeFirstResponder()
        }else if textField == passwordTxtField {
            self.confirmPwdTxtField.becomeFirstResponder()
        }else if textField == confirmPwdTxtField {
            self.firstNameTxtField.becomeFirstResponder()
        }else if textField == firstNameTxtField {
            self.lastNameTxtField.becomeFirstResponder()
        }else if textField == lastNameTxtField {
            self.address1TxtField.becomeFirstResponder()
        }else if textField == address1TxtField {
            self.address2TxtField.becomeFirstResponder()
        }else if textField == address2TxtField {
            self.zipCodeTxtField.becomeFirstResponder()
        }else if textField == cityTxtFiled {
            self.stateTxtFiled.resignFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            HomeCourseTxtView.text = "No Home Course"
            //HomeCourseTxtView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //MARK: - Delegate Method
    func sendCourseNameToCreteGameVC(courseName: String) {
        if courseName != "" {
            // self..setTitle(courseName, for: .normal)
            self.HomeCourseTxtView.text = courseName
            self.HomeCourseTxtView.textColor = UIColor.darkText
        }
    }
    
    //MARK: - Zip Code web service
    
    func zipCodeDetailsWS(zipCode : String) {
        
        let urlString :  String =  MyStrings().zipCodeUrl + "\(zipCodeTxtField.text ?? "")"
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.getServercall(onView: self, isBody: true, urlString: urlString) { (response) in
            print(response as Any)
            
            if response.object(forKey: "State") != nil {
                self.stateTxtFiled.text = response.object(forKey: "State") as? String
                self.cityTxtFiled.text = response.object(forKey: "City") as? String
            }
            
        }
    }
    func userExistCheckingWS(emailId : String) {
        
        let urlString :  String =  MyStrings().userExistUrl + "\(emailId)"

        ApiCall.getServerCallUserExist(onView: self, isBody: true, urlString: urlString) { (response) in
            print(response as Any)

            let resultStr: String = response
            if resultStr == "" {
                
                if self.firstNameTxtField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    // string contains non-whitespace characters
                    self.errorAlert("Please enter your first name")
                    // self.show(message: "Please enter your first name", controller: self)
                    return
                }
                
                guard let firstName = self.firstNameTxtField.text, firstName.count > 0, firstName.whiteSpaceBeforeString(name: self.firstNameTxtField.text!) else {
                    self.errorAlert("Please enter your first name")
                    //  self.show(message: "Please enter your first name", controller: self)
                    return
                }
                guard let lastName = self.lastNameTxtField.text, lastName.count > 0, lastName.whiteSpaceBeforeString(name: self.lastNameTxtField.text!) else {
                    self.errorAlert("Please enter your last name")
                    // self.show(message: "Please enter your last name", controller: self)
                    return
                }
                guard let address = self.address1TxtField.text, address.count > 0, address.whiteSpaceBeforeString(name: self.address1TxtField.text!) else {
                    self.errorAlert("Please enter your address")
                    // self.show(message: "Please enter your address", controller: self)
                    return
                }
                guard let zipCode = self.zipCodeTxtField.text, zipCode.count > 0, zipCode.whiteSpaceBeforeString(name: self.zipCodeTxtField.text!) else {
                    self.errorAlert("Please enter zip code")
                    //  self.show(message: "Please enter zip code", controller: self)
                    return
                }
                guard let cityName = self.cityTxtFiled.text, cityName.count > 0, cityName.whiteSpaceBeforeString(name: self.cityTxtFiled.text!) else {
                    self.errorAlert("Please enter city name")
                    // self.show(message: "Please enter city name", controller: self)
                    return
                }
                guard let stateName = self.stateTxtFiled.text, stateName.count > 0, stateName.whiteSpaceBeforeString(name: self.stateTxtFiled.text!) else {
                    self.errorAlert("Please enter state name")
                    //  self.show(message: "Please enter state name", controller: self)
                    return
                }
                guard let pwd = self.passwordTxtField.text, pwd.count > 0, pwd.whiteSpaceBeforeString(name: self.passwordTxtField.text!) else {
                    self.errorAlert("Please enter password")
                    //   self.show(message: "Please enter password", controller: self)
                    return
                }
                guard let confirmPwd = self.confirmPwdTxtField.text, confirmPwd.count > 0, confirmPwd.whiteSpaceBeforeString(name: self.confirmPwdTxtField.text!) else {
                    self.errorAlert("Please enter confirm password")
                    //  self.show(message: "Please enter confirm password", controller: self)
                    return
                }
                
               if (self.passwordTxtField.text != self.confirmPwdTxtField.text) || (self.passwordTxtField.text == "" || self.confirmPwdTxtField.text == "")  {
                    if self.passwordTxtField.text != self.confirmPwdTxtField.text {
                        self.errorAlert("Password and Confirm Password are mismatch")
                        //  self.show(message: "Password and Confirm Password are mismatch", controller: self)
                    }else if self.passwordTxtField.text == "" {
                        self.errorAlert("Please enter password")
                        //  self.show(message: "Please enter password", controller: self)
                    }else {
                        self.errorAlert("Please enter confirm password")
                        //  self.show(message: "Please enter confirm password", controller: self)
                    }
                    return
                }
//               else if self.gender == "" {
//                    self.errorAlert("Please select your gender")
//                    // self.show(message: "Please select your gender", controller: self)
//                    return
//                }
//               else if self.handed == "" {
//                    self.errorAlert("Please select your handed")
//                    // self.show(message: "Please select your hande", controller: self)
//                    return
//                }
               else if self.phoneNo.count > 0, self.phoneNo.count < 10 {
                    self.errorAlert("Please enter a 10 digit phone number")
                    //  self.show(message: "Please enter a 10 digit phone number", controller: self)
                    return
               } else if self.handicap == "Select Handicap" {
                    self.errorAlert("Please Select handicap")
                    return
                }
                var homeCourse: String = self.HomeCourseTxtView.text!
//                if homeCourse == "No Home Course" {
//                    homeCourse = ""
//                }
                
                let address2: String = self.address2TxtField.text!
                let password: String = self.passwordTxtField.text!
                var age:String = ""
                var dob: String = self.dobTxtField.text ?? ""
                if dob.count > 0 {
                    age = self.calcAge(birthday: dob)
                }
                
                if self.score == "Select Average Score" {
                    self.score = ""
                }
                
                let params: Parameters = [
                    "DOB": dob,
                    "Address1": address,
                    "Address2": address2,
                    "Age": age,
                    "City": cityName,
                    "FirstName": firstName as String,
                    "Gender": self.gender,
                    "Handed": self.handed,
                    "HandiCap": self.handicap,
                    "HomeCourse": homeCourse,
                    "LastName": lastName,
                    "Password": password,
                    "Phone": self.phoneNo,
                    "State":stateName ,
                    "UserName": emailId,
                    "Zip": zipCode,
                    "AverageScore": self.score,
                    "IP_Address":"",
                    "Fwd_IP_Address1":"",
                    "Fwd_IP_Address2":""
                ]
                print(params)
                
                self.startLoadingIndicator(loadTxt: "Loading...")
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().registerUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    //Modified by andydev 03232019 5:43pm
                    //Added if conidtion to avoid crash when reqest to the server failed to fetch the data
                    
                    if(response.isSuccess){
                        
                        let message = response.responseDictionary["ErrorMessage"] as? String
                        print(message as Any)
                        let isError = response.responseDictionary["IsError"] as! Bool
                        print(isError)
                        guard isError == false else {
                            return
                        }
                        print(response.responseDictionary)
                        let dict = response.responseDictionary
                        
                        let ResdataDict = ["userid":dict["CustomerId"]!,"UserName":dict["UserName"]!,"FirstName":dict["FirstName"] ?? "","AccessToken":dict["AccessToken"]!,"LastName":dict["LastName"] ?? ""]
                        UserDefaults.standard.setValue(ResdataDict, forKey: "userData")
                        UserDefaults.standard.setValue(dict["CustomerId"]!, forKey: "CustomerId")
                        UserDefaults.standard.setValue(self.emailTxtField.text!, forKey: "CustomerEmail")
                        UserDefaults.standard.synchronize()
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                        // let topVc = initialViewController.viewControllers[0] as! DashboardVC
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = initialViewController
                    }
                }
            }else {
                self.errorAlert("User already exists")
                // self.show(message: "User already exists", controller: self)
            }
            
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
        var nextTxt : String = "Done"
        if textField == zipCodeTxtField {
            nextTxt = "Next"
        }
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
        if zipTF == true {
            self.cityTxtFiled.becomeFirstResponder()
        }else {
            self.phoneTxtFiled.resignFirstResponder()
        }
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
    func scoreValues() -> NSArray {
        var array = [String]()
        array.append("Select Average Score")
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
        if dobTxtField.text == "" {
            dobBtn.borderColor = GlobalConstants.APPLIGHTGRAYCOLOR
            calendarImgView.tintColor = UIColor.lightGray
        }
    }
    func calcAge(birthday: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
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

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
