//
//  CaddieCardsVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 26/02/20.
//  Copyright © 2020 Madhusudhan Reddy. All rights reserved.
//

import UIKit

class CaddieCardsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cardsCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cardsCV.delegate = self
        cardsCV.dataSource = self
    }
    
    //MARK: - Collection view Data Source Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CaddieCardsCVCell", for: indexPath as IndexPath) as! CaddieCardsCVCell
        
        // Use the outlet in our custom class to get a reference to the UIImage in the cell
        // cell.cardImgView.image = UIImage.init(named: "")
        
        return cell
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let frameC = cardsCV.frame.size
        return CGSize(width: frameC.width, height: frameC.height)
    }
}
