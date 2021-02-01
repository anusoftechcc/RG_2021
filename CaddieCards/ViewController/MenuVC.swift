//
//  MenuVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 11/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import SafariServices

class MenuVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate {
    
    private let headerIdentifier = "headerCell"
    private let cellIdentifier = "contentCell"
    private let rulesCellIdentifier = "rulesContentCell"
    
    private let sectionTitles = ["Rules"]//, "Second section", "Third section"
    private var sectionIsExpanded = [false]//, true, true
    //  private let numberOfActualRowsForSection = 8
    var imagesArray  = [String]()
    var namesArray  = [String]()
    var rulesGamesArray  = [String]()
    var countFrnds : Int = 0
    var gamesData = [Int]()
    
    @IBOutlet weak var menuTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        imagesArray = ["golf_icon","ic_nav_golf_cart","friends_icon","rules-icon","golf_icon","profile_icon","contactus-icon","share_black_icon","log_out_icon"]
//        namesArray = ["Scores","Games","Friends","","Scorecards","Profile","Contact Us","Share the App", "Log Out"]  ic_nav_putzBux
        imagesArray = ["ic_nav_golf_cart","friends_icon","rules-icon","ic_nav_gold_putxbox","profile_icon","nav-bell","contactus-icon","share_black_icon","log_out_icon"]
        namesArray = ["Games","Friends","","Putz Bux","Profile","Notifications","Contact Us","Share the App", "Log Out"]
          rulesGamesArray = ["Game Rules"]
        
