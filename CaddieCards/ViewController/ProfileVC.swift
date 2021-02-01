//
//  ProfileVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileSelectBtn: UIButton!
    @IBOutlet weak var profileTV: UITableView!
    var profileDataArray = ProfileModel(JSONString: "")
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var playerIdLbl: UILabel!
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.isHidden = true
        
        if let  imageData = UserDefaults.standard.object(forKey: "ProfilePicData") as? Data
        {
            if let image = UIImage(data: imageData)
            {
                //set image in UIImageView imgSignature
                profileImgView.image = image
            }
        }
        
        profileTV.delegate = self
        profileTV.dataSource = self
        profileTV.register(UINib(nibName: "PersonalDetailsTVCell", bundle: nil), forCellReuseIdentifier: "PersonalDetailsTVCell")
        profileTV.register(UINib(nibName: "ChangePwdTVCell", bundle: nil), forCellReuseIdentifier: "ChangePwdTVCell")
        profileTV.register(UINib(nibName: "ChangeAverageScoreTVCell", bundle: nil), forCellReuseIdentifier: "ChangeAverageScoreTVCell")
        profileTV.register(UINib(nibName: "AddressTVCell", bundle: nil), forCellReuseIdentifier: "AddressTVCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        getProfileDatafromServer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        profileImgView.cornerRadius = profileImgView.frame.size.height/2
        profileImgView.layer.borderColor = UIColor.white.cgColor
        profileImgView.layer.borderWidth = 1.0
        profileImgView.clipsToBounds = true
    }
    
    //MARK: - Button Action Methods
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editProfileBtnTapped(_ sender: Any) {
        let  alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let  cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)  {
            UIAlertAction in
            self.openCamera()
        }
        let   gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.openGallary()
        }
        let   cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func editPersonalDetailsBtnTapped(_ sender: UIButton) {
        //EditProfileNavId
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfVCObj = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        editProfVCObj.profileDataArray = self.profileDataArray
        self.navigationController?.pushViewController(editProfVCObj, animated: true)
    }
    
    @objc func changePwdBtnTapped(_ sender: UIButton) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cpwdVCObj = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        cpwdVCObj.profileDataArray = self.profileDataArray
        self.navigationController?.pushViewController(cpwdVCObj, animated: true)
    }
    @objc func avgScoreEditBtnTapped(_ sender: UIButton) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pPDEditVCObj = storyboard.instantiateViewController(withIdentifier: "ProfilePerDetailsEditVC") as! ProfilePerDetailsEditVC
        pPDEditVCObj.profileDataArray = self.profileDataArray
        pPDEditVCObj.isVCName = "avgScore"
        self.navigationController?.pushViewController(pPDEditVCObj, animated: true)
    }
    
    @objc func editAddressBtnTapped(_ sender: UIButton) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pPDEditVCObj = storyboard.instantiateViewController(withIdentifier: "ProfilePerDetailsEditVC") as! ProfilePerDetailsEditVC
        pPDEditVCObj.profileDataArray = self.profileDataArray
        pPDEditVCObj.isVCName = "address"
        self.navigationController?.pushViewController(pPDEditVCObj, animated: true)
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            self.errorAlert("Camera not available")
           // self.show(message: "Camera not available", controller: self)
        }
    }
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if profileDataArray?.customerId != nil {
            if indexPath.row == 0 {
                let pDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailsTVCell", for: indexPath) as! PersonalDetailsTVCell
                
                pDetailsCell.personalDetailsEditBtn.addTarget(self, action: #selector(editPersonalDetailsBtnTapped(_:)), for: .touchUpInside)
                
                pDetailsCell.firstNameLbl.text = profileDataArray?.firstName ?? ""
                pDetailsCell.lastNameLbl.text = profileDataArray?.lastName ?? ""
                if profileDataArray?.gender == "male" {
                    pDetailsCell.maleBtn.setTitle("Male", for: .normal)
                    pDetailsCell.maleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                    pDetailsCell.femaleBtn.setTitle("Female", for: .normal)
                    pDetailsCell.femaleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                }else {
                    pDetailsCell.maleBtn.setTitle("Male", for: .normal)
                    pDetailsCell.maleBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                    pDetailsCell.femaleBtn.setTitle("Female", for: .normal)
                    pDetailsCell.femaleBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                }
                let dobStr : String = profileDataArray?.dob ?? ""
                let dobStrArr : [String] = dobStr.components(separatedBy: " ")
                let dobFirstStr : String = dobStrArr[0]
                pDetailsCell.dobLbl.text = dobFirstStr
                pDetailsCell.emailLbl.text = profileDataArray?.userName ?? ""
                pDetailsCell.phoneNoLbl.text = profileDataArray?.phone ?? ""
                pDetailsCell.handicapLbl.text = profileDataArray?.handiCap ?? ""
                if profileDataArray?.homeCourse == "" {
                    pDetailsCell.homecourseLbl.text = "No Home Course"
                } else {
                    pDetailsCell.homecourseLbl.text = profileDataArray?.homeCourse ?? ""
                }
                pDetailsCell.averageScoreLbl.text = profileDataArray?.averageScore ?? ""
                
                if profileDataArray?.handed == "right" {
                    pDetailsCell.rightHandedBtn.setTitle("Right", for: .normal)
                    pDetailsCell.rightHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                    pDetailsCell.leftHandedBtn.setTitle("Left", for: .normal)
                    pDetailsCell.leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                } else  if profileDataArray?.handed == "left" {
                    pDetailsCell.rightHandedBtn.setTitle("Right", for: .normal)
                    pDetailsCell.rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                    pDetailsCell.leftHandedBtn.setTitle("Left", for: .normal)
                    pDetailsCell.leftHandedBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                } else {
                    pDetailsCell.rightHandedBtn.setTitle("Right", for: .normal)
                    pDetailsCell.rightHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                    pDetailsCell.leftHandedBtn.setTitle("Left", for: .normal)
                    pDetailsCell.leftHandedBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                }
                
                return pDetailsCell
            }
//            else if indexPath.row == 1 {
//                let avgScoreCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAverageScoreTVCell", for: indexPath) as! ChangeAverageScoreTVCell
//
//                avgScoreCell.avgScoreEditBtn.addTarget(self, action: #selector(avgScoreEditBtnTapped(_:)), for: .touchUpInside)
//                avgScoreCell.avgScoreLbl.text = profileDataArray?.averageScore ?? ""
//
//                return avgScoreCell
//            }
            else if indexPath.row == 1 {
                let addressCell = tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTVCell
                addressCell.address1Lbl.text = self.profileDataArray?.address1 ?? ""
                addressCell.address2Lbl.text = self.profileDataArray?.address2 ?? ""
                addressCell.cityLbl.text = self.profileDataArray?.city ?? ""
                addressCell.stateLbl.text = self.profileDataArray?.state ?? ""
                addressCell.zipCodeLbl.text = self.profileDataArray?.zip ?? ""
                
                addressCell.editAddressBtn.addTarget(self, action: #selector(editAddressBtnTapped(_:)), for: .touchUpInside)
                
                return addressCell
            } else {
                let changePwdCell = tableView.dequeueReusableCell(withIdentifier: "ChangePwdTVCell", for: indexPath) as! ChangePwdTVCell
                changePwdCell.changePwdBtn.addTarget(self, action: #selector(changePwdBtnTapped(_:)), for: .touchUpInside)
                changePwdCell.passwordLbl.text = "********"
                
                return changePwdCell
            }
        }else {
            if indexPath.row == 0 {
                let pDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailsTVCell", for: indexPath) as! PersonalDetailsTVCell
                return pDetailsCell
            }else {
                let changePwdCell = tableView.dequeueReusableCell(withIdentifier: "ChangePwdTVCell", for: indexPath) as! ChangePwdTVCell
                return changePwdCell
            }
        }
    }
    
    //MARK: - Web Service Methods
    func getProfileDatafromServer() {
        
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        let urlString :  String =  MyStrings().getProfileUrl + "\(custId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            
            print(response as Any)
            
            let isError = response.isSuccess
            print(isError)
            guard isError == true else {
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                self.errorAlert(message!)
               // self.show(message: message!, controller: self)
                return
            }
            print(response.responseDictionary)
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            //  let castData = MyProfileModel(JSONString: resStr)
            // self.profileDataArray =  castData?.Success)!
            self.profileDataArray = ProfileModel(JSONString: jsonString)
            
            self.playerIdLbl.text = "Player ID : \(custId)"
            
            
            self.profileTV.reloadData()
        }
    }
    func uploadImageWithAlamofire(upload:String,delete:String,image:UIImage) {
        self.startLoadingIndicator(loadTxt: "Loading...")
        // define parameters
        let customeId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let parameters: Parameters  = [
            "customerid": String(customeId),
            "upload": "yes"
        ]
        let filenameStr = String(customeId) + ".jpg"
        ApiCall.uploadImageRequest(onView:self,image: image, filenameStr: filenameStr, urlString: MyStrings().uploadProfilePicUrl, parameters: parameters as [String : AnyObject]) { (response) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if (response.isSuccess){
                if upload=="yes"{
                    let isError = response.responseDictionary["IsError"] as! Bool
                    print(isError)
                    guard isError == false else {
                        let errorMsg = response.responseDictionary["ErrorMessage"] as! String
                        self.errorAlert(errorMsg)
                        // self.show(message: errorMsg, controller: self)
                        return
                    }
                    let successMsg = response.responseDictionary["SuccessMessage"] as! String
                    let imageData = image.jpegData(compressionQuality: 1.0)
                    UserDefaults.standard.setValue(imageData, forKey: "ProfilePicData")
                    UserDefaults.standard.synchronize()
                    self.errorAlert(successMsg)
                    // self.show(message: successMsg, controller: self)
                }
            }else{
                self.errorAlert("Something went wrong,try again.")
                // self.show(message: "Something went wrong,try again.", controller: self)
            }
        }
    }
    
    //MARK: - ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!
        profileImgView.image = tempImage
        self.uploadImageWithAlamofire(upload:"yes",delete:"",image:tempImage)
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
}
