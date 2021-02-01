//
//  PlayVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 09/12/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit


class PlayVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource, PutzCardsAddedDelegate {
    
    @IBOutlet var tabBtnsList: [UIButton]!
    @IBOutlet weak var videosBtn: UIButton!
    @IBOutlet weak var leaderboardsBtn: UIButton!
    @IBOutlet weak var playersBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var editReplayGameId: NSNumber = 0
    @IBOutlet weak var strokePlayNameLbl: UIButton!
    
    var playGameDetailsDict = PlayGameModel(JSONString: "")
    @IBOutlet weak var collectionVW: UICollectionView!
    @IBOutlet var frinedsMainView: UIView!
    @IBOutlet weak var frinedsView: UIView!
    @IBOutlet weak var friendsTV: UITableView!
    var gameDataDict = NSDictionary()
    
    var animalID = ""
    
    var tabName = "firstTab"
    
    var isCreateGameVC: String = ""
    var addFrndButtonTitle : String = ""
    var isSendCardsDone : Bool = false
    var remianingCards : Int = 0
    var isFromNotificagions : Bool = false
    @IBOutlet weak var animalCV_HeightConst: NSLayoutConstraint!
    let notificationsBtn = BadgedButtonItem(with: UIImage(named: "mini-bell"))
    let editImage   = UIImage(named: "baseline_create_white")!
    var switchOnOffValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "baseline_create_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(editBtnTapped))
        
