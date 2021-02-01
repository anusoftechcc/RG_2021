//
//  CreateGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 16/05/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

class CreateGameVC: BaseViewController,UITextFieldDelegate,SearchCourseDelegateProtocol,SelectedMembersDelegateProtocol {
    
    @IBOutlet weak var gameNameSepLbl: UILabel!
    @IBOutlet weak var playNowSecConstrain: NSLayoutConstraint!
    @IBOutlet weak var playNowPrimaryConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var gameNameTxtField: UITextField!
    @IBOutlet weak var playNowBtn: UIButton!
    @IBOutlet weak var scheduleLaterBtn: UIButton!
    @IBOutlet weak var dateTimeView_Toplayout: NSLayoutConstraint!
    @IBOutlet weak var dateTimeView_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTimeView: UIView!
    
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    
    @IBOutlet weak var courseBtn: UIButton!
    
    @IBOutlet weak var searchFriendsView: UIView!
    @IBOutlet weak var searchFriendsBtn: UIButton!
    
    @IBOutlet weak var matchPlayBtn: UIButton!
    @IBOutlet weak var strokePlayBtn: UIButton!
    @IBOutlet weak var gameBtn: UIButton!
    @IBOutlet weak var caddieCards_Switch: UISwitch!
    // @IBOutlet weak var animals_Switch: UISwitch!
    @IBOutlet var lineLblArray: [UILabel]!
    @IBOutlet weak var teeBtn: UIButton!
    var teeArr = NSMutableArray()
    
    var dictToSave = [String: String]()
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    var profileDataArray = GameViewDetailsModel(JSONString: "")
    
    let groupsArray = NSMutableArray()
    let coursesArray = NSMutableArray()
    let gameNamesArray = NSMutableArray()
    let caddieCardsArray = NSMutableArray()
    let teeNamesArray = NSMutableArray()
    var scoreType: Bool = false
    var playNow: Bool = false
    var dateSelected: Bool = false
    var scheduledLater: Bool = false
    
    var isGroupSelection: Bool = false
    var isPermanent: Bool = false
    var isCaddieCards : Bool = false
    var isCourseTapped : Bool = false
    var isAnimals : String = "Off"
    var membersStr: String = ""
    
    @IBOutlet weak var teeBView: UIView!
    @IBOutlet weak var teeBView_Toplayout: NSLayoutConstraint!
    @IBOutlet weak var teeBView_HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pressBView: UIView!
    @IBOutlet weak var pressBView_Toplayout: NSLayoutConstraint!
    @IBOutlet weak var pressBView_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pressBtn: UIButton!
    
    var isEditVC : Bool = false
    var isReplayVC : Bool = false
    var editReplayGameId: NSNumber = 0
    var editOrReplayDict = EditOrReplayGameModel(JSONString: "")
    var  groupDetailsArr = NSMutableArray()
    
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var groupsView_Toplayout: NSLayoutConstraint!
    @IBOutlet weak var groupsView_HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectMembers_Toplayout: NSLayoutConstraint!
    @IBOutlet weak var selectMembers_HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var animalOffBtn: UIButton!
    @IBOutlet weak var animalBasicBtn: UIButton!
    
    @IBOutlet weak var animalWildBtn: UIButton!
    var groupDWArray =  ["1 Group", "More Groups"]
    @IBOutlet weak var groupsBtn: UIButton!
    var handicapPer =  ["100%", "80%", "60%", "40%", "20%", "No"]
    var strokeOnPar : String = ""
    var handicaps : String = ""
    var groupId : Int = 0
    
    @IBOutlet weak var matchRadioBtn: UIButton!
    var backButton : UIBarButtonItem!
    
    @IBOutlet weak var caddieCardsDWBtn: UIButton!
    
