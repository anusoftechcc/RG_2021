//
//  SendPutzCardVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 20/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit
let CardsUpdateNotifications : String = "CardsUpdateNotifications"
class SendPutzCardVC: BaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    var gameId: NSNumber = 0
    let userId=UserDefaults.standard.object(forKey: "CustomerId") as! NSInteger
    @IBOutlet weak var playCardTV: UITableView!
    var radioSelctionArr = NSMutableArray()
    var putzCardsDetailsDict = PlayGameModel(JSONString: "")
    var cardName : String = ""
    var cardId: NSNumber = 0
    var card : String = ""
    var cardDescription : String = ""
    @IBOutlet weak var cardNameLbl: UILabel!
    
    @IBOutlet var sentPutzCardView: ViewCardWindowView!
    @IBOutlet weak var sendPutzCardBtnView: UIView!
    @IBOutlet weak var sendPutzCardBtn: UIButton!
    var toCustomerId: NSNumber = 0
    var isSelectedPlayer : Bool = false
    @IBOutlet weak var titleSentCardLbl: UILabel!
    
    @IBOutlet weak var cancelSentCardBtn: UIButton!
  ////  @IBOutlet weak var sentPutzCardView: UIView!
    @IBOutlet weak var cardShadowView: UIView!
    var alert = UIAlertController()
    var cardsRemaining: Int = 0
    var isFromNotification : Bool = false
    var senderName : String = ""
  //  var gameId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PLAY GAME"
        if self.isFromNotification == true {
            self.displayNotification()
        }else {
            let scorecard = self.putzCardsDetailsDict?.scoreBoard[0]
            for (index3, item3) in (scorecard!.players.enumerated()) {
                print("Found \(item3) at position \(index3)")
                radioSelctionArr.add("false")
            }
            cardNameLbl.text = cardName
            playCardTV.tableFooterView = self.sendPutzCardBtnView
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if self.isFromNotification == true {
//            UIApplication.shared.keyWindow?.addSubview((self.sentPutzCardView)!)
//            UIApplication.shared.keyWindow!.bringSubviewToFront((self.sentPutzCardView)!)
//        if let window = UIApplication.shared.keyWindow, let view = window.rootViewController?.view
//            {
//            sentPutzCardView.translatesAutoresizingMaskIntoConstraints = false
//                    let height = NSLayoutConstraint(item: sentPutzCardView, attribute: .height, relatedBy: .equal, toItem: window, attribute: .height, multiplier: 1, constant: 0)
//                    let offset = NSLayoutConstraint(item: sentPutzCardView, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0)
//
//                    view.addConstraints([height, offset])
//            }
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.isFromNotification = false
    }
    func displayNotification() {
        self.sentPutzCardView.frame = self.view.frame
        self.sentPutzCardView.accessibilityIdentifier = "notification"
        UIApplication.shared.keyWindow?.addSubview((self.sentPutzCardView)!)
        UIApplication.shared.keyWindow!.bringSubviewToFront((self.sentPutzCardView)!)
        self.titleSentCardLbl.text = "\(self.senderName) Sent You A Putz Card"
        self.sentPutzCardView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scorecard = self.putzCardsDetailsDict?.scoreBoard[0]
        return scorecard?.players.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pCCell = tableView.dequeueReusableCell(withIdentifier: "PutzCardUserNameTVCell", for: indexPath) as! PutzCardUserNameTVCell
        let scorecard = self.putzCardsDetailsDict?.scoreBoard[0]
        let player = scorecard?.players[indexPath.row]
        pCCell.userNameLbl.text = "\(self.getFirstLattersOfStingBySpace(name: player?.name ?? "").uppercased())"
        let fullName    = player?.name ?? ""
        if player?.name == "" || player?.name == nil {
            pCCell.userNameLbl.text = ""
        }else {
            let fullNameArr = fullName.components(separatedBy: " ")
            if fullNameArr.count > 1 {
                let secondNameFL = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                pCCell.userNameLbl.text = "\(fullNameArr[0]) \(secondNameFL)"
            }else {
                pCCell.userNameLbl.text = "\(fullNameArr[0])"
            }
        }
        
        if radioSelctionArr[indexPath.row] as? String == "false" {
            pCCell.radioBtn.setImage(UIImage.init(named: "radio_button_unchecked"), for: .normal)
        }else {
            let image = UIImage(named: "radio_button_checked")?.withRenderingMode(.alwaysTemplate)
            pCCell.radioBtn.setImage(image, for: .normal)
            pCCell.radioBtn.tintColor = GlobalConstants.RADIOBTNCOLORS
        }
        
        pCCell.radioBtn.addTarget(self, action: #selector(radioBtnTapped(_:)), for: .touchUpInside)
        return pCCell
    }
    //MARK: - Button acton methods
    @objc func radioBtnTapped(_ sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.playCardTV)
        let indexPath = self.playCardTV.indexPathForRow(at: buttonPosition)
        let scorecard = self.putzCardsDetailsDict?.scoreBoard[0]
        let player = scorecard?.players[indexPath!.row]
        
        radioSelctionArr.removeAllObjects()
        for (index3, item3) in (scorecard!.players.enumerated()) {
            print("Found \(item3) at position \(index3)")
            isSelectedPlayer = false
            radioSelctionArr.add("false")
        }
        
        let cell = self.playCardTV.cellForRow(at: indexPath! as IndexPath) as! PutzCardUserNameTVCell
        if (cell.radioBtn.currentImage?.isEqual(UIImage(named: "radio_button_unchecked")))! {
            radioSelctionArr.replaceObject(at: indexPath!.row, with: "true")
            toCustomerId = NSNumber.init(value: Int((player?.customerId)!)!)
            self.titleSentCardLbl.text = "\(player?.name ?? "") Sent You A Putz Card"
            isSelectedPlayer = true
            self.playCardTV.reloadData()
        }
    }
    @IBAction func sendPutzCardBtnTapped(_ sender: Any) {
        
        let params: Parameters = [
            "GameId": gameId,
            "FromCustomerId": userId,
            "ToCustomerId" : toCustomerId,
            "CardId" : cardId,
            "Card" : card
        ]
        
        print("Send Putz Card Parameters = \(params) and url = \(MyStrings().sendPutzCardUrl)")
        if isSelectedPlayer == true {
            self.startLoadingIndicator(loadTxt: "Loading...")
            ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().sendPutzCardUrl, urlParams: params as [String : AnyObject]) { (response) in
                print(response as Any)
                
                if(response.isSuccess){
                    if response.responseCode != 200 {
                        return
                    }else {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: CardsUpdateNotifications), object: self.cardsRemaining - 1)
                            
                        }
                        print("Send Putz Card Responce = \(response.responseDictionary)")
                        //  let dict  = response.responseDictionary as NSDictionary
                        self.alert = UIAlertController(title: "\(self.cardName)", message: "Putz Card Sent", preferredStyle: UIAlertController.Style.alert)
                        
                        self.alert.addAction(UIAlertAction(title: "VIEW DECK",
                                                           style: UIAlertAction.Style.default,
                                                           handler: {(_: UIAlertAction!) in
                                                            // self.deleteGroupWS(userId: userId, groupId: groupId)
                                                            self.sentPutzCardView.removeFromSuperview()
                                                            
                                                            self.navigationController?.popViewController(animated: true)
                                                            // self.sendPushNotificationAPI()
                                                           }))
                        self.alert.addAction(UIAlertAction(title: "CANCEL",
                                                           style: UIAlertAction.Style.default,
                                                           handler: {(_: UIAlertAction!) in
                                                            
                        }))
                        
                        self.present(self.alert, animated: true, completion: nil)
                        
                        if self.userId == Int(truncating: self.toCustomerId) {
                            self.sentPutzCardView.frame = self.view.frame
                            // self.view.addSubview(self.sentPutzCardView)
                            //   alert.view.bringSubviewToFront(self.sentPutzCardView)
                            UIApplication.shared.keyWindow?.addSubview(self.sentPutzCardView)
                            UIApplication.shared.keyWindow!.bringSubviewToFront(self.sentPutzCardView)
                            self.sentPutzCardView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                        }
                    }
                }
            }
        }else {
            self.errorAlert("Please select a player to send card")
        }
    }
    func getFirstLattersOfStingBySpace(name : String) -> String {
        let wordArray = name.split(separator: " ")
        if wordArray.count >= 2 {
            let firstTwoChar = String(wordArray[0].first!) + " " + String(wordArray[1].first!)
            print(firstTwoChar)
            return firstTwoChar
        }
        return ""
    }
    @IBAction func cancelSentCardBtnTapped(_ sender: Any) {
       
        if self.isFromNotification || self.sentPutzCardView.accessibilityIdentifier == "notification" {
            self.sentPutzCardView.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }else {
            self.sentPutzCardView.removeFromSuperview()
        }
        
    }
    @IBAction func viewCardBtnTapped(_ sender: Any) {
       //
      let subviews = UIApplication.shared.keyWindow!.subviews
        for subview in subviews {
            if subview.isKind(of: ViewCardWindowView.self) {
                subview.removeFromSuperview()
            }
            
        }
      //  self.sentPutzCardView.removeFromSuperview()
      //  self.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow!.bringSubviewToFront(self.view)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sPCVCObj = storyboard.instantiateViewController(withIdentifier: "ReceivedCardsVC") as! ReceivedCardsVC
        sPCVCObj.cardName = cardName
        sPCVCObj.cardDescription = cardDescription
        sPCVCObj.isFromNotifications = self.isFromNotification
        sPCVCObj.gameId = "\(gameId)"
        self.navigationController?.pushViewController(sPCVCObj, animated: true)
    }
    
    //MARK: - Custome Methods
    func getFirstLattersOfSecondName(name : String) -> String {
        if name != "" {
            let firstChar = String(name.first!)
            print(firstChar)
            return firstChar
        }else {
            return ""
        }
    }
    
    func sendPushNotificationAPI() {
        
        let cardDetails: Parameters = [
            "SenderName": userId,
            "GameId": gameId,
            "CardId" : cardId,
            "CardName" : cardName,
            "CardDescription" : "Make any one player hit the next shot on One Leg!"
        ]
        
        let params: Parameters = [
            "DeviceToken": Token.fcmToken!,
            "NotificationText": "Test",
            "IOS" : "Yes",
            "CardDetails" : cardDetails
        ]
        
        print("Send Putz Card notifications = \(params) and url = \(MyStrings().sendPushNotificationUrl)")
      //  if isSelectedPlayer == true {
            self.startLoadingIndicator(loadTxt: "Loading...")
            ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().sendPushNotificationUrl, urlParams: params as [String : AnyObject]) { [weak self] (response) in
                print(response as Any)
                
                if(response.isSuccess){
                    if response.responseCode != 200 {
                        return
                    }else {
                        print("Send Putz Card Responce = \(response.responseDictionary)")
                        //  let dict  = response.responseDictionary as NSDictionary
                        self?.alert = UIAlertController(title: "\(self?.cardName)", message: "Putz Card Sent",         preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "VIEW DECK", style: .default) { (_) in
                            self?.navigationController?.popViewController(animated: true)
                        }
//                        self?.alert.addAction(UIAlertAction(title: "VIEW DECK",
//                                                           style: UIAlertAction.Style.default,
//                                                           handler: {(_: UIAlertAction!) in
//                                                            // self.deleteGroupWS(userId: userId, groupId: groupId)
//                                                            self?.navigationController?.popViewController(animated: true)
//                        }))
                        self?.alert.addAction(action)
                        
                        self?.present(self!.alert, animated: true, completion: nil)
                        
                        if self?.userId == Int(truncating: self!.toCustomerId) {
                            self?.sentPutzCardView.frame = (self?.view.frame)!
                            // self.view.addSubview(self.sentPutzCardView)
                            //   alert.view.bringSubviewToFront(self.sentPutzCardView)
                            UIApplication.shared.keyWindow?.addSubview((self?.sentPutzCardView)!)
                            UIApplication.shared.keyWindow!.bringSubviewToFront((self?.sentPutzCardView)!)
                            self?.sentPutzCardView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                        }
                    }
                }
            }
//        }else {
//            self.errorAlert("Please select a player to send card")
//        }
    }
}