        let editBtn   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(editBtnTapped))
        self.navigationItem.rightBarButtonItems = [editBtn,notificationsBtn]
        
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        self.title = "Play Game"
        //  self.strokePlayBtnTaaped(UIButton.init())
        
        collectionVW.delegate = self
        collectionVW.dataSource = self
        
        friendsTV.delegate = self
        friendsTV.dataSource = self
        friendsTV.tableFooterView = UIView()
        self.friendsTV.register(UINib(nibName: "SelectFrndPlayVCTVCell", bundle: nil), forCellReuseIdentifier: "SelectFrndPlayVCTVCell")
        
        // getScoreboardDetailsWS()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isCreateGameVC == "CreateGameVC" {
            // Disable the swipe to make sure you get your chance to save
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            // Replace the default back button
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "arrow_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
        }else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            // Replace the default back button
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "arrow_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
        }
        if NotificationGameId.gameId?.count ?? 0 > 0 {
            editReplayGameId = NSNumber.init(value: Int32(NotificationGameId.gameId!)!)
        }
       
       
        self.getScoreboardDetailsWS {
            
            for btn in self.tabBtnsList
            {
                btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
            }
            self.tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
            self.strokePlayBtnTaaped(self.tabBtnsList[0])
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCards), name: NSNotification.Name(rawValue: CardsUpdateNotifications), object: nil)
       
        self.getunReadNotificationsCount()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        frinedsView.layoutIfNeeded()
        let layer = frinedsView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
    }
    
    //MARK: - Webservice methods
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
    
    //MARK: - Button Action Mathods
    @objc func refreshCards(notification: Notification) {
        guard let index = notification.object as? Int else {
                    return
                }
        let btn = tabBtnsList[3]
        if index == 0 {
            self.remianingCards = -1
        }else {
            self.remianingCards = index - 1
        }
        self.caddieCardsBtnTapped( btn)
           
       }
    @objc func goBack() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func videosBtnTapped(_ sender: Any) {
        
    }
    @IBAction func leaderboardsBtnTapped(_ sender: Any) {
    }
    @IBAction func playersBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = editReplayGameId
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    @IBAction func strokePlayBtnTaaped(_ sender: UIButton) {
        
        tabName = "firstTab"
        if self.gameDataDict.object(forKey: "Game") as? String == "Match Play" {
            self.matchPlayVCDisplay()
        }else if self.gameDataDict.object(forKey: "Game") as? String == "9s" {
            self.nineSGameVCDisplay()
        }else if self.gameDataDict.object(forKey: "Game") as? String == "Nassau" {
            self.nassauPlayVCDisplay()
        }else if self.gameDataDict.object(forKey: "Game") as? String == "Wolf" {
            self.wolfGameVCDisplay()
        }else if self.gameDataDict.object(forKey: "Game") as? String == "Longest Shortest" {
            self.longShortGameVCDisplay()
        }else if self.gameDataDict.object(forKey: "Game") as? String == "Swing 6s" {
            self.swingSixsGameVCDisplay()
        }else {
            //Setting Tab colors
            for btn in tabBtnsList
            {
                btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
            }
            tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
            
            //Removeing child view controllers in container view
            self.removeChaildViewControllerInParent()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sPVCObj = storyboard.instantiateViewController(withIdentifier: "StrokePlayVC") as! StrokePlayVC
            sPVCObj.gameId = editReplayGameId
            sPVCObj.onCompletion = { gameName in
                // this will be executed when `someButtonTapped(_:)` will be called
                print(gameName)
                if gameName == "Stroke Play" {
                    self.strokePlayNameLbl.setTitle("Stroke", for: .normal)
                } else {
                  self.strokePlayNameLbl.setTitle(gameName, for: .normal)
                }
            }
            if self.playGameDetailsDict?.playAnimals.count == 0 {
                self.animalCV_HeightConst.constant = 0
            }
            
            addChild(sPVCObj)
            sPVCObj.view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(sPVCObj.view)
            
            NSLayoutConstraint.activate([
                sPVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                sPVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                sPVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                sPVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
            
            sPVCObj.didMove(toParent: self)
        }
    }
    func matchPlayVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mPVCObj = storyboard.instantiateViewController(withIdentifier: "MatchPlayVC") as! MatchPlayVC
        mPVCObj.gameId = editReplayGameId
        
        addChild(mPVCObj)
        mPVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mPVCObj.view)
        
        NSLayoutConstraint.activate([
            mPVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mPVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mPVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            mPVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        mPVCObj.didMove(toParent: self)
    }
    func nassauPlayVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mPVCObj = storyboard.instantiateViewController(withIdentifier: "NassauGameVC") as! NassauGameVC
        mPVCObj.gameId = editReplayGameId
        
        addChild(mPVCObj)
        mPVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mPVCObj.view)
        
        NSLayoutConstraint.activate([
            mPVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mPVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mPVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            mPVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        mPVCObj.didMove(toParent: self)
    }
    func wolfGameVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mPVCObj = storyboard.instantiateViewController(withIdentifier: "WolfGameVC") as! WolfGameVC
        mPVCObj.gameId = editReplayGameId
        mPVCObj.onCompletion = { success in
            // this will be executed when `someButtonTapped(_:)` will be called
            self.scoreBtnTapped(UIButton.init())
        }
        
        addChild(mPVCObj)
        mPVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mPVCObj.view)
        
        NSLayoutConstraint.activate([
            mPVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mPVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mPVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            mPVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        mPVCObj.didMove(toParent: self)
    }
    func longShortGameVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lSGVCObj = storyboard.instantiateViewController(withIdentifier: "LongShortGameVC") as! LongShortGameVC
        lSGVCObj.gameId = editReplayGameId
        lSGVCObj.onCompletion = { success in
            // this will be executed when `someButtonTapped(_:)` will be called
            self.scoreBtnTapped(UIButton.init())
        }
        
        addChild(lSGVCObj)
        lSGVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(lSGVCObj.view)
        
        NSLayoutConstraint.activate([
            lSGVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lSGVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lSGVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            lSGVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        lSGVCObj.didMove(toParent: self)
    }
    func swingSixsGameVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sSVCObj = storyboard.instantiateViewController(withIdentifier: "SwingSixsGameVC") as! SwingSixsGameVC
        sSVCObj.gameId = editReplayGameId
        
        addChild(sSVCObj)
        sSVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sSVCObj.view)
        
        NSLayoutConstraint.activate([
            sSVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sSVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sSVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            sSVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        sSVCObj.didMove(toParent: self)
    }
    func nineSGameVCDisplay() {
        tabName = "firstTab"
        
        //Setting Tab colors
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[0].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nSVCObj = storyboard.instantiateViewController(withIdentifier: "NineSGameVC") as! NineSGameVC
        nSVCObj.gameId = editReplayGameId
        
        addChild(nSVCObj)
        nSVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nSVCObj.view)
        
        NSLayoutConstraint.activate([
            nSVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nSVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nSVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            nSVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        nSVCObj.didMove(toParent: self)
    }
    @IBAction func scoreBtnTapped(_ sender: Any) {
        tabName = "secondTab"
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[1].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scoresVCObj = storyboard.instantiateViewController(withIdentifier: "ScorebordVC") as! ScorebordVC
        scoresVCObj.gameId = editReplayGameId
        scoresVCObj.isFromPlayGameScore = true
        scoresVCObj.playGameDetailsDict = self.gameDataDict
        
        if self.playGameDetailsDict?.playAnimals.count == 0 {
            self.animalCV_HeightConst.constant = 0
        }
        
        addChild(scoresVCObj)
        scoresVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scoresVCObj.view)
        
        NSLayoutConstraint.activate([
            scoresVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scoresVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scoresVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            scoresVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        scoresVCObj.didMove(toParent: self)
    }
    @IBAction func holeBtnTapped(_ sender: Any) {
        tabName = "thirdTab"
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[2].backgroundColor = GlobalConstants.APPGREENCOLOR
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let holeVCObj = storyboard.instantiateViewController(withIdentifier: "HoleVC") as! HoleVC
        holeVCObj.gameId = editReplayGameId
        
        if self.playGameDetailsDict?.playAnimals.count == 0 {
            self.animalCV_HeightConst.constant = 0
        }
        
        addChild(holeVCObj)
        holeVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(holeVCObj.view)
        
        NSLayoutConstraint.activate([
            holeVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            holeVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            holeVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            holeVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        holeVCObj.didMove(toParent: self)
    }
    func fetchUPdatedPutzCall() {
        
    }
    @IBAction func caddieCardsBtnTapped(_ sender: Any) {
        tabName = "fourthTab"
        for btn in tabBtnsList
        {
            btn.backgroundColor = GlobalConstants.PLAYGAMETABCOLORS
        }
        tabBtnsList[3].backgroundColor = GlobalConstants.APPGREENCOLOR
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let putzCards = self.gameDataDict.object(forKey: "PutzCards") as? String
        if putzCards == "No" {
            let cardsVCObj = storyboard.instantiateViewController(withIdentifier: "AddPutzCardsVC") as! AddPutzCardsVC
            cardsVCObj.gameId = editReplayGameId
            cardsVCObj.reloadCardsDelegate = self
            cardsVCObj.onCompletion = { success in
                // this will be executed when `someButtonTapped(_:)` will be called
                if self.tabName == "firstTab" {
                    if self.gameDataDict.object(forKey: "Game") as? String == "Match Play" {
                        self.matchPlayVCDisplay()
                    }else if self.gameDataDict.object(forKey: "Game") as? String == "9s" {
                        self.nineSGameVCDisplay()
                    }else if self.gameDataDict.object(forKey: "Game") as? String == "Nassau" {
                        self.nassauPlayVCDisplay()
                    }else if self.gameDataDict.object(forKey: "Game") as? String == "Swing 6s" {
                        self.swingSixsGameVCDisplay()
                    }else if self.gameDataDict.object(forKey: "Game") as? String == "Wolf" {
                        self.wolfGameVCDisplay()
                    }else if self.gameDataDict.object(forKey: "Game") as? String == "Longest Shortest" {
                        self.longShortGameVCDisplay()
                    }else {
                        self.strokePlayBtnTaaped(UIButton.init())
                    }
                }else if self.tabName == "secondTab" {
                    self.scoreBtnTapped(UIButton.init())
                }else if self.tabName == "thirdTab" {
                    self.holeBtnTapped(UIButton.init())
                }else {
                    self.caddieCardsBtnTapped(UIButton.init())
                }
            }
            if self.playGameDetailsDict?.playAnimals.count == 0 {
                self.animalCV_HeightConst.constant = 0
            }
            addChild(cardsVCObj)
            cardsVCObj.view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(cardsVCObj.view)
            NSLayoutConstraint.activate([
                cardsVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                cardsVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                cardsVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                cardsVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            cardsVCObj.didMove(toParent: self)
        }else {
            if (putzCards == "Yes" && self.playGameDetailsDict?.playerCards.count == 0 ) || (self.remianingCards == -1 ) {
                let cardsVCObj = storyboard.instantiateViewController(withIdentifier: "PutzCardsNoVC") as! PutzCardsNoVC
                if self.playGameDetailsDict?.playAnimals.count == 0 {
                    self.animalCV_HeightConst.constant = 0
                }
                addChild(cardsVCObj)
                cardsVCObj.view.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(cardsVCObj.view)
                NSLayoutConstraint.activate([
                    cardsVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    cardsVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    cardsVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    cardsVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
                cardsVCObj.didMove(toParent: self)
            }else {
                let cardsVCObj = storyboard.instantiateViewController(withIdentifier: "PutzCardsDisplayVC") as! PutzCardsDisplayVC
                cardsVCObj.gameId = editReplayGameId
               
                if self.playGameDetailsDict?.playAnimals.count == 0 {
                    
                    self.animalCV_HeightConst.constant = 0
                    
                }
                addChild(cardsVCObj)
                cardsVCObj.view.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(cardsVCObj.view)
                NSLayoutConstraint.activate([
                    
                    cardsVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    
                    cardsVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    
                    cardsVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    
                    cardsVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                    
                ])
                cardsVCObj.didMove(toParent: self)
            }
        }
    }


    @IBAction func cancelFrndViewBtnTapped(_ sender: Any) {
        self.frinedsMainView.removeFromSuperview()
    }
    @objc func editBtnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cGameVCObj = storyboard.instantiateViewController(withIdentifier: "CreateGameVC") as! CreateGameVC
        cGameVCObj.editReplayGameId = editReplayGameId
        cGameVCObj.isEditVC = true
        self.navigationController?.pushViewController(cGameVCObj, animated: true)
    }
    
    //MARK: - Web Service Methods
    func getScoreboardDetailsWS(completionHandler: @escaping () -> Void) {
        
        var urlString :  String = ""
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        urlString  =  MyStrings().getPlayGameDataFromCreateGameUrl + "\(editReplayGameId)" + "&customerid=" + "\(custId)&From=play"
        
        //  self.startLoadingIndicator(loadTxt: "Loading...") //Commented due to loading two indicators
        
        ApiCall.postServercall(onView:self, url: urlString, httpMethod: .get, loading: self) { (response) in
            
            print(response as Any)
            
            let isError = response.isSuccess
            print(isError)
            guard isError == true else {
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                self.errorAlert(message ?? "")
                return
            }
            print(response.responseDictionary)
            let dict = response.responseDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            self.gameDataDict = dict["GameData"] as! NSDictionary
            if self.gameDataDict.object(forKey: "Game") as! String == "Longest Shortest" {
               self.strokePlayNameLbl.setTitle("S / L", for: .normal)
            }else if self.gameDataDict.object(forKey: "Game") as! String == "Match Play" {
                self.strokePlayNameLbl.setTitle("Match", for: .normal)
            }else if self.gameDataDict.object(forKey: "Game") as! String == "Stroke Play" {
                self.strokePlayNameLbl.setTitle("Stroke", for: .normal)
            } else {
              self.strokePlayNameLbl.setTitle((self.gameDataDict.object(forKey: "Game") as! String), for: .normal)
            }
            if self.tabName == "firstTab" {
                if self.gameDataDict.object(forKey: "Game") as? String == "Match Play" {
                    self.matchPlayVCDisplay()
                }else if self.gameDataDict.object(forKey: "Game") as? String == "9s" {
                    self.nineSGameVCDisplay()
                }else if self.gameDataDict.object(forKey: "Game") as? String == "Nassau" {
                    self.nassauPlayVCDisplay()
                }else if self.gameDataDict.object(forKey: "Game") as? String == "Swing 6s" {
                    self.swingSixsGameVCDisplay()
                }else if self.gameDataDict.object(forKey: "Game") as? String == "Wolf" {
                    self.wolfGameVCDisplay()
                }else if self.gameDataDict.object(forKey: "Game") as? String == "Longest Shortest" {
                    self.longShortGameVCDisplay()
                }else {
                    self.strokePlayBtnTaaped(UIButton.init())
                }
            }
            
            self.playGameDetailsDict = PlayGameModel(JSONString: jsonString)
            
            for _ in (self.playGameDetailsDict?.playPlayers)! {
                self.switchOnOffValues.append("false")
            }
            if self.playGameDetailsDict?.playAnimals.count == 0 {
                self.animalCV_HeightConst.constant = 0
            }else {
                self.collectionVW.reloadData()
            }
            completionHandler()
            
        }
    }
    func addAnimalToCustomerWS(animalId: String, customerId: String) {
        let params: Parameters = [
            "AnimalId": animalId,
            "CustomerId": customerId,
            "GameId": editReplayGameId
        ]
        print("add animal to customer Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().addAnimalToCustomerUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                print("Create Group Responce = \(response.responseDictionary)")
                self.frinedsMainView.removeFromSuperview()
                self.getScoreboardDetailsWS {
                    
                }
                
            }
        }
    }
    func deleteAnimalToCustomerWS(animalId: String, customerId: String) {
        let params: Parameters = [
            "GameId": editReplayGameId,
            "CustomerId": customerId,
            "AnimalId": animalId,
            "Purpose": "delete"
        ]
        print("delete animal to customer Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().deleteAnimaltoCustomerWSUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                print("Delete Animal Responce = \(response.responseDictionary)")
                self.frinedsMainView.removeFromSuperview()
                self.getScoreboardDetailsWS {
                    
                }
                
            }
        }
    }
    
    //MARK: - Collection view delegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.playGameDetailsDict?.playAnimals.count ?? 0
        //  return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayFriendsCVcell", for: indexPath) as? PlayFriendsCVcell
        
        cell1?.addFriendBtn.setTitle("+", for: .normal)
        cell1?.addFriendBtn.tag = 200 + indexPath.row
        cell1?.addFriendBtn.addTarget(self, action: #selector(addFrndBtnTapped(_:)), for: .touchUpInside)
        
        let scorecard = self.playGameDetailsDict?.scoreBoard[0]
        
        //        for (index2, item2) in (scorecard!.players.enumerated()) {
        //            print("Found \(item2) at position \(index2)")
        //
        //            if ((self.playGameDetailsDict?.playPlayerAnimals) != nil) {
        //                let animal = self.playGameDetailsDict?.playPlayerAnimals[indexPath.row]
        //
        //                let animalId = item2.customerId
        //                if animalId == animal!.playerId {
        //                    cell1?.addFriendBtn.setTitle("\(self.getFirstLattersOfStingBySpace(name: item2.name ?? "").uppercased())", for: .normal)
        //                }
        //            }
        //        }
        let animal = self.playGameDetailsDict?.playAnimals[indexPath.row]
        for (index2, item2) in ((self.playGameDetailsDict?.playPlayerAnimals.enumerated())!) {
            print("Found \(item2) at position \(index2)")
            if String(animal!.animalId) == item2.AnimalId {
                
                for (index3, item3) in (scorecard!.players.enumerated()) {
                    print("Found \(item3) at position \(index3)")
                    let custId = item3.customerId
                    if item2.playerId == custId {
                        cell1?.addFriendBtn.setTitle("\(self.getFirstLattersOfStingBySpace(name: item3.name ?? "").uppercased())", for: .normal)
                    }
                }
            }
        }
        
        cell1?.animalImgBtn.tag = 300 + indexPath.row
        cell1?.animalImgBtn.addTarget(self, action: #selector(animalImgBtnTapped(_:)), for: .touchUpInside)
        if indexPath.row < (self.playGameDetailsDict?.playAnimals.count)! {
            let animal = self.playGameDetailsDict?.playAnimals[indexPath.row]
            
            /*
             var imageNameStr = ""
             if animal?.animal ?? "" == "The Dog" {
             imageNameStr = "dog"
             }
             else if animal?.animal ?? "" == "The Fish" {
             imageNameStr = "menu_fish"
             }
             else if animal?.animal ?? "" == "The Camel" {
             imageNameStr = "camel"
             }
             else if animal?.animal ?? "" == "The Bird" {
             imageNameStr = "bird"
             }
             else if animal?.animal ?? "" == "The Snake" {
             imageNameStr = "menu_snake"
             }
             else if animal?.animal ?? "" == "The Squirrel" {
             imageNameStr = "squirrel"
             }
             else if animal?.animal ?? "" == "The Monkey" {
             imageNameStr = "monkey"
             }
             else if animal?.animal ?? "" == "The Turtle" {
             imageNameStr = "tortoise"
             }
             else if animal?.animal ?? "" == "The Skunk" {
             imageNameStr = "skunk"
             }
             else if animal?.animal ?? "" == "The Egle" {
             imageNameStr = "menu_egle"
             }else if animal?.animal ?? "" == "The Elephant" {
             imageNameStr = "menu_elephant"
             }else if animal?.animal ?? "" == "The Rabbit" {
             imageNameStr = "menu_rabbit"
             }else {
             imageNameStr = ""
             }
             */
            // cell1?.animalImgBtn.setImage(UIImage.init(named: imageNameStr), for: .normal)
            let diceRoll = Int(arc4random_uniform(UInt32(6)))
            let urlStr = String(format: "%@?rn=%@",(animal?.animalIcon)!,String(diceRoll))
            //  let url = URL(string: urlStr)!
            
            cell1?.animalBottomImg.sd_setImage(with: URL(string: urlStr), completed: nil)
            
        }
        
        return cell1!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width/5.0 - 3
        return CGSize(width: yourWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Tableview Delegate and Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.playGameDetailsDict?.playPlayers.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let frndDict  = self.playGameDetailsDict?.playPlayers[indexPath.row]
        let sFCell = tableView.dequeueReusableCell(withIdentifier: "SelectFrndPlayVCTVCell", for: indexPath) as! SelectFrndPlayVCTVCell
        
        
        
        // sFCell.frndNameLbl.font = UIFont.boldSystemFont(ofSize: 15)
        sFCell.frndNameLbl.textColor = UIColor.black
        sFCell.frndNameLbl.text = frndDict?.plr ?? ""
        
        if self.addFrndButtonTitle == self.getFirstLattersOfStingBySpace(name: frndDict?.plr ?? "").uppercased() {
            self.switchOnOffValues[indexPath.row] = "true"
            addFrndButtonTitle = ""
        }
        
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let userId =  (frndDict?.customerId ?? "")
        let urlStr = String(format: "%@.gif?rd=%@",userId,String(diceRoll))
        let ProfilePicUrl = AVATARURL + urlStr
        sFCell.frndImgView.sd_setImage(with: URL(string: ProfilePicUrl), completed: nil)
        if sFCell.frndImgView.image == nil {
            sFCell.frndImgView.image = UIImage.init(named: "avatar_male")
        }
        
        print("Swicth Values = \(switchOnOffValues)")
        
        if switchOnOffValues[indexPath.row] == "false" {
            sFCell.frndOnOff_Switch.setOn(false, animated:true)
        }else {
            sFCell.frndOnOff_Switch.setOn(true, animated:true)
        }
        
        sFCell.frndOnOff_Switch.addTarget(self, action: #selector(switchChanged), for:UIControl.Event.valueChanged)
        sFCell.frndOnOff_Switch.tag = indexPath.row
        return sFCell
    }
    //MARK: - Add Frineds Action Methods
    
    @objc func switchChanged(mySwitch: UISwitch) {
        
        self.switchOnOffValues.removeAll()
        for _ in (self.playGameDetailsDict?.playPlayers)! {
            self.switchOnOffValues.append("false")
        }
        if mySwitch.isOn {
            self.switchOnOffValues[mySwitch.tag] = "true"
            let player = self.playGameDetailsDict?.playPlayers[mySwitch.tag]
            self.addAnimalToCustomerWS(animalId: animalID, customerId: player?.customerId ?? "")
        }else {
            self.switchOnOffValues[mySwitch.tag] = "false"
            //  self.showDeleteCustomerAlert(switchTag: mySwitch)
            let player = self.playGameDetailsDict?.playPlayers[mySwitch.tag]
            self.deleteAnimalToCustomerWS(animalId: self.animalID, customerId: player?.customerId ?? "")
        }
        friendsTV.reloadData()
    }
    
    @objc func addBtnTapped(_ sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.friendsTV)
        let indexPath = self.friendsTV.indexPathForRow(at: buttonPosition)
        
        let player = self.playGameDetailsDict?.playPlayers[indexPath!.row]
        self.addAnimalToCustomerWS(animalId: animalID, customerId: player?.customerId ?? "")
    }
    
    //MARK: - Alert Controller
    func showDeleteCustomerAlert(switchTag : UISwitch) {
        let alert = UIAlertController(title: "Alert", message: "Do you wan't delete the animal for this player?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: { _ in
            //Cancel Action
            self.switchOnOffValues[switchTag.tag] = "true"
            self.friendsTV.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "YES",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        let player = self.playGameDetailsDict?.playPlayers[switchTag.tag]
                                        self.deleteAnimalToCustomerWS(animalId: self.animalID, customerId: player?.customerId ?? "")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Group Action Methods
    @objc func addFrndBtnTapped(_ sender: UIButton) {
        
        self.switchOnOffValues.removeAll()
        for _ in (self.playGameDetailsDict?.playPlayers)! {
            self.switchOnOffValues.append("false")
        }
        if let buttonTitle = sender.title(for: .normal) {
            print(buttonTitle)
            
            addFrndButtonTitle = String(describing: buttonTitle)
        }
        
        let animal = self.playGameDetailsDict?.playAnimals[sender.tag - 200]
        animalID = String(animal!.animalId)
        
        self.frinedsMainView.frame = self.view.frame
        
        self.view.addSubview(self.frinedsMainView)
        self.view.bringSubviewToFront(self.frinedsMainView)
        self.frinedsMainView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.tag = 200
        self.frinedsMainView.addGestureRecognizer(tap)
        
        self.friendsTV.reloadData()
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        if let tap = sender {
            let point = tap.location(in: frinedsView)
            if frinedsView.point(inside: point, with: nil) == false {
                // write your stuff here
                self.frinedsMainView.removeFromSuperview()
            }
        }
        
    }
    @objc func animalImgBtnTapped(_ sender: UIButton) {
        let animal = self.playGameDetailsDict?.playAnimals[sender.tag - 300]
        print(animal?.animalDiscription ?? "")
        
        //Removeing child view controllers in container view
        self.removeChaildViewControllerInParent()
        
        if self.tabName == "firstTab" {
            self.strokePlayBtnTaaped(UIButton.init())
        }else if self.tabName == "secondTab" {
            self.scoreBtnTapped(UIButton.init())
        }else if self.tabName == "thirdTab" {
            self.holeBtnTapped(UIButton.init())
        }else {
            self.caddieCardsBtnTapped(UIButton.init())
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aAVCObj = storyboard.instantiateViewController(withIdentifier: "AnimalAnimationVC") as! AnimalAnimationVC
        
        let scorecard = self.playGameDetailsDict?.scoreBoard[0]
        for (index2, item2) in ((self.playGameDetailsDict?.playPlayerAnimals.enumerated())!) {
            print("Found \(item2) at position \(index2)")
            if String(animal!.animalId) == item2.AnimalId {
                
                for (index3, item3) in (scorecard!.players.enumerated()) {
                    print("Found \(item3) at position \(index3)")
                    let custId = item3.customerId
                    if item2.playerId == custId {
                        // cell1?.addFriendBtn.setTitle("\(self.getFirstLattersOfStingBySpace(name: item3.name ?? "").uppercased())", for: .normal)
                        aAVCObj.custName = (item3.name ?? "").uppercased()
                    }
                }
            }
        }
        aAVCObj.descriptionStr = animal?.animalDiscription ?? ""
        aAVCObj.urlString = animal?.animalIcon ?? ""
        
        aAVCObj.onCancelDoneAnimalView = { gameName in
            self.removeChaildViewControllerInParent()
            
            if self.tabName == "firstTab" {
                self.strokePlayBtnTaaped(UIButton.init())
            }else if self.tabName == "secondTab" {
                self.scoreBtnTapped(UIButton.init())
            }else if self.tabName == "thirdTab" {
                self.holeBtnTapped(UIButton.init())
            }else {
                self.caddieCardsBtnTapped(UIButton.init())
            }
        }
        
        addChild(aAVCObj)
        aAVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(aAVCObj.view)
        
        NSLayoutConstraint.activate([
            aAVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            aAVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            aAVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            aAVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        aAVCObj.didMove(toParent: self)
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
    func reloadPutzCards() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cardsVCObj = storyboard.instantiateViewController(withIdentifier: "PutzCardsDisplayVC") as! PutzCardsDisplayVC
        cardsVCObj.gameId = editReplayGameId
       
        if self.playGameDetailsDict?.playAnimals.count == 0 {

            self.animalCV_HeightConst.constant = 0

        }
        addChild(cardsVCObj)
        cardsVCObj.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cardsVCObj.view)
        NSLayoutConstraint.activate([

            cardsVCObj.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            cardsVCObj.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            cardsVCObj.view.topAnchor.constraint(equalTo: containerView.topAnchor),

            cardsVCObj.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)

        ])
        cardsVCObj.didMove(toParent: self)
    }
}
