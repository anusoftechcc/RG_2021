//
//  AnimalAnimationVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 03/03/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class AnimalAnimationVC: BaseViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var animalImgView: UIImageView!
    @IBOutlet weak var imgDescriLbl: UILabel!
    @IBOutlet weak var animationView: UIView!
    var urlString: String = ""
    var descriptionStr: String = ""
    var custName: String = ""
    
    var onCancelDoneAnimalView: ((_ gameName: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // Do any additional setup after loading the view.
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let urlStr = String(format: "%@?rn=%@",urlString,String(diceRoll))
        let url = URL(string: urlStr)!
        downloadImage(from: url)
        print("Desc = \(descriptionStr)")
        self.imgDescriLbl.text = "\(custName) \n \(descriptionStr)"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationView.layoutIfNeeded()
        let layer = animationView.layer
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.masksToBounds = false
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        self.onCancelDoneAnimalView?("Cancel Clicked")
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                //                UIView.transition(with: self.animalImgView,
                //                                  duration: 0.75,
                //                                  options: .transitionCrossDissolve,
                //                                  animations: {
                //
                //                }, completion: nil)
                self.animalImgView.image = UIImage(data: data)
                self.animalImgView.layer.add(CATransition(), forKey: kCATransition)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