    @IBOutlet weak var tieScoreView: UIView!
    @IBOutlet weak var tieScoreView_Height: NSLayoutConstraint!
    @IBOutlet weak var tieBtn: UIButton!
    @IBOutlet weak var scoringBtn: UIButton!
    @IBOutlet weak var tieScore_topConst: NSLayoutConstraint!
    var tieValues =  ["No Points for Ties", "½ Point for Ties", "1 Point Carry Over"]
    var scoringValues =  ["Lowest Score", "Total Score"]
    var pressValues =  ["Automatic","Manual"]
    var gameNameSelected : String = ""
    let notificationsBtn = BadgedButtonItem(with: UIImage(named: "mini-bell"))
    @IBOutlet weak var cardsPerPlayerLbl: UILabel!
    @IBOutlet weak var cardsPerPlayerBtn: UIButton!
    @IBOutlet weak var cardsPPDwArrowImg: UIImageView!
    @IBOutlet weak var cardsPPLineLbl: UILabel!
    @IBOutlet weak var animals_topConst: NSLayoutConstraint!
    var cardPerPlayerArr = ["2 Cards", "4 Cards", "6 Cards", "8 Cards", "10 Cards", "12 Cards"]
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isEditVC == false {
            self.title = "CREATE GAME"
            self.gameNameTxtField.isHidden = true
            gameNameSepLbl.isHidden = true
            if #available(iOS 13.0, *) {
                playNowPrimaryConstrain.isActive = false
                playNowSecConstrain.isActive = true
                playNowSecConstrain.priority = UILayoutPriority(rawValue: 999)
                playNowPrimaryConstrain.priority = UILayoutPriority(rawValue: 1000)
            } else {
                // Fallback on earlier versions
                playNowPrimaryConstrain.isActive = false
                playNowSecConstrain.isActive = true
                
            }
        }else {
            self.title = "EDIT GAME"
            self.gameNameTxtField.isHidden = false
            gameNameSepLbl.isHidden = false
            if #available(iOS 13.0, *) {
                playNowPrimaryConstrain.isActive = true
                playNowSecConstrain.isActive = false
                playNowSecConstrain.priority = UILayoutPriority(rawValue: 1000)
                playNowPrimaryConstrain.priority = UILayoutPriority(rawValue: 999)
            } else {
                // Fallback on earlier versions
                playNowPrimaryConstrain.isActive = true
                playNowSecConstrain.isActive = false
                
            }
        }
        //Handelson-Four 31.0
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 22)!]
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.tag = 200
        self.view.addGestureRecognizer(tap)
        
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        lineLblArray[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        
        // lineLblArray[1].isHidden = true
        
        dateTimeView.isHidden = true
        dateTimeView_Toplayout.constant = 0
        dateTimeView_HeightConstraint.constant = 0
        
        self.tieScoreView.isHidden = true
        self.tieScoreView_Height.constant = 0
        self.tieScore_topConst.constant = 0
        
        self.pressBView.isHidden = true
        self.pressBView_HeightConstraint.constant = 0
        self.pressBView_Toplayout.constant = 0
        
        self.animals_topConst.constant = -30
        self.cardsPerPlayerLbl.isHidden = true
        self.cardsPerPlayerBtn.isHidden = true
        self.cardsPPLineLbl.isHidden = true
        self.cardsPPDwArrowImg.isHidden = true
        
        if isEditVC == false && isReplayVC == false {
            
            playNowBtn.setTitle("Play Now", for: .normal)
            //  playNowBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            self.playNowBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            self.playNowBtn.setImage(image, for: .normal)
            self.playNowBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            scheduleLaterBtn.setTitle("Schedule Later", for: .normal)
            scheduleLaterBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            playNow = true
            
            let image1 = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            matchRadioBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            matchRadioBtn.setImage(image1, for: .normal)
            matchRadioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            /*
             teeBView.isHidden = true
             teeBView_Toplayout.constant = 0
             teeBView_HeightConstraint.constant = 0
             */
            // caddieCards_Switch.isOn = false
            // animals_Switch.isOn = false
            
            self.handicaps = "100"
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            // Replace the default back button
            self.navigationItem.setHidesBackButton(false, animated: false)
            
            getGameDetailsWS()
        }else {
            playNowBtn.setTitle("Play Now", for: .normal)
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            self.playNowBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            self.playNowBtn.setImage(image, for: .normal)
            self.playNowBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            scheduleLaterBtn.setTitle("Schedule Later", for: .normal)
            scheduleLaterBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            playNow = true
            
            gameNameTxtField.textColor = .black
            //playNowBtnTapped( nil )
            
            teeBView.isHidden = false
            teeBView_Toplayout.constant = 20
            teeBView_HeightConstraint.constant = 45
            
            //  getReplayGameDataWS(gameId : NSInteger(truncating: editReplayGameId))
        }
        teeBtn?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        gameBtn?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        caddieCardsDWBtn?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        //   animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.animalOffBtn.setImage(image, for: .normal)
        self.animalOffBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        animalBasicBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        animalWildBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        
        //removeing userdefaults key while showing creategame viewcontroller
        UserDefaults.standard.removeObject(forKey: "groupDetailsArr")
        self.navigationItem.rightBarButtonItem = notificationsBtn
    }
    override func viewWillLayoutSubviews() {
        
        searchFriendsView.layer.cornerRadius = 5.0
        searchFriendsView.layer.borderWidth = 1.0
        searchFriendsView.layer.borderColor = UIColor.lightGray.cgColor
        searchFriendsView.clipsToBounds = true
        
        dateTxtField.layer.cornerRadius = 3.0
        dateTxtField.layer.borderWidth = 1.0
        dateTxtField.layer.borderColor = UIColor.lightGray.cgColor
        dateTxtField.setLeftPaddingPoints(5)
        dateTxtField.clipsToBounds = true
        
        timeTxtField.layer.cornerRadius = 3.0
        timeTxtField.layer.borderWidth = 1.0
        timeTxtField.layer.borderColor = UIColor.lightGray.cgColor
        timeTxtField.setLeftPaddingPoints(5)
        timeTxtField.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        
        if isEditVC == false && isReplayVC == false {
        }else {
            self.title = "EDIT GAME"
            
            // Disable the swipe to make sure you get your chance to save
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            // Replace the default back button
            self.navigationItem.setHidesBackButton(true, animated: false)
            //    self.backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "arrow_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
            
            // self.navigationItem.leftBarButtonItem = self.backButton
            
            getReplayGameDataWS(gameId : NSInteger(truncating: editReplayGameId))
            
        }
        self.getunReadNotificationsCount()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    // Then handle the button selection
    @objc func goBack() {
        // Here we just remove the back button, you could also disabled it or better yet show an activityIndicator
        //  self.navigationItem.leftBarButtonItem = nil
        
        
        let alert = UIAlertController(title: "Save Your Changes?", message: "", preferredStyle: .alert)
        alert.view.tintColor = GlobalConstants.APPGREENCOLOR
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                // Don't forget to re-enable the interactive gesture
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.submitBtnTapped(UIButton.init())
                // self.navigationController?.popViewController(animated: true)
                
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                // Don't forget to re-enable the interactive gesture
                self.navigationItem.leftBarButtonItem = nil
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationController?.popViewController(animated: true)
                // self.navigationItem.leftBarButtonItem = self.backButton
                
            case .destructive:
                print("destructive")
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    func getunReadNotificationsCount() {
        
        var urlString :  String = ""
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        urlString  =  MyStrings().getUnreadNotificationsUrl + "\(custId)"
        
        self.startLoadingIndicator(loadTxt: "Loading...") //Commented due to loading two indicators
        
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
            let count = response.customModel as? Int
//
//            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//            if jsonString != "" {
              //  let count = Int(jsonString) ?? 0
                if count ?? 0 != 0 {
                    DispatchQueue.main.async {
                    self.notificationsBtn.setBadge(with: count!)
                    }
                }
            //}
            
            
        }
    }
    //MARK: - Button Action Methods
    
    @IBAction func playNowBtnTapped(_ sender: AnyObject?) {
        playNowBtn.setTitle("Play Now", for: .normal)
        // playNowBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.playNowBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.playNowBtn.setImage(image, for: .normal)
        self.playNowBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        scheduleLaterBtn.setTitle("Schedule Later", for: .normal)
        scheduleLaterBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        
        dateTimeView.isHidden = true
        dateTimeView_Toplayout.constant = 0
        dateTimeView_HeightConstraint.constant = 0
        
        playNow = true
        scheduledLater = false
    }
    
    @IBAction func scheduleLaterBtnTapped(_ sender: AnyObject?) {
        playNowBtn.setTitle("Play Now", for: .normal)
        playNowBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        scheduleLaterBtn.setTitle("Schedule Later", for: .normal)
        //  scheduleLaterBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.scheduleLaterBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.scheduleLaterBtn.setImage(image, for: .normal)
        self.scheduleLaterBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        
        dateTimeView.isHidden = false
        dateTimeView_Toplayout.constant = 15
        dateTimeView_HeightConstraint.constant = 107
        
        playNow = false
        scheduledLater = true
    }
    
    @IBAction func courseBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let csVCObj = storyboard.instantiateViewController(withIdentifier: "CourseSearchVC") as! CourseSearchVC
        csVCObj.delegate = self
        isCourseTapped = true
        self.navigationController?.pushViewController(csVCObj, animated: true)
    }
    @IBAction func teeBtnTapped(_ sender: Any) {
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
                                        self.teeBtn.setTitle(self.teeNamesArray[selectedIndex] as? String, for: .normal)
        }){
        }
    }
    @IBAction func animalBtnTapped(_ sender: Any) {
        self.errorAlert("Basic animals consists of 5 standard animals.\n Wild will include up to 15 less common animals to tag to your friends!")
    }
    @IBAction func animalOffBtnTapped(_ sender: Any) {
        
        //  animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.animalOffBtn.setImage(image, for: .normal)
        self.animalOffBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        animalBasicBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        animalWildBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        self.isAnimals = "Off"
    }
    @IBAction func animalBasicBtnTapped(_ sender: Any) {
        animalOffBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        //   animalBasicBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.animalBasicBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.animalBasicBtn.setImage(image, for: .normal)
        self.animalBasicBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        animalWildBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        self.isAnimals = "Basic"
    }
    @IBAction func animalWildBtnTapped(_ sender: Any) {
        animalOffBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        animalBasicBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        //   animalWildBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
        self.animalWildBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        self.animalWildBtn.setImage(image, for: .normal)
        self.animalWildBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        self.isAnimals = "Wild"
    }
    @IBAction func groupsBtnTapped(_ sender: Any) {
        let configuration = FTConfiguration.shared
        let cellConfi = FTCellConfiguration()
        configuration.menuRowHeight = 40
        configuration.menuWidth =  150
        configuration.backgoundTintColor = UIColor.lightGray
        cellConfi.textColor = UIColor.white
        cellConfi.textFont = .systemFont(ofSize: 13)
        configuration.borderColor = UIColor.lightGray
        configuration.menuSeparatorColor = UIColor.white
        configuration.borderWidth = 0.5
        cellConfi.textAlignment = NSTextAlignment.center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.groupDWArray,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.groupsBtn.setTitle(self.groupDWArray[selectedIndex], for: .normal)
                                        if selectedIndex == 0 {
                                            self.selectMembers_Toplayout.constant = 20
                                            self.selectMembers_HeightConstraint.constant = 40
                                            self.searchFriendsView.isHidden = false
                                            self.groupId = 0
                                        }else {
                                            self.selectMembers_Toplayout.constant = 0
                                            self.selectMembers_HeightConstraint.constant = 0
                                            self.searchFriendsView.isHidden = true
                                            self.groupId = 1
                                        }
        }){
        }
    }
    //MARK: - Press Button action method
    @IBAction func pressDWBtnTapped(_ sender: Any) {
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
                                    with: self.pressValues ,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.pressBtn.setTitle(self.pressValues[selectedIndex], for: .normal)
        }){
        }
    }
    
    
    //MARK: - Slect Members Button Tapped
    @IBAction func searchFriendsBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sMVCObj = storyboard.instantiateViewController(withIdentifier: "SelectMembersVC") as! SelectMembersVC
        sMVCObj.delegate = self
        sMVCObj.groupsArray = self.groupsArray
        if isEditVC == false && isReplayVC == false {
            sMVCObj.profileDataArray = self.profileDataArray
            sMVCObj.isEditReply = false
            UserDefaults.standard.setValue(0, forKey: "GameId")
            UserDefaults.standard.synchronize()
            self.navigationController?.pushViewController(sMVCObj, animated: true)
        }else {
            
            UserDefaults.standard.setValue(NSInteger(truncating: editReplayGameId), forKey: "GameId")
            UserDefaults.standard.synchronize()
            sMVCObj.isEditReply = true
            sMVCObj.editOrReplayDict = self.editOrReplayDict
            sMVCObj.editReplayGameId = editReplayGameId
            sMVCObj.isReplayVC = isReplayVC
            self.navigationController?.pushViewController(sMVCObj, animated: true)
        }
    }
    
    @IBAction func matchRadioBtnTapped(_ sender: Any) {
        if (self.matchRadioBtn.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            matchRadioBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            matchRadioBtn.setImage(image, for: .normal)
            matchRadioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        }else {
            matchRadioBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        }
        
    }
    @IBAction func matchPlayBtnTapped(_ sender: Any) {
        
        
        // scoreType = true
        
        let configuration = FTConfiguration.shared
        let cellConfi = FTCellConfiguration()
        configuration.menuRowHeight = 40
        configuration.menuWidth =  100
        configuration.backgoundTintColor = UIColor.lightGray
        cellConfi.textColor = UIColor.white
        cellConfi.textFont = .systemFont(ofSize: 13)
        configuration.borderColor = UIColor.lightGray
        configuration.menuSeparatorColor = UIColor.white
        configuration.borderWidth = 0.5
        cellConfi.textAlignment = NSTextAlignment.center
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.handicapPer,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.matchPlayBtn.setTitle("Use  \(self.handicapPer[selectedIndex])", for: .normal)
                                        self.handicaps = self.handicapPer[selectedIndex].replacingOccurrences(of: "%", with: "")
                                        let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                                        self.matchRadioBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                                        self.matchRadioBtn.setImage(image, for: .normal)
                                        self.matchRadioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        }){
        }
        
    }
    @IBAction func strokePlayBtnTapped(_ sender: Any) {
        //        matchPlayBtn.setTitle("Match Play", for: .normal)
        //        matchPlayBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        //        strokePlayBtn.setTitle("Stroke Play", for: .normal)
        //        strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
        
        //  scoreType = false
        
        self.strokePlayBtn.setTitle("Stroke on Par 3s", for: .normal)
        if (self.strokePlayBtn.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            //  self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            strokePlayBtn.setImage(image, for: .normal)
            strokePlayBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            self.strokeOnPar = "Yes"
        }else {
            self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
            self.strokeOnPar = "No"
        }
    }
    @IBAction func gameBtnTapped(_ sender: Any) {
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
                                    with: self.gameNamesArray as! [String],
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.gameBtn.setTitle(self.gameNamesArray[selectedIndex] as? String, for: .normal)
                                        self.gameNameSelected = (self.gameNamesArray[selectedIndex] as? String)!
                                        if self.gameNamesArray[selectedIndex] as? String == "Match Play" || self.gameNamesArray[selectedIndex] as? String == "Nassau" || self.gameNamesArray[selectedIndex] as? String == "Swing 6s" {
                                            self.tieScoreView.isHidden = false
                                            self.tieScoreView_Height.constant = 100
                                            self.tieScore_topConst.constant = 20
                                            
                                            self.pressBView.isHidden = false
                                            self.pressBView_HeightConstraint.constant = 40
                                            self.pressBView_Toplayout.constant = 20
                                        }else {
                                            self.tieScoreView.isHidden = true
                                            self.tieScoreView_Height.constant = 0
                                            self.tieScore_topConst.constant = 0
                                            
                                            self.pressBView.isHidden = true
                                            self.pressBView_HeightConstraint.constant = 0
                                            self.pressBView_Toplayout.constant = 0
                                        }
        }){
        }
    }
    @IBAction func caddieCardsSwitchTapped(_ sender: AnyObject?) {
        if caddieCards_Switch.isOn {
            isCaddieCards = true
        } else {
            isCaddieCards = false
        }
    }
    
    @IBAction func caddieCardsDWBtnTapped(_ sender: Any) {
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
        FTPopOverMenu.showForSender(sender: sender as! UIView,
                                    with: self.caddieCardsArray as! [String],
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.caddieCardsDWBtn.setTitle(self.caddieCardsArray[selectedIndex] as? String, for: .normal)
                                        if self.caddieCardsArray[selectedIndex] as? String == "No Putz Cards" {
                                            self.animals_topConst.constant = -30
                                            self.cardsPerPlayerLbl.isHidden = true
                                            self.cardsPerPlayerBtn.isHidden = true
                                            self.cardsPPLineLbl.isHidden = true
                                            self.cardsPPDwArrowImg.isHidden = true
                                        }else {
                                            self.animals_topConst.constant = 37
                                            self.cardsPerPlayerLbl.isHidden = false
                                            self.cardsPerPlayerBtn.isHidden = false
                                            self.cardsPPLineLbl.isHidden = false
                                            self.cardsPPDwArrowImg.isHidden = false
                                        }
        }){
        }
    }
    @IBAction func animalsSwitchTapped(_ sender: AnyObject?) {
        //        if animals_Switch.isOn {
        //            isAnimals = true
        //        } else {
        //            isAnimals = false
        //        }
    }
    @IBAction func cardsPerPlayerDWBtnTapped(_ sender: Any) {
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
                                    with: self.cardPerPlayerArr,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.cardsPerPlayerBtn.setTitle(self.cardPerPlayerArr[selectedIndex], for: .normal)
        }) {
            
        }
    }
    
    //MARK: - Submit button action method
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if (self.editOrReplayDict?.hasScoresData == "Yes" && (self.editOrReplayDict?.game != self.gameNameSelected))  { //|| (isEditVC == false && isReplayVC == false)  {
            let alert = UIAlertController(title: "If you change the game, scores entered for game will be reset", message: "", preferredStyle: .alert)
            alert.view.tintColor = GlobalConstants.APPGREENCOLOR
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.navigationItem.leftBarButtonItem = nil
                self.submitingDataToserver()
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: { (_) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else {
            self.submitingDataToserver()
        }
    }
    func submitingDataToserver() {
        var courseTitle = ""
        var gameTitle = ""
        var caddieCardsTitle = ""
        var teeTitle = ""
        var tieTitle = ""
        var scoringTitle = ""
        var pressTitle = ""
        
        if let text = courseBtn.titleLabel?.text {
            print(text)
            courseTitle = text
        }
        if let text = gameBtn.titleLabel?.text {
            print(text)
            gameTitle = text
        }
        if let text = caddieCardsDWBtn.titleLabel?.text {
            print(text)
            caddieCardsTitle = text
        }
        if let text = teeBtn.titleLabel?.text {
            print(text)
            teeTitle = text
        }
        if let text = tieBtn.titleLabel?.text {
            print(text)
            tieTitle = text
        }
        if let text = scoringBtn.titleLabel?.text {
            print(text)
            scoringTitle = text
        }
        if let text = pressBtn.titleLabel?.text {
            print(text)
            pressTitle = text
        }
        var gamingName = ""
        if isEditVC == true {
            guard let gameName = self.gameNameTxtField.text, gameName.count > 0, gameName.whiteSpaceBeforeString(name: self.gameNameTxtField.text!) else {
                self.gameNameTxtField.becomeFirstResponder()
                self.errorAlert("Please enter game name")
                // self.gameNameTxtField.becomeFirstResponder()
                //  self.show(message: "Please enter game name", controller: self)
                return
            }
            gamingName = gameName
        }
        
        
        guard let courseName = courseBtn.titleLabel?.text, courseName.count > 0, courseName.whiteSpaceBeforeString(name: (courseBtn.titleLabel?.text)!) else {
            self.errorAlert("Please select a golf Course")
            // self.show(message: "Please select a golf Course", controller: self)
            return
        }
        if courseName == "No Home Course" {
            self.errorAlert("Please select a golf Course")
            return
        }
        var params: Parameters = [
            "CustomerId": userId,
            "GameName": gamingName,
            "PlayNow": playNow,
            "Course": courseTitle as Any,
            "IsPermanent": isPermanent,
            "Game": gameTitle as Any,
            "TeeName": teeTitle as Any,
            "Caddie Cards": caddieCardsTitle as Any,
            "DeckName": caddieCardsTitle as Any,
            "Animals": isAnimals
        ]
        if let text = self.cardsPerPlayerBtn.titleLabel?.text {
            print(text)
            params["CardsPerPlayer"] = (text as NSString).integerValue
        }
        
        //Wrote on 21/8/2020
        if gameTitle == "Match Play" || gameTitle == "Nassau" || gameTitle == "Swing 6s"{
            if tieTitle == "No Points for Ties" {
                params["Tie"] = 0
            }else if tieTitle == "½ Point for Ties" {
                params["Tie"] = 1
            }else {
                params["Tie"] = 2
            }
            if scoringTitle == "Lowest Score" {
                params["Scoring"] = 0
            }else {
                params["Scoring"] = 1
            }
            if pressTitle == "Automatic" {
                params["Press"] = 0
            }else {
                params["Press"] = 1
            }
        }
        //
        
        //if scheduleLaterBtn.currentImage == UIImage.init(named: "radio_button_checked")  {
        if  scheduledLater == true {
            guard let date = self.dateTxtField.text, date.count > 0, date.whiteSpaceBeforeString(name: self.dateTxtField.text!) else {
                self.errorAlert("Please select date")
                //   self.show(message: "Please select date", controller: self)
                return
            }
            guard let time = self.timeTxtField.text, time.count > 0, time.whiteSpaceBeforeString(name: self.timeTxtField.text!) else {
                self.errorAlert("Please select time")
                //  self.show(message: "Please select time", controller: self)
                return
            }
            params["ScheduleDate"] = date
            params["ScheduleTime"] = time
        }
        if membersStr == "" && gameTitle != "9s" {
            if isEditVC == false && isReplayVC == false {
                self.errorAlert("Please select players")
                // self.show(message: "Please select members", controller: self)
                return
            }else {
                let selctedMembersArr = NSMutableArray()
                for (index2, item2) in self.groupDetailsArr.enumerated() {
                    print("Found \(item2) at position \(index2)")
                    let secondDict = item2 as? NSDictionary
                    let userID = secondDict?["UserId"] as? String ?? ""
                    let custmerID = secondDict?["CustomerId"]
                    if userID == "" {
                        selctedMembersArr.add(custmerID!)
                    }else {
                        selctedMembersArr.add(userID)
                    }
                }
                var membersStr =   selctedMembersArr.componentsJoined(by: ",")
                if  membersStr.contains("\(userId)") == false {
                    membersStr = membersStr + ",\(userId)"
                }
                params["Members"] = membersStr
            }
        }else if gameTitle == "9s" {
            if membersStr == "" {
                let selctedMembersArr = NSMutableArray()
                for (index2, item2) in self.groupDetailsArr.enumerated() {
                    print("Found \(item2) at position \(index2)")
                    let secondDict = item2 as? NSDictionary
                    let userID = secondDict?["UserId"] as? String ?? ""
                    let custmerID = secondDict?["CustomerId"]
                    if userID == "" {
                        selctedMembersArr.add(custmerID!)
                    }else {
                        selctedMembersArr.add(userID)
                    }
                }
                membersStr =   selctedMembersArr.componentsJoined(by: ",")
                if  membersStr.contains("\(userId)") == false {
                    membersStr = membersStr + ",\(userId)"
                }
            }
            let membersArr = membersStr.components(separatedBy: ",")
            if membersArr.count > 3 || membersArr.count < 3 {
                self.errorAlert("9s can only be played when there are 3 players")
                return
            }
            params["Members"] = membersStr
        }else {
            params["Members"] = membersStr
        }
        
        
        //Madhu
        /*
         //   let membersStr =   self.selctedMembersArr.componentsJoined(by: ",")
         if friendsBtn.currentImage == UIImage.init(named: "radio_button_unchecked") && groupBtn.currentImage == UIImage.init(named: "radio_button_unchecked") {
         self.errorAlert("Please select members")
         return
         }else {
         if friendsBtn.currentImage == UIImage.init(named: "radio_button_checked") {
         if membersStr == "" || membersStr == "," {
         self.errorAlert("Please add friends")
         return
         }else {
         params["Members"] = membersStr
         }
         }else {
         params["GroupId"] = self.groupID
         }
         params["IsGroupSelection"] = isGroupSelection
         }
         */
        //        if matchPlayBtn.currentImage == UIImage.init(named: "radio_button_unchecked") && strokePlayBtn.currentImage == UIImage.init(named: "radio_button_unchecked") {
        //            self.errorAlert("Please select type of the score")
        //            return
        //        }else {
        //            params["ScoreType"] = scoreType
        //        }
        params["ScoreType"] = scoreType
        params["GroupId"] = self.groupId
        params["IsGroupSelection"] = self.isGroupSelection
        
        params["Handicaps"] = self.handicaps
        
        if isEditVC == true || isReplayVC == true
        {
            params["GameId"] = NSInteger(truncating: editReplayGameId)
        }
        if isReplayVC == true
        {
            params["NumberOfGroups"] = "1"
        }
        params["StrokeOnPar"] = self.strokeOnPar
        
        if self.handicaps == "" && self.strokeOnPar == "" {
            self.show(message: "Please select handicap scoring", controller: self)
            return
        }
        if gameTitle == "Select Game" || gameTitle == "" {
            self.show(message: "Please select a game", controller: self)
            return
        }
        
        print("Create Game View Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        
        
        if isEditVC == false
        {
            if isReplayVC == true {
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().replayGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        print("Create Group Responce = \(response.responseDictionary)")
                        if self.playNow == true && response.customModel != nil {
                            self.isEditVC = true
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
                            playVCObj.editReplayGameId = response.customModel as! NSNumber
                            playVCObj.isCreateGameVC = "CreateGameVC"
                            self.editReplayGameId = response.customModel as! NSNumber
                            self.navigationController?.pushViewController(playVCObj, animated: true)
                        }else {
                            self.isEditVC = false
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else {
                ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().createGameViewUrl, urlParams: params as [String : AnyObject]) { (response) in
                    print(response as Any)
                    
                    if(response.isSuccess){
                        print("Create Group Responce = \(response.responseDictionary)")
                        
                        if self.playNow == true && response.customModel != nil {
                            self.isEditVC = true
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
                            playVCObj.editReplayGameId = response.customModel as! NSNumber
                            playVCObj.isCreateGameVC = "CreateGameVC"
                            self.editReplayGameId = response.customModel as! NSNumber
                            self.navigationController?.pushViewController(playVCObj, animated: true)
                        }else {
                            self.isEditVC = false
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }else {
            
            ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().replayOrEditGameSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
                print(response as Any)
                
                if(response.isSuccess){
                    print("Create Group Responce = \(response.responseDictionary)")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: -  Tie and Scoring Button action Methods
    
    @IBAction func tieBtnTapped(_ sender: Any) {
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
                                    with: self.tieValues ,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.tieBtn.setTitle(self.tieValues[selectedIndex], for: .normal)
        }){
        }
    }
    @IBAction func scoringBtnTapped(_ sender: Any) {
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
                                    with: self.scoringValues,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        self.scoringBtn.setTitle(self.scoringValues[selectedIndex], for: .normal)
        }){
        }
    }
    
    // MARK: -  TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        if textField == gameNameTxtField {
            return newLength <= 25
        }else {
            return newLength <= 25
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        for label in lineLblArray
        {
            label.backgroundColor = GlobalConstants.APPLIGHTGRAYCOLOR
        }
        if textField == gameNameTxtField {
            lineLblArray[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        }else if textField == dateTxtField {
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
        if #available(iOS 13.4, *) {
                   
                    picker.preferredDatePickerStyle = .wheels
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
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        if let tap = sender {
            let point = tap.location(in: self.gameNameTxtField)
            if self.gameNameTxtField.point(inside: point, with: nil) == false {
                // write your stuff here
                self.gameNameTxtField.resignFirstResponder()
            }
        }
        
    }
    //MARK: - Delegate Method
    func sendCourseNameToCreteGameVC(courseName: String) {
        self.courseBtn.setTitle(courseName, for: .normal)
        teeBView.isHidden = false
        teeBView_Toplayout.constant = 20
        teeBView_HeightConstraint.constant = 45
        self.getTeeNamesByCourseWS(courseName: courseName)
    }
    func sendMembersToCreteGameVC(members: String, count:NSInteger) {
        membersStr = members
        print(membersStr)
        self.searchFriendsBtn.setTitle("Select Players   ( \(count) )", for: .normal)
    }
    
    
    //MARK: - Web Service Methods
    func getGameDetailsWS() {
        
        let urlString :  String =  MyStrings().getGameViewDataUrl + "\(userId)"
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
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.profileDataArray = GameViewDetailsModel(JSONString: jsonString)
            
            self.groupsArray.removeAllObjects()
            // self.groupsArray.add("Select members")
            for group in (self.profileDataArray?.groups)! {
                self.groupsArray.add(group.groupName)
            }
            print("Groups Names Array = \(self.groupsArray)")
            
            /*
             for course in (self.profileDataArray?.courseNames)! {
             self.coursesArray.add(course.courseName)
             }
             print("Course Names Array = \(self.coursesArray)")
             if self.coursesArray.count > 0 {
             self.courseBtn.setTitle(self.coursesArray.object(at: 0) as? String, for: .normal)
             self.getTeeNamesByCourseWS(courseName: self.coursesArray.object(at: 0) as? String ?? "")
             }
             */
            self.gameNamesArray.removeAllObjects()
            self.gameNamesArray.add("Stroke Play")
            self.gameNamesArray.add("Match Play")
            
            //Crash issue checking with out home course in signup VC
            if self.profileDataArray?.homeCourse != nil && self.profileDataArray?.homeCourse != "" {
                self.courseBtn.setTitle(self.profileDataArray?.homeCourse ?? "", for: .normal)
                self.getTeeNamesByCourseWS(courseName: self.profileDataArray?.homeCourse ?? "")
            }else {
                self.courseBtn.setTitle("", for: .normal)
                // self.getTeeNamesByCourseWS(courseName: "")
            }
            
            for game in (self.profileDataArray?.gameNames)! {
                // self.gameNamesArray.add(game.gameName)
                if game.gameName == "Stroke Play" || game.gameName == "Match Play" {
                }else {
                    self.gameNamesArray.add(game.gameName)
                }
            }
            print("Game Names Array = \(self.gameNamesArray)")
            if self.gameNamesArray.count > 0 {
                self.gameBtn.setTitle("Select Game", for: .normal)
                //  self.gameBtn.setTitle(self.gameNamesArray.object(at: 0) as? String, for: .normal)
            }
            self.caddieCardsArray.removeAllObjects()
            self.caddieCardsArray.add("No Putz Cards")
            for deck in (self.profileDataArray?.deckNames)! {
                self.caddieCardsArray.add(deck.deckName)
            }
            self.caddieCardsDWBtn.setTitle(self.caddieCardsArray.object(at: 0) as? String, for: .normal)
            
            
        }
    }
    func getTeeNamesByCourseWS(courseName : String) {
        
        //  let formattedString = courseName.replacingOccurrences(of: " ", with: "%20")
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$-,/?%#[] ").inverted)
        let formattedString = courseName.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        let urlString :  String =  MyStrings().getTeeNamesUrl + "\(formattedString)"
        // urlString = urlString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
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
            
            self.teeNamesArray.removeAllObjects()
            self.teeArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
            if self.teeArr.count > 0 {
                let teeDict  = self.teeArr[0] as! NSDictionary
                self.teeBtn.setTitle(teeDict["TeeName"] as? String ?? "", for: .normal)
            }else {
                self.teeBtn.setTitle("", for: .normal)
                if courseName != "No Home Course" {
                    self.errorAlert("No teename for selcted course,please select other one.")
                }
            }
            for tee in self.teeArr {
                let tDict  = tee as! NSDictionary
                self.teeNamesArray.add(tDict["TeeName"] as? String ?? "")
            }
            print("Tee Names Array = \(self.teeNamesArray)")
        }
    }
    func getReplayGameDataWS(gameId : NSInteger) {
        
        
        let urlString :  String =  MyStrings().getReplayOrEditGameDetailsUrl + "\(gameId)" + "&CustomerId=" + "\(userId)"
        
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
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.editOrReplayDict = EditOrReplayGameModel(JSONString: jsonString)
            
            self.gameNameTxtField.text = self.editOrReplayDict?.gameName ?? ""
            self.teeBtn.setTitle(self.editOrReplayDict?.teeName ?? "", for: .normal)
            self.gameBtn.setTitle(self.editOrReplayDict?.game ?? "", for: .normal)
            if self.isCourseTapped == false {
                self.courseBtn.setTitle(self.editOrReplayDict?.course ?? "", for: .normal)
            }
            self.gameBtn.setTitle(self.editOrReplayDict?.game ?? "", for: .normal)
            if self.editOrReplayDict?.game == "Match Play" || self.editOrReplayDict?.game == "Nassau" || self.editOrReplayDict?.game == "Swing 6s" {
                if self.editOrReplayDict?.tie == 0 {
                    self.tieBtn.setTitle("No Points for Ties", for: .normal)
                }else if self.editOrReplayDict?.tie == 1 {
                    self.tieBtn.setTitle("½ Point for Ties", for: .normal)
                }else {
                    self.tieBtn.setTitle("1 Point Carry Over", for: .normal)
                }
                if self.editOrReplayDict?.scoring == 0 {
                    self.scoringBtn.setTitle("Lowest Score", for: .normal)
                }else  {
                    self.scoringBtn.setTitle("Total Score", for: .normal)
                }
                self.tieScoreView.isHidden = false
                self.tieScoreView_Height.constant = 100
                self.tieScore_topConst.constant = 20
                
                if self.editOrReplayDict?.press == "1" {
                    self.pressBtn.setTitle("Manual", for: .normal)
                }else {
                    self.pressBtn.setTitle("Automatic", for: .normal)
                }
                self.pressBView.isHidden = false
                self.pressBView_HeightConstraint.constant = 40
                self.pressBView_Toplayout.constant = 20
            }else {
                self.tieScoreView.isHidden = true
                self.tieScoreView_Height.constant = 0
                self.tieScore_topConst.constant = 0
                
                self.pressBView.isHidden = true
                self.pressBView_HeightConstraint.constant = 0
                self.pressBView_Toplayout.constant = 0
            }
            self.cardsPerPlayerBtn.setTitle("\(self.editOrReplayDict?.cardsPerPlayer ?? "") Cards", for: .normal)
            if self.editOrReplayDict?.deckName == "No Putz Cards" {
                self.animals_topConst.constant = -30
                self.cardsPerPlayerLbl.isHidden = true
                self.cardsPerPlayerBtn.isHidden = true
                self.cardsPPLineLbl.isHidden = true
                self.cardsPPDwArrowImg.isHidden = true
            }else {
                self.animals_topConst.constant = 37
                self.cardsPerPlayerLbl.isHidden = false
                self.cardsPerPlayerBtn.isHidden = false
                self.cardsPPLineLbl.isHidden = false
                self.cardsPPDwArrowImg.isHidden = false
            }
            
            self.searchFriendsBtn.setTitle("Select Players   ( \(self.editOrReplayDict!.players.count) )", for: .normal)
            
            if self.isReplayVC == true {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.dateTxtField.text = formatter.string(from: date)
                
                let time = date.addingTimeInterval(TimeInterval(10.0 * 60.0))
                formatter.dateFormat = "hh:mm a"
                self.timeTxtField.text = formatter.string(from: time)
                
            }else {
                self.dateTxtField.text = self.editOrReplayDict?.scheduleDate ?? ""
                
                //Removed seconds in schedule time
                /*
                 let formatter = DateFormatter()
                 formatter.dateFormat = "hh:mm:ss"
                 let date = formatter.date(from: self.editOrReplayDict?.scheduleTime ?? "")
                 
                 formatter.dateFormat = "hh:mm"
                 // self.timeTxtField.text = formatter.string(from: date!)
                 */
                
                self.timeTxtField.text = self.editOrReplayDict?.scheduleTime ?? ""
            }
            self.groupsArray.removeAllObjects()
            self.groupsArray.add("Select Group")
            for group in (self.editOrReplayDict?.groups)! {
                self.groupsArray.add(group.groupName)
            }
            print("Groups Names Array = \(self.groupsArray)")
            
            self.gameNameSelected = self.editOrReplayDict?.game ?? ""
            self.gameNamesArray.removeAllObjects()
            self.gameNamesArray.add("Stroke Play")
            self.gameNamesArray.add("Match Play")
            for game in (self.editOrReplayDict?.gameNames)! {
                
                if game.gameName == "Stroke Play" || game.gameName == "Match Play" {
                }else {
                    self.gameNamesArray.add(game.gameName)
                }
            }
            print("Game Names Array = \(self.gameNamesArray)")
            
            self.teeNamesArray.removeAllObjects()
            for teeName in (self.editOrReplayDict?.teeNames)! {
                self.teeNamesArray.add(teeName.teeName)
            }
            print("tee Names Array = \(self.teeNamesArray)")
            if self.editOrReplayDict?.teeName == "" {
                self.teeBtn.setTitle(self.teeNamesArray.object(at: 0) as? String, for: .normal)
            }
            
            //  if self.editOrReplayDict?.scoreType  == "0" {
            //                self.strokePlayBtn.setTitle("Stroke Play", for: .normal)
            //                self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            //  self.scoreType = false
            
            if self.editOrReplayDict?.handicaps == "No" {
                self.matchPlayBtn.setTitle("Use  \(self.editOrReplayDict?.handicaps ?? "")", for: .normal)
                self.handicaps = "No"
            }else if self.editOrReplayDict?.handicaps == nil {
                self.matchPlayBtn.setTitle("Use  100%", for: .normal)
                self.handicaps = "100"
            }else {
                self.matchPlayBtn.setTitle("Use  \(self.editOrReplayDict?.handicaps ?? "")%", for: .normal)
                self.handicaps = self.editOrReplayDict?.handicaps ?? ""
            }
            // self.matchRadioBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            self.matchRadioBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            self.matchRadioBtn.setImage(image, for: .normal)
            self.matchRadioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
            
            //            }else {
            //                //                self.matchPlayBtn.setTitle("Match Play", for: .normal)
            //                //                self.matchPlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
            //                self.scoreType = true
            //            }
            self.groupDetailsArr.removeAllObjects()
            for player in (self.editOrReplayDict?.players)! {
                let dict = NSMutableDictionary()
                dict.setValue(player.customerId!, forKey: "CustomerId")
                dict.setValue(player.firstName, forKey: "FirstName")
                self.groupDetailsArr.add(dict)
            }
            /*
             if self.editOrReplayDict?.caddieCards == "1" {
             self.caddieCards_Switch.isOn = true
             }else {
             self.caddieCards_Switch.isOn = false
             }
             self.caddieCardsSwitchTapped( nil )
             */
            /*
             if self.editOrReplayDict?.animals == "1" {
             // self.animals_Switch.isOn = true
             }else {
             // self.animals_Switch.isOn = false
             }
             self.animalsSwitchTapped( nil )
             */
            
            if self.editOrReplayDict?.animals == "0" {
                // self.animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                self.animalOffBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                self.animalOffBtn.setImage(image, for: .normal)
                self.animalOffBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
                
                self.animalBasicBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.animalWildBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.isAnimals = "Off"
            }else if self.editOrReplayDict?.animals == "1" {
                self.animalOffBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                //  self.animalBasicBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                self.animalBasicBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                self.animalBasicBtn.setImage(image, for: .normal)
                self.animalBasicBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
                
                self.animalWildBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.isAnimals = "Basic"
            }else {
                self.animalOffBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.animalBasicBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                //   self.animalWildBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                self.animalWildBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                self.animalWildBtn.setImage(image, for: .normal)
                self.animalWildBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
                self.isAnimals = "Wild"
            }
            if self.editOrReplayDict?.strokeOnPar  == "No" {
                self.strokePlayBtn.setTitle("Stroke on Par 3s", for: .normal)
                self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.strokeOnPar = "No"
            }else if self.editOrReplayDict?.strokeOnPar  == nil {
                self.strokePlayBtn.setTitle("Stroke on Par 3s", for: .normal)
                self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
                self.strokeOnPar = "No"
            }else {
                self.strokePlayBtn.setTitle("Stroke on Par 3s", for: .normal)
                //   self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
                self.strokePlayBtn.setImage(UIImage.init(named: "radio_button_checked"), for: .normal)
                self.strokePlayBtn.setImage(image, for: .normal)
                self.strokePlayBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
                
                self.strokeOnPar = "Yes"
            }
            //            if self.editOrReplayDict?.playNow == "1" {
            //                self.playNowBtnTapped( nil )
            //            }else {
            //                self.scheduleLaterBtnTapped( nil )
            //            }
            self.caddieCardsArray.removeAllObjects()
            self.caddieCardsArray.add("No Putz Cards")
            for deck in (self.editOrReplayDict?.deckNames)! {
                self.caddieCardsArray.add(deck.deckName)
            }
            if self.editOrReplayDict?.deckName == nil || self.editOrReplayDict?.deckName == "" {
                self.caddieCardsDWBtn.setTitle(self.caddieCardsArray.object(at: 0) as? String, for: .normal)
            }else {
                self.caddieCardsDWBtn.setTitle(self.editOrReplayDict?.deckName ?? "", for: .normal)
            }
        }
    }
}
extension CharacterSet {
    static let urlAllowed = CharacterSet.urlFragmentAllowed
        .union(.urlHostAllowed)
        .union(.urlPasswordAllowed)
        .union(.urlQueryAllowed)
        .union(.urlUserAllowed)
}

