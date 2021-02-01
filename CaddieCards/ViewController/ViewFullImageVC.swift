//
//  ViewFullImageVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 28/04/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class ViewFullImageVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Hole Image"
        
        let diceRoll = Int(arc4random_uniform(UInt32(6)))
        let urlStr = String(format: "%@?rn=%@",urlString,String(diceRoll))
        let url = URL(string: urlStr)!
        downloadImage(from: url)
    }
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.imgView.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
