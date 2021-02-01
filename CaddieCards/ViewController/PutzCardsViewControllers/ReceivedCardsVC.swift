//
//  ReceivedCardsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 24/12/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ReceivedCardsVC: UIViewController {
    
    @IBOutlet weak var cardNameLbl: UILabel!
    @IBOutlet weak var cardDescriptionTxtView: UITextView!
    var cardName : String = ""
    var cardDescription : String = ""
    var isFromNotifications : Bool = false
    var gameId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Received Cards"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Replace the default back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "arrow_white"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
        
        self.cardNameLbl.text = cardName
        self.cardDescriptionTxtView.text = cardDescription
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.isFromNotifications = false
    }
    @objc func goBack() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if isFromNotifications == true {
            var present : Bool = false
            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    // some process
                    if viewController.isKind(of: PlayVC.self) {
                       present = true
                    }
                }
                if present == true {
                    if let vc = viewControllers.last(where: { $0.isKind(of: PlayVC.self) }) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
                   playVCObj.editReplayGameId = NSNumber.init(value: Int32(gameId)!)
                    playVCObj.isFromNotificagions = true
                    self.navigationController?.pushViewController(playVCObj, animated: true)
                }

            }
        }else {
            self.navigationController?.popToViewController(ofClass: PlayVC.self)
        }
       
      
    }
}
extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