        getUserDetailsWS()
    }
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: - Button Navigation actions
    
    @IBAction func scoresBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScoresVC") as! ScoresVC
        self.navigationController?.pushViewController(scoresVCObj, animated: true)
    }
    
    @IBAction func gamesBtnTapped(_ sender: Any) {
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let gamesVCObj = storyboard.instantiateViewController(withIdentifier: "GamesVC") as! GamesVC
         self.navigationController?.pushViewController(gamesVCObj, animated: true)
         */
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func putzBuxBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "PutzBux", bundle: nil)
        let buxVC = storyboard.instantiateViewController(withIdentifier: "PutzBuxVC") as! PutzBuxVC
        self.navigationController?.pushViewController(buxVC, animated: true)
    }
    
    @IBAction func notificationsBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let notificationsVC = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    @IBAction func friendsBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsVCObj = storyboard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
        self.navigationController?.pushViewController(friendsVCObj, animated: true)
    }
    
    @IBAction func profileBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVCObj = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        // self.present(profileVCObj, animated: true, completion: nil)
        self.navigationController?.pushViewController(profileVCObj, animated: true)
    }
    @IBAction func contactUsBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactVCObj = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(contactVCObj, animated: true)
    }
    @IBAction func shareAppBtnTapped(_ sender: Any) {
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactVCObj = storyboard.instantiateViewController(withIdentifier: "ShareAppVC") as! ShareAppVC
        self.navigationController?.pushViewController(contactVCObj, animated: true)
    }
    @IBAction func logOutBtnTapped(_ sender: Any) {
        self.startLoadingIndicator(loadTxt: "Wait...")
        self.dismiss(animated: true, completion: {
            UserDefaults.standard.set("No", forKey: "Login")
            self.stopLoadingIndicator()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashNavId") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = initialViewController
        })
    }
    //MARK: - Web Service Methods
    func getUserDetailsWS() {
        
        let customerEmail: String = UserDefaults.standard.object(forKey: "CustomerEmail") as! String
        
        let urlString :  String =  MyStrings().getUserDetailsUrl + "\(customerEmail)"
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
            self.countFrnds =  ((dict["FriendsCount"] as? NSInteger)!)
            
            self.rulesGamesArray.removeAll()
            self.gamesData.removeAll()
            self.rulesGamesArray.append("Game Rules")
            let gamesMenu = dict["GamesMenu"] as? NSArray
            for gameManu in gamesMenu! {
                let dict = gameManu as? NSDictionary
                self.rulesGamesArray.append(dict?["GameName"] as! String)
                self.gamesData.append(dict?["GameId"] as! Int)
            }
            print("Rules Menu Array = \(self.rulesGamesArray)")
            self.menuTV.reloadSections([3], with: .automatic)
        }
    }
    
    //MARK: - TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // First will always be header
        if section == 2 {
            return sectionIsExpanded[0] ? (rulesGamesArray.count) : 1 //(1+rulesGamesArray.count)
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerIdentifier, for: indexPath) as! ExpandTableViewCell
              cell.imgIcon.image = UIImage.init(named: imagesArray[2])
            if rulesGamesArray.count > indexPath.row {
                cell.titleLabel?.text = rulesGamesArray[indexPath.row]
            }else {
                cell.titleLabel?.text = ""
            }
            
            if sectionIsExpanded[0] {
                cell.setExpanded()
            } else {
                cell.setCollapsed()
            }
            cell.arrowUpDownBtn.addTarget(self, action: #selector(arrowUpDownBtnTapped(_:)), for: .touchUpInside)
            
            return cell
        }else if indexPath.section == 2 && indexPath.row >= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: rulesCellIdentifier, for: indexPath) as! RulesContentTVCell
            if rulesGamesArray.count > indexPath.row {
                cell.titleLabel?.text = rulesGamesArray[indexPath.row]
            }else {
                cell.titleLabel?.text = ""
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContentTableViewCell
            
            cell.titleLabel?.text = namesArray[indexPath.section]
            cell.imgIcon.image = UIImage.init(named: imagesArray[indexPath.section])
            cell.frndsCountLbl.isHidden = true
            
            if indexPath.section == 1 {
                cell.frndsCountLbl.isHidden = false
                cell.frndsCountLbl.text = String(self.countFrnds)
            }
            cell.frndsCountLbl.layer.cornerRadius = cell.frndsCountLbl.frame.size.height/2
            cell.frndsCountLbl.clipsToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Expand/hide the section if tapped its header
        if indexPath.section == 2 {
            self.navigationController?.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            var gameId : NSInteger = 0
            if indexPath.row == 0 {
                sectionIsExpanded[0] = !sectionIsExpanded[0]
                
                tableView.reloadSections([2], with: .automatic)
                return
            }else {
                gameId = self.gamesData[indexPath.row - 1]
            }
                
            /*else if indexPath.row == 1 {
               
                gameId = self.gamesData[indexPath.row - 1]
            }
                gameId = self.gamesData[indexPath.row - 1]
            }
            else if indexPath.row == 3 {
                gameId = 3
             else if indexPath.row == 2 {
                 gameId = 2
                gameId = self.gamesData[indexPath.row - 1]
            }
            else if indexPath.row == 4 {
                gameId = 4
                gameId = self.gamesData[indexPath.row - 1]
            }
            else if indexPath.row == 5 {
                gameId = 5
                gameId = self.gamesData[indexPath.row - 1]
            }
            else if indexPath.row == 6 {
                gameId = 6
                gameId = self.gamesData[indexPath.row - 1]
            }else if indexPath.row == 7 {
                gameId = 7
                gameId = self.gamesData[indexPath.row - 1]
            }else {
                gameId = 12
                
            } */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vcObj = storyboard.instantiateViewController(withIdentifier: "GameRulesVC") as! GameRulesVC
            vcObj.gameId = gameId
            self.navigationController?.pushViewController(vcObj, animated: true)
        }
//        }else if indexPath.section == 0 {
//            self.scoresBtnTapped(UIButton.init())
//        }
        else if indexPath.section == 0 {
            self.gamesBtnTapped(UIButton.init())
        }
        else if indexPath.section == 1 {
            self.friendsBtnTapped(UIButton.init())
        }
        else if indexPath.section == 3 {
            self.putzBuxBtnTapped(UIButton.init())
        }
        else if indexPath.section == 4 {
            self.profileBtnTapped(UIButton.init())
        }
        else if indexPath.section == 5 {
            self.notificationsBtnTapped(UIButton.init())
        }
        else if indexPath.section == 6 {
            self.contactUsBtnTapped(UIButton.init())
        }
        else if indexPath.section == 7 {
            self.shareAppBtnTapped(UIButton.init())
        }
        else if indexPath.section == 8 {
            self.logOutBtnTapped(UIButton.init())
        }
    }
    //MARK: - History Action Methods
    
    @objc func arrowUpDownBtnTapped(_ sender: UIButton) {
        sectionIsExpanded[0] = !sectionIsExpanded[0]
        
        menuTV.reloadSections([2], with: .automatic)
    }
    @IBAction func soaringBtnTapped(_ sender: Any) {
        let url = NSURL.init(string: "https://www.soaring.dev/")
        let vc = SFSafariViewController(url: url! as URL)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    // MARK: - SafariViewController Delegate Methods
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
