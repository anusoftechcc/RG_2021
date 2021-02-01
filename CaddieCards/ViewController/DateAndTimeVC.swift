//
//  DateAndTimeVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/06/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class DateAndTimeVC: BaseViewController, UITextFieldDelegate, SearchCourseDelegateProtocol {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    // var gameDict = NSDictionary()
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var dateSelected: Bool = false
    @IBOutlet weak var courseNameBtn: UIButton!
    @IBOutlet weak var teeDWBtn: UIButton!
    @IBOutlet weak var gameNameTxtField: UITextField!
    @IBOutlet weak var viewTeeDW: UIView!
    var gameId: NSNumber = 0
    var gameDict = EditGameModel(JSONString: "")
    var teeArr = NSMutableArray()
    let teeNamesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = "EDIT GAME VIEW"
        getGameDetailsWS(gameId: NSInteger(truncating: gameId))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillLayoutSubviews() {
        dateView.layer.cornerRadius = 5
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = GlobalConstants.APPCOLOR.cgColor
        dateView.clipsToBounds = true
        
        timeView.layer.cornerRadius = 5
        timeView.layer.borderWidth = 1
        timeView.layer.borderColor = GlobalConstants.APPCOLOR.cgColor
        timeView.clipsToBounds = true
        
        viewTeeDW.layer.cornerRadius = 5
        viewTeeDW.layer.borderWidth = 1
        viewTeeDW.layer.borderColor = GlobalConstants.APPCOLOR.cgColor
        viewTeeDW.clipsToBounds = true
    }
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == gameNameTxtField {
            return newLength <= 25
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == dateTxtField {
            dateSelected = true
            pickerViewSetup()
        }else {
            dateSelected = false
            pickerViewSetup()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Custom Methods
    private func pickerViewSetup() {
        
        let picker : UIDatePicker = UIDatePicker()
        if dateSelected == true {
            picker.datePickerMode = UIDatePicker.Mode.date
        }else {
            picker.datePickerMode = UIDatePicker.Mode.time
        }
        // picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0.0, y:UIScreen.main.bounds.height-200, width:pickerSize.width, height:200)
        picker.backgroundColor = UIColor.white
        if dateSelected == true {
            dateTxtField.inputView = picker
        }else {
            timeTxtField.inputView = picker
        }
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))]
        numberToolbar.sizeToFit()
        if dateSelected == true {
            dateTxtField.inputAccessoryView = numberToolbar
        }else {
            timeTxtField.inputAccessoryView = numberToolbar
        }
        
    }
    @objc func doneClick() {
        if dateSelected == true {
            dateTxtField.resignFirstResponder()
        }else {
            timeTxtField.resignFirstResponder()
        }
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        
        // dobBtn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        if dateSelected == true {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateTxtField.text = dateFormatter.string(from: sender.date)
        }else {
            dateFormatter.timeStyle = .short
            timeTxtField.text = dateFormatter.string(from: sender.date)
        }
    }
    //MARK: - Button Action Methods
    @IBAction func teeDWBtnTapped(_ sender: Any) {
        let configuration = FTConfiguration.shared
        let cellConfi = FTCellConfiguration()
        configuration.menuRowHeight = 40
        configuration.menuWidth =  300
        configuration.backgoundTintColor = UIColor.lightGray
        cellConfi.textColor = UIColor.white
        cellConfi.textFont = .systemFont(ofSize: 13)
        configuration.borderColor = UIColor.lightGray
        configuration.menuSeparatorColor = UIColor.white
        configuration.borderWidth = 0.5
        cellConfi.textAlignment = NSTextAlignment.center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.teeNamesArray as! [String],
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.teeDWBtn.setTitle(self.teeNamesArray[selectedIndex] as? String, for: .normal)
        }){
        }
    }
    @IBAction func courseBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let csVCObj = storyboard.instantiateViewController(withIdentifier: "CourseSearchVC") as! CourseSearchVC
        csVCObj.delegate = self
        self.navigationController?.pushViewController(csVCObj, animated: true)
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        guard let gameName = self.gameNameTxtField.text, gameName.count > 0 else
        {
            self.errorAlert("Please enter game name")
           // self.show(message: "Please enter game name", controller: self)
            return
        }
        guard let date = self.dateTxtField.text, date.count > 0, date.whiteSpaceBeforeString(name: self.dateTxtField.text!) else {
            self.errorAlert("Please select schedule date")
          //  self.show(message: "Please select schedule date", controller: self)
            return
        }
        guard let time = self.timeTxtField.text, time.count > 0, time.whiteSpaceBeforeString(name: self.timeTxtField.text!) else {
            self.errorAlert("Please select schedule time")
          //  self.show(message: "Please select schedule time", controller: self)
            return
        }
        var courseTitle = ""
        var teeTitle = ""
        
        if let text = courseNameBtn.titleLabel?.text {
            print(text)
            courseTitle = text
        }
        if let text = teeDWBtn.titleLabel?.text {
            print(text)
            teeTitle = text
        }
        
        let params: Parameters = [
            "CustomerId": userId,
            "GameId": NSInteger(truncating: gameId),
            "ScheduleDate": date,
            "ScheduleTime": time,
            "GameName": gameName,
            "CourseName": courseTitle,
            "TeeName": teeTitle
        ]
        print("Save Date and time Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().editGameDataUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - Delegate Method
    func sendCourseNameToCreteGameVC(courseName: String) {
        self.courseNameBtn.setTitle(courseName, for: .normal)
        self.getTeeNamesByCourseWS(courseName: courseName)
    }
    
    //MARK: - Web Service Methods
    func getGameDetailsWS(gameId: NSInteger) {
        
        let urlString :  String =  MyStrings().getSheduleEditGameUrl + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            if(response.isSuccess){
                print(response as Any)
                
                let isError = response.isSuccess
                print(isError)
                guard isError == true else {
                    let message = response.responseDictionary["ErrorMessage"] as? String
                    print(message as Any)
                    self.errorAlert(message!)
                    return
                }
                print(response.responseDictionary)
                let dict = response.responseDictionary
                
                let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                self.gameDict = EditGameModel(JSONString: jsonString)
                
                self.gameNameTxtField.text = self.gameDict?.gameName ?? ""
                self.dateTxtField.text = self.gameDict?.scheduleDate ?? ""
                self.timeTxtField.text = self.gameDict?.scheduleTime ?? ""
                self.courseNameBtn.setTitle(self.gameDict?.courseName ?? "", for: .normal)
                self.getTeeNamesByCourseWS(courseName: self.gameDict?.courseName ?? "")
                self.teeDWBtn.setTitle(self.gameDict?.teeName ?? "", for: .normal)
                self.teeDWBtn.setTitleColor(UIColor.black, for: .normal)
                
            }else {
            }
        }
    }
    func getTeeNamesByCourseWS(courseName : String) {
        
        let formattedString = courseName.replacingOccurrences(of: " ", with: "%20")
        let urlString :  String =  MyStrings().getTeeNamesUrl + "\(formattedString)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            
            print(response as Any)
            
            let isError = response.isSuccess
            print(isError)
            guard isError == true else {
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                self.errorAlert(message!)
                return
            }
            print(response.responseDictionary)
            let dict = response.customModel
            
            self.teeArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
            let teeDict  = self.teeArr[0] as! NSDictionary
            self.teeDWBtn.setTitle(teeDict["TeeName"] as? String ?? "", for: .normal)
            
            self.teeNamesArray.removeAllObjects()
            for tee in self.teeArr {
                let tDict  = tee as! NSDictionary
                self.teeNamesArray.add(tDict["TeeName"] as? String ?? "")
            }
            print("Tee Names Array = \(self.teeNamesArray)")
        }
    }
}
