//
//  NineSGameVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 13/07/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class NineSGameVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var nineSGameTV: UITableView!
    var nineSModelDict = NineSGameModel(JSONString: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nineSGameTV.tableFooterView = UIView()
        getNineSGameDetailsWS()
    }
    //MARK: - Tableview Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nSCell = tableView.dequeueReusableCell(withIdentifier: "NineSGameTVCell", for: indexPath) as! NineSGameTVCell
        
        //nSCell.thruLbl.text = "Thru \(self.nineSModelDict?.thru ?? "")\nEnter Score"
        nSCell.thruLbl.text = "Thru \(self.nineSModelDict?.thru ?? "")"
        
        if self.nineSModelDict?.players != nil && (self.nineSModelDict?.players.count)! <= 3 {
            for (index,item) in self.nineSModelDict!.players.enumerated() {
                let fullName    = item.name ?? ""
                let fullNameArr = fullName.components(separatedBy: " ")
                var nameStr = ""
                if fullNameArr.count > 1 {
                    nameStr = self.getFirstLattersOfSecondName(name: fullNameArr[1]).uppercased()
                }
                
                nameStr = fullNameArr[0].capitalizingFirstLetter() + " " + nameStr
                nSCell.playerNamesLblArr[index].text = "  " + nameStr + "  (\(item.hcp ?? ""))"
                nSCell.playerScoreLblArr[index].text = item.score ?? ""
            }
        }
        nSCell.thruBackBtn.addTarget(self, action: #selector(thruBackBtnTapped(_:)), for: .touchUpInside)
        
        return nSCell
    }
    
    //MARK: - Button Action methods
    @objc func thruBackBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.nineSModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    @IBAction func enterScoreBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gEPSVCObj = storyboard.instantiateViewController(withIdentifier: "GameEditPlayerScoreVC") as! GameEditPlayerScoreVC
        gEPSVCObj.gameId = gameId
        let thru :Int = Int(self.nineSModelDict?.thru ?? "0") ?? 0
        gEPSVCObj.thruValue = thru + 1
        self.navigationController?.pushViewController(gEPSVCObj, animated: true)
    }
    //MARK: - Web service methods
    func getNineSGameDetailsWS() {
        
        let custId = UserDefaults.standard.object(forKey: "CustomerId") as! NSNumber
        let urlString :  String =  MyStrings().getPlayGameDataFromCreateGameUrl + "\(gameId)" + "&customerid=" + "\(custId)"
        
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
            
            let nineS = try! JSONSerialization.data(withJSONObject: dict["NineS"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let nineSString = NSString(data: nineS, encoding: String.Encoding.utf8.rawValue)! as String
            
            self.nineSModelDict = NineSGameModel(JSONString: nineSString)
            
            self.nineSGameTV.reloadData()
        }
    }
    func getFirstLattersOfSecondName(name : String) -> String {
        if name != "" {
            let firstChar = String(name.first!)
            print(firstChar)
            return firstChar
        }else {
            return ""
        }
    }
}
