//
//  HoleVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 26/02/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class HoleVC: BaseViewController {
    
    var gameId: NSNumber = 0
    @IBOutlet weak var holeDetailsView: UIView!
    var playGameDetailsDict = PlayGameModel(JSONString: "")
    var playGameModelDict = PlayGameDataModel(JSONString: "")
    var gameDatadict = NSMutableDictionary()
    var scoreboardArray = NSMutableArray()
    var playersArray = NSMutableArray()
    
    @IBOutlet weak var holeLbl: UILabel!
    @IBOutlet weak var parLbl: UILabel!
    @IBOutlet weak var ydsLbl: UILabel!
    @IBOutlet weak var hcpLbl: UILabel!
    @IBOutlet weak var holeImg: UIImageView!
    
    var currentIndex:Int = 0
    var isSeventeen:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getScoreboardDetailsWS()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        holeDetailsView.layoutIfNeeded()
        let layer = holeDetailsView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
    }
    @IBAction func rightArrowBtnTapped(_ sender: Any) {
        
        if currentIndex == (self.playGameDetailsDict?.scoreBoard.count)! - 1 {
            currentIndex = 0
        }else if currentIndex == 0 {
            currentIndex += 1
            isSeventeen = true
        }else {
            currentIndex += 1
            
        }
        
        print(currentIndex)
        let score = self.playGameDetailsDict?.scoreCard[currentIndex]
        
        if currentIndex > 17 {
        
            if score?.holeName == "Out_Val" {
                self.holeLbl.text = "Out Val"
                
            }else if score?.holeName == "In_Val" {
                self.holeLbl.text = "In Val"
                
            }else {
                self.holeLbl.text = score?.holeName ?? ""
            }
        }else {
        self.holeLbl.text = "Hole \(currentIndex + 1)"
        }
        self.parLbl.text = "PAR \(score?.par ?? "")"
        self.ydsLbl.text = "YDS \(score?.yards ?? "")"
        self.hcpLbl.text = "HCP \(score?.hcp ?? "")"
        if score?.holeImage != nil {
        let url = URL(string: score?.holeImage ?? "")!
        self.downloadImage(from: url)
//            let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            self.holeImg.image = UIImage(data: data!)
        }else {
            self.holeImg.image = UIImage.init(named: "golf_course1")
        }
    }
    
    @IBAction func leftArrowBtnTapped(_ sender: Any) {
        
        if currentIndex == 1 {
            if isSeventeen == false {
                currentIndex = (self.playGameDetailsDict?.scoreBoard.count)! - 1
                isSeventeen = true
            }else {
                currentIndex -= 1
            }
            
        }else if currentIndex == 0 {
            currentIndex = (self.playGameDetailsDict?.scoreBoard.count)! - 1
            isSeventeen = true
        }else {
            if isSeventeen == true {
                currentIndex -= 1
            }else {
                if isSeventeen == false {
                    currentIndex -= 1
                }else {
                    currentIndex += 1
                    isSeventeen = false
                }
            }
        }
        
        print(currentIndex)
        let score = self.playGameDetailsDict?.scoreCard[currentIndex]
        if currentIndex > 17 {
            if score?.holeName == "Out_Val" {
                self.holeLbl.text = "Out Val"
                
            }else if score?.holeName == "In_Val" {
                self.holeLbl.text = "In Val"
                
            }else {
                self.holeLbl.text = score?.holeName ?? ""
            }
        }else {
            self.holeLbl.text = "Hole \(currentIndex + 1)"
        }
        
        self.parLbl.text = "PAR \(score?.par ?? "")"
        self.ydsLbl.text = "YDS \(score?.yards ?? "")"
        self.hcpLbl.text = "HCP \(score?.hcp ?? "")"
        if score?.holeImage != nil {
        let url = URL(string: score?.holeImage ?? "")!
        self.downloadImage(from: url)
        }else {
            self.holeImg.image = UIImage.init(named: "golf_course1")
        }
    }
    @IBAction func holeImgTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vFImgVCObj = storyboard.instantiateViewController(withIdentifier: "ViewFullImageVC") as! ViewFullImageVC
        let score = self.playGameDetailsDict?.scoreCard[currentIndex]
        vFImgVCObj.urlString = score?.holeImage ?? ""
        self.navigationController?.pushViewController(vFImgVCObj, animated: true)
    }
    
    //MARK: - Web Service Methods
    func getScoreboardDetailsWS() {
        
        let urlString :  String =  MyStrings().getPlayGameDataUrl + "\(gameId)"
        
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
            
            self.playGameDetailsDict = PlayGameModel(JSONString: jsonString)
            
            let gameData = try! JSONSerialization.data(withJSONObject: dict["GameData"] as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            let gameDataString = NSString(data: gameData, encoding: String.Encoding.utf8.rawValue)! as String
            self.playGameModelDict = PlayGameDataModel(JSONString: gameDataString)
            
            let score = self.playGameDetailsDict?.scoreCard[self.currentIndex]
            self.holeLbl.text = "Hole \(self.currentIndex + 1)"
            self.parLbl.text = "PAR \(score?.par ?? "")"
            self.ydsLbl.text = "YDS \(score?.yards ?? "")"
            self.hcpLbl.text = "HCP \(score?.hcp ?? "")"
            
            if score?.holeImage != nil {
            let url = URL(string: score?.holeImage ?? "")!
            self.downloadImage(from: url)
            }
            // self.currentIndex += 1
        }
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.holeImg.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
