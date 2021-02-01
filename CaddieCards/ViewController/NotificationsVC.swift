//
//  NotificationsVC.swift
//  CaddieCards
//
//  Created by Mounika Reddy on 21/01/21.
//  Copyright © 2021 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NotificationsVC: BaseViewController {
    var alert = UIAlertController()
    var putzCard : Int = 0
    var animalCard : Int = 0
    var notificationsDict : [String: Any]?
    @IBOutlet weak var notificationsTblView: UITableView!
    var sourceArr = ["Putz Cards","Animal Game","Game Invitations (Coming Soon)","Game Updates (Coming Soon)","Messages (Coming Soon)","Tournament Updates (Coming Soon)","Friend Updates (Coming Soon)","Putz Bux Activity (Coming Soon)","Promotions (Coming Soon)"]
    var detailArr = ["This is set","Mail sent to set this","Greyed out (does not exist yet)","Greyed out (does not exist yet)","Greyed out (does not exist yet)","Greyed out (does not exist yet)","Greyed out (does not exist yet)","Greyed out (does not exist yet)","Greyed out (does not exist yet)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Notifications"
        notificationsTblView.tableFooterView = UIView()
        self.getNotifications()
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        self.sendNotifications()
    }
    func getAllNotifications(purpose:String) {
        
        var urlString :  String = ""
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        urlString  =  MyStrings().getAllNotificationsPurposeUrl + "\(custId)&NotificationsType=" + "\(purpose)"
        
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
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        }
    }
    func getNotifications() {
        
        let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let dict = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
        let firstName = dict["UserName"] as? String ?? ""
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        let urlString :  String =  MyStrings().getNotificationsUrl + "\(userId)" + "&userName=" + "\(firstName)"
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .post, loading: self) { (response) in
            if(response.isSuccess){
                print(response as Any)
                print(response.customModel)
                self.notificationsDict = response.responseDictionary as? [String : Any]
                if self.notificationsDict != nil {
                    self.putzCard = self.notificationsDict?["PutzCards"] as! Int
                    self.animalCard = self.notificationsDict?["Animals"] as! Int
                }
               
                DispatchQueue.main.async {
                    self.notificationsTblView.reloadData()
                }
            }else {
                DispatchQueue.main.async {
               // self.stopLoadingIndicator()
                self.errorAlert("Unable to end this game")
                }
               
            }
        }

    }
    
    func sendNotifications() {
        let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
        let dict = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
        let firstName = dict["UserName"] as? String ?? ""

        let params: Parameters = [
            "Username": firstName,
            "CustomerId": userId,
            "PutzCards" : self.putzCard,
            "Animals" : self.animalCard,
            "Invitations": 1,
            "GameUpdates": 1,
            "Messages" : 1,
            "TournamentUpdates" : 1,
            "FriendUpdates": 1,
            "PutzBuxActivity" : 1,
            "Promotions" : 1
        ]

        print("Send Putz Card Parameters = \(params) and url = \(MyStrings().sendNotificationsUrl)")
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().sendNotificationsUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                if response.responseCode != 200 {
                    self.errorAlert("Setting notifications failed. Please try again")
                    return
                }else {
                    DispatchQueue.main.async {
                    print("Send Putz Card Responce = \(response.responseDictionary)")
                    
                    self.alert = UIAlertController(title: " Success", message: "Notifications has been set", preferredStyle: UIAlertController.Style.alert)
                 
                    self.alert.addAction(UIAlertAction(title: "OK",
                                                       style: UIAlertAction.Style.default,
                                                       handler: {(_: UIAlertAction!) in
                                                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(self.alert, animated: true, completion: nil)
                }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */  //={userName}&customerid={customerid}
   
}
extension NotificationsVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 9
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationsTableViewCell
        cell.headerLbl.text = sourceArr[indexPath.row]
        cell.detailLbl.text = detailArr[indexPath.row]
        if indexPath.row != 0 && indexPath.row != 1 {
            cell.switch.isEnabled = false
            cell.headerLbl.alpha = 0.5
        }else {
            cell.headerLbl.alpha = 1
        }
        cell.switch.tag = indexPath.row
        cell.switch.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        switch indexPath.row {
        case 0:
            cell.switch.isOn = (self.putzCard != 0)
        case 1:
            cell.switch.isOn = (self.animalCard != 0)
        default:
            print("Default")
        }
        
        return cell
    }
    
    @objc func switchChanged(sender:UISwitch) {
       // let cellSwitch = sender.tag
        switch sender.tag {
        case 0:
            if sender.isOn {
                self.putzCard = 1
            }else {
                self.putzCard = 0
            }
        case 1:
            if sender.isOn {
                self.animalCard = 1
            }else {
                self.animalCard = 0
            }
        default:
            print("Default")
        }
        let myIndexPath = IndexPath(row: sender.tag, section: 0)
//        let cell = self.notificationsTblView.cellForRow(at: myIndexPath) as! NotificationsTableViewCell
//        cell.switch.isOn = true
        self.notificationsTblView.reloadRows(at: [myIndexPath], with: .automatic)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Cards")
        case 1:
            print("Animals Cards")
            self.getAllNotifications(purpose: "Animals")
        default:
            print("Cards")
        }
    }
}


