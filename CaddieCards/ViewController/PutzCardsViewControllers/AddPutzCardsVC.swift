//
//  AddPutzCardsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 19/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift

protocol PutzCardsAddedDelegate {
    func reloadPutzCards()
}

class AddPutzCardsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var putzCardTV: UITableView!
    var putzArr = NSMutableArray()
    var putzCardsArr = NSMutableArray()//["Adult Pack", "Expert Level", "Level Two", "Reverse Play", "Starter Pack"]
    var cardPerPlayerArr = ["2 Cards", "4 Cards", "6 Cards", "8 Cards", "10 Cards", "12 Cards"]
    var onCompletion: ((_ success: Bool) -> ())?
    var putzCardsName : String = ""
    var reloadCardsDelegate: PutzCardsAddedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        putzCardTV.tableFooterView = UIView()
        getPutzCardsWS()
    }
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pCCell = tableView.dequeueReusableCell(withIdentifier: "AddPutzCardsTVCell", for: indexPath) as! AddPutzCardsTVCell
        
        pCCell.putzCardsBtn.addTarget(self, action: #selector(putzCardsBtnTapped(_:)), for: .touchUpInside)
        pCCell.cardPerPlayerBtn.addTarget(self, action: #selector(cardPerPlayerBtnTapped(_:)), for: .touchUpInside)
        pCCell.addFunBtn.addTarget(self, action: #selector(addFunBtnTapped(_:)), for: .touchUpInside)
        return pCCell
    }
    
    //MARK: - Button acton methods
    @objc func putzCardsBtnTapped(_ sender: UIButton) {
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
        FTPopOverMenu.showForSender(sender: sender as UIView,
                                    with: self.putzCardsArr as! [String],
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        let indexPath = IndexPath(row: 0, section: 0)
                                        let cell = self.putzCardTV.cellForRow(at: indexPath as IndexPath) as! AddPutzCardsTVCell
                                        self.putzCardsName = self.putzCardsArr[selectedIndex] as? String ?? ""
                                        cell.putzCardsBtn.setTitle(self.putzCardsArr[selectedIndex] as? String, for: .normal)
        }) {
            
        }
    }
    @objc func cardPerPlayerBtnTapped(_ sender: UIButton) {
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
        FTPopOverMenu.showForSender(sender: sender as UIView,
                                    with: self.cardPerPlayerArr,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                                        let indexPath = IndexPath(row: 0, section: 0)
                                        let cell = self.putzCardTV.cellForRow(at: indexPath as IndexPath) as! AddPutzCardsTVCell
                                        cell.cardPerPlayerBtn.setTitle(self.cardPerPlayerArr[selectedIndex], for: .normal)
        }) {
            
        }
    }
    @objc func addFunBtnTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.putzCardTV.cellForRow(at: indexPath as IndexPath) as! AddPutzCardsTVCell
        var cardPPIntValue: NSInteger = 0
        var params: Parameters = [
            "GameId": gameId
        ]
        if let text = cell.cardPerPlayerBtn.titleLabel?.text {
            print(text)
            cardPPIntValue = (text as NSString).integerValue//Int(text) ?? 0
            params["CardsPerPlayer"] = (text as NSString).integerValue
        }
        if let text = cell.putzCardsBtn.titleLabel?.text {
            print(text)
            params["DeckName"] = text
        }
        print("Add Fun Parameters = \(params)")
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().addFunSubmitUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            if(response.isSuccess){
                if response.responseCode != 200 {
                    return
                }else {
                    print("Add Fun Responce = \(response.responseDictionary)")
                  //  let dict  = response.responseDictionary as NSDictionary
                    DispatchQueue.main.async {
                        self.reloadCardsDelegate?.reloadPutzCards()
                    }
                    self.onCompletion?(true)
                    
                }
            }
        }
    }
    
    //MARK: - Webservice methods
    func getPutzCardsWS() {
        
        let urlString :  String =  MyStrings().getPutzCardsUrl
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
            
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.putzCardTV.cellForRow(at: indexPath as IndexPath) as! AddPutzCardsTVCell
            
            self.putzCardsArr.removeAllObjects()
            
            self.putzArr = (dict as! NSArray).mutableCopy() as! NSMutableArray
            if self.putzArr.count > 0 {
                let teeDict  = self.putzArr[0] as! NSDictionary
                
                cell.putzCardsBtn.setTitle(teeDict["DeckName"] as? String ?? "", for: .normal)
            }
            for tee in self.putzArr {
                let tDict  = tee as! NSDictionary
                self.putzCardsArr.add(tDict["DeckName"] as? String ?? "")
            }
            print("Putz Cards Array = \(self.putzCardsArr)")
        }
    }
    
}
