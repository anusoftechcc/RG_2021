//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
import SDWebImage

class CustomAlertView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
   
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var senderNameLbl: UILabel!
    
    var delegate: CustomAlertViewDelegate?
    var imgName = ""
    var senderName = ""
    var message = ""
    var imgURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
       
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
       // self.imgView.image = UIImage(named: "")
        self.senderNameLbl.text = senderName
        self.messageLabel.text = message
        if imgURL.count > 0 {
            self.imgView.sd_setImage(with: URL(string: imgURL), completed: nil)
        }
       
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
