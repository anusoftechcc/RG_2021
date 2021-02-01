//
//  GameRulesVC.swift
//  
//
//  Created by Madhusudhan Reddy on 18/11/20.
//

import UIKit

class GameRulesVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var headerLbl: UILabel!
    var gameId :  NSInteger = 0
    var bodyString = ""
    @IBOutlet weak var gameRulesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GAME RULES"
        
        gameRulesTV.estimatedRowHeight = 44.0
        gameRulesTV.rowHeight = UITableView.automaticDimension
        
        getGameRulesWS()
    }
    //MARK: - Web Service Methods
    func getGameRulesWS() {
        
        let urlString :  String =  MyStrings().getGameRulesWS + "\(gameId)"
        self.startLoadingIndicator(loadTxt: "Loading...")
        
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
            self.headerLbl.text = dict["Header"] as? String ?? ""
            self.bodyString = dict["Body"] as? String ?? ""
            self.gameRulesTV.reloadData()
        }
    }
    //MARK: - TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameRulesTableViewCell", for: indexPath) as! GameRulesTableViewCell
        
        cell.bodyLbl.text = self.bodyString
        
        return cell
    }
}
