//
//  SplashScreenVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 08/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SplashScreenVC: UIViewController,AVPlayerViewControllerDelegate,AVAudioPlayerDelegate {
    
    var player: AVPlayer!
    var playerController = AVPlayerViewController()
    var bombSoundEffect: AVAudioPlayer?
    var timer:Timer!
    var END_TIME = 0.1

    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "GolfPutzLoadScreen", ofType: "mp4")
        
        let url = NSURL(fileURLWithPath: path!)
        let player = AVPlayer(url:url as URL)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
       // timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SplashScreenVC.checkTime), userInfo: nil, repeats: false)
        
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = true
        playerController.delegate = self
        playerController.showsPlaybackControls = false
        playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        playerController.view.frame = self.view.frame
        self.addChild(playerController)
        self.view.addSubview(playerController.view)
        playerController.player?.play()
        if #available(iOS 11.0, *) {
            playerController.entersFullScreenWhenPlaybackBegins = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            playerController.exitsFullScreenWhenPlaybackEnds = false
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc func didfinishplaying(note : NSNotification)
    {
        NotificationCenter.default.removeObserver(self)
        self.navigateToHomeScreen()
        
//        let path = Bundle.main.path(forResource: "jester_laugh.mp3", ofType:nil)!
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
//            bombSoundEffect?.delegate = self
//        //    bombSoundEffect?.numberOfLoops = 0
//            bombSoundEffect?.play()
//        } catch {
//        }
        
    }
    func navigateToHomeScreen() {
        print("here")
            let str =  UserDefaults.standard.value(forKey: "Login") as? String
            if str != "Yes" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashNavId") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
                
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                //  let topVc = initialViewController.viewControllers[0] as! DashboardVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
            
            }
    }
   /* func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        print(flag)
        print("here")
        self.bombSoundEffect?.stop()
	        if flag == true {
            let str =  UserDefaults.standard.value(forKey: "Login") as? String
            if str != "Yes" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashNavId") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
                
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                //  let topVc = initialViewController.viewControllers[0] as! DashboardVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
            
            }
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "splashNavId") as! UINavigationController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = initialViewController
        }
    }  */
//   @objc func checkTime() {
//    if (self.bombSoundEffect?.currentTime ?? 0.1) >= END_TIME {
//            self.bombSoundEffect?.stop()
//            timer.invalidate()
//        }
//    }
}
