//
//  PutzCardsDisplayVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 19/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class PutzCardsDisplayVC: BaseViewController, UITableViewDataSource,UITableViewDelegate {

    var gameId: NSNumber = 0
    @IBOutlet weak var putzCardsDisTV: UITableView!
    var putzCardsDetailsDict = PlayGameModel(JSONString: "")
    var indexId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        putzCardsDisTV.tableFooterView = UIView()
        getPutzCardsDisplayWS()
    }
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pCCell = tableView.dequeueReusableCell(withIdentifier: "PutzCardsDisplayTVCell", for: indexPath) as! PutzCardsDisplayTVCell
        
        let putzCardDict = self.putzCardsDetailsDict?.playerCards?[indexId]
        pCCell.titleLbl.text = putzCardDict?.cardName ?? ""
        pCCell.descriptionLbl.text = putzCardDict?.cardDescription
        
      //  pCCell.nextCardBtn.addTarget(self, action: #selector(nextCardBtnTapped(_:)), for: .touchUpInside)
      //  pCCell.playCardBtn.addTarget(self, action: #selector(playCardBtnTapped(_:)), for: .touchUpInside)
        return pCCell
    }
    //MARK: - Button acton methods
    
    @IBAction func nextCardBtnTapped(_ sender: Any) {
        if (self.putzCardsDetailsDict?.playerCards?.count ?? 0) == (indexId + 1) {
            indexId = 0
        }else {
            indexId += 1
        }
        self.putzCardsDisTV.reloadData()
    }
    
    @IBAction func playCardBtnTapped(_ sender: Any) {
        let putzCardDict = self.putzCardsDetailsDict?.playerCards?[indexId]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sPCVCObj = storyboard.instantiateViewController(withIdentifier: "SendPutzCardVC") as! SendPutzCardVC
        sPCVCObj.gameId = gameId
        sPCVCObj.cardName = putzCardDict?.cardName ?? ""
        sPCVCObj.cardId = NSNumber.init(value: Int((putzCardDict?.cardId)!)!)
        sPCVCObj.card = putzCardDict?.card ?? ""
        sPCVCObj.cardDescription = putzCardDict?.cardDescription ?? ""
        sPCVCObj.putzCardsDetailsDict = self.putzCardsDetailsDict
        sPCVCObj.cardsRemaining = self.putzCardsDetailsDict?.playerCards?.count ?? 0
        self.navigationController?.pushViewController(sPCVCObj, animated: true)
    }
    
    //MARK: - Webservice methods
    func getPutzCardsDisplayWS() {
        
        var urlString :  String = ""
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        
        urlString  =  MyStrings().getPlayGameDataFromCreateGameUrl + "\(gameId)" + "&customerid=" + "\(custId)&From=play&purpose=cards"
        
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
            
            self.putzCardsDetailsDict = PlayGameModel(JSONString: jsonString)
            self.putzCardsDisTV.reloadData()
        }
    }
}
