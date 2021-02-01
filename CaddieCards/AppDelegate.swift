//
//  AppDelegate.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 08/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate,MessagingDelegate, UNUserNotificationCenterDelegate, CustomAlertViewDelegate {
    

    var window: UIWindow?
weak var viewController : LoginVC?
    var navigationController : UINavigationController?
    var cardInfo : UserNotificationDataResponse?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        if #available(iOS 11, *) {
            //UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
            //UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
            navigationController?.navigationItem.backBarButtonItem?.title = ""
        } else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0,vertical: -60), for:UIBarMetrics.default)
        }
        UINavigationBar.appearance().barTintColor = GlobalConstants.APPCOLOR
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
        // Initialize Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        self.registerForPushNotifications()
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "384469182523-vir5j3f20sre7oe4dd61d9r04e57cdf9.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
       // didRegisterForRemoteNotificationsWithDeviceToken call the method.
       // viewController?.loadRequest(for: deviceTokenString!)
        
        //splashNavId
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreenVC") as! SplashScreenVC
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
        
        checkForUserLoggedIn()
        
        return true
    }
    
    func checkForUserLoggedIn() {
        let str =  UserDefaults.standard.value(forKey: "Login") as? String
        if str != "Yes" {
            
        } else {
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Social Logins Methods
    
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.scheme == "fb1272473566449513" {

            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }else {
            return GIDSignIn.sharedInstance().handle(url)
//        return GIDSignIn.sharedInstance().handle(url as URL?,
//                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ... This is for testing git commit
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CaddieCards")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
      //  updateFirestorePushTokenIfNeeded()
    }
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
       // updateFirestorePushTokenIfNeeded()
        let dataDict:[String: String] = ["token": fcmToken! ]
        Token.setToken(fcmToken: fcmToken!)
          NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if userInfo["NotificationType"] as! String == "Animals" {
            do {
                var alertMessage = ""
                var alerttitle = ""
                if let aps = userInfo["aps"] as? NSDictionary {
                    if let alert = aps["alert"] as? NSDictionary {
                        if let message = alert["body"] as? NSString {
                           //Do stuff
                            alertMessage = message as String
                            alerttitle = alert["title"] as? NSString as! String
                            print("\(message)")
                        }
                    } else if let alert = aps["alert"] as? NSString {
                        //Do stuff
                    }
                }
                if let jsonResult = userInfo as? Dictionary<String, AnyObject> {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonResult as Any,
                                                              options: .prettyPrinted)
                    
                    cardInfo = try JSONDecoder().decode(UserNotificationDataResponse.self, from: jsonData)
                    NotificationGameId.setGameId(gameId: cardInfo?.GameId ?? "")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   
                    print("user tapped the notification bar when the app is in background")
                    if  let gamesVC = storyboard.instantiateViewController(withIdentifier: "GamesVC") as? GamesVC {
     
                            DispatchQueue.main.async {
                                let navController = UINavigationController(rootViewController: gamesVC)
                                    let viewControllers = navController.viewControllers
                                    let newViewControllers = NSMutableArray()
                                    // preserve the root view controller
                                    newViewControllers.add(viewControllers[0])
                                // add the new view controlle
                                
                                
                                let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
                                playVCObj.editReplayGameId = NSNumber.init(value: Int32(self.cardInfo?.GameId ?? "")!)
                                newViewControllers.add(playVCObj)
                                
                                let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
                                let customAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
                                customAlert.providesPresentationContextTransitionStyle = true
                                customAlert.message = alertMessage
                                customAlert.senderName = alerttitle
                                customAlert.imgURL = self.cardInfo?.Icon ?? ""
                                customAlert.definesPresentationContext = true
                                customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                customAlert.delegate = self
                                self.window?.rootViewController = navController
                                self.window?.makeKeyAndVisible()
                                    navController.setViewControllers(newViewControllers as! [UIViewController], animated: true)
                                navController.present(customAlert, animated: true, completion: nil)
                            }
                    }
                    
                }
            } catch {
                // handle error
           }

            
        }else {
            do {
            if let jsonResult = userInfo as? Dictionary<String, AnyObject> {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResult as Any,
                                                          options: .prettyPrinted)
                 cardInfo = try JSONDecoder().decode(UserNotificationDataResponse.self, from: jsonData)
                NotificationGameId.setGameId(gameId: cardInfo?.GameId ?? "")
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let application = UIApplication.shared.applicationState
                
                print("user tapped the notification bar when the app is in background")
                if  let gamesVC = storyboard.instantiateViewController(withIdentifier: "GamesVC") as? GamesVC {
                    if application == .active {
                        
                        let navController = UINavigationController(rootViewController: gamesVC)
                            let viewControllers = navController.viewControllers
                            let newViewControllers = NSMutableArray()
                            // preserve the root view controller
                            newViewControllers.add(viewControllers[0])
                        
                       // let putzCardDict = self.putzCardsDetailsDict?.playerCards?[indexId]
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sPCVCObj = storyboard.instantiateViewController(withIdentifier: "SendPutzCardVC") as! SendPutzCardVC
                        sPCVCObj.gameId = NSNumber.init(value: Int(self.cardInfo?.GameId ?? "")!)
                        sPCVCObj.cardName = self.cardInfo?.CardName ?? ""
                      //  sPCVCObj.cardId = NSNumber.init(value: Int(self.cardInfo?.CardId ?? "")!)
                        sPCVCObj.card =  self.cardInfo?.CardId ?? ""
                        sPCVCObj.senderName = self.cardInfo?.SenderName ?? ""
                        sPCVCObj.cardDescription = self.cardInfo?.CardDescription ?? ""
                        sPCVCObj.isFromNotification = true
                      //  sPCVCObj.putzCardsDetailsDict = self.putzCardsDetailsDict
                       // sPCVCObj.cardsRemaining = self.putzCardsDetailsDict?.playerCards?.count ?? 0
                        self.window?.rootViewController = navController
                        self.window?.makeKeyAndVisible()
                            newViewControllers.add(sPCVCObj)
                            navController.setViewControllers(newViewControllers as! [UIViewController], animated: true)
                        
                        
                    }else {
                        DispatchQueue.main.async {
                        let navController = UINavigationController(rootViewController: gamesVC)
                            let viewControllers = navController.viewControllers
                            let newViewControllers = NSMutableArray()
                            // preserve the root view controller
                            newViewControllers.add(viewControllers[0])
                            // add the new view controlle
                            
                        let sPCVCObj = storyboard.instantiateViewController(withIdentifier: "ReceivedCardsVC") as! ReceivedCardsVC
                            sPCVCObj.cardName = self.cardInfo?.CardName ?? ""
                            sPCVCObj.cardDescription = self.cardInfo?.CardDescription ?? ""
                        sPCVCObj.isFromNotifications = true
                            sPCVCObj.gameId = self.cardInfo?.GameId ?? ""
                            newViewControllers.add(sPCVCObj)
                            navController.setViewControllers(newViewControllers as! [UIViewController], animated: true)
                        self.window?.rootViewController = navController
                        self.window?.makeKeyAndVisible()
                        }
                    }

                }
            }
            } catch {
                // handle error
           }
        }
        
          completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        

        let userInfo = notification.request.content.userInfo
      //  print("\(userInfo["alert"]))")
        if userInfo["NotificationType"] as! String == "Animals" {
            do {
                var alertMessage = ""
                var alerttitle = ""
                if let aps = userInfo["aps"] as? NSDictionary {
                    if let alert = aps["alert"] as? NSDictionary {
                        if let message = alert["body"] as? NSString {
                           //Do stuff
                            alertMessage = message as String
                            alerttitle = alert["title"] as? NSString as! String
                            print("\(message)")
                        }
                    } else if let alert = aps["alert"] as? NSString {
                        //Do stuff
                    }
                }
                if let jsonResult = userInfo as? Dictionary<String, AnyObject> {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonResult as Any,
                                                              options: .prettyPrinted)
                    
                    cardInfo = try JSONDecoder().decode(UserNotificationDataResponse.self, from: jsonData)
                    NotificationGameId.setGameId(gameId: cardInfo?.GameId ?? "")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let application = UIApplication.shared.applicationState
                    
                    print("user tapped the notification bar when the app is in background")
                    if  let gamesVC = storyboard.instantiateViewController(withIdentifier: "GamesVC") as? GamesVC {
                        if application == .active {
                            
                            let navigationController = self.window?.rootViewController as! UINavigationController
                            
                          
                            let viewControllers = navigationController.viewControllers
                            let newViewControllers = NSMutableArray()
                            let playVCObj = storyboard.instantiateViewController(withIdentifier: "PlayVC") as! PlayVC
                            playVCObj.editReplayGameId = NSNumber.init(value: Int32(self.cardInfo?.GameId ?? "")!)
                            newViewControllers.addObjects(from: viewControllers)
                            newViewControllers.add(playVCObj)
                            let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
                            let customAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
                            customAlert.providesPresentationContextTransitionStyle = true
                            customAlert.message = alertMessage
                            customAlert.senderName = alerttitle
                            customAlert.imgURL = cardInfo?.Icon ?? ""
                            customAlert.definesPresentationContext = true
                            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            customAlert.delegate = self
                            navigationController.setViewControllers(newViewControllers as! [UIViewController], animated: true)
                            navigationController.present(customAlert, animated: true, completion: nil)
                            
                        }
                    }
                }
            } catch {
                // handle error
           }

            
        }else {
            do {
                if let jsonResult = userInfo as? Dictionary<String, AnyObject> {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonResult as Any,
                                                              options: .prettyPrinted)
                    
                    cardInfo = try JSONDecoder().decode(UserNotificationDataResponse.self, from: jsonData)
                    NotificationGameId.setGameId(gameId: cardInfo?.GameId ?? "")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let application = UIApplication.shared.applicationState
                    
                    print("user tapped the notification bar when the app is in background")
                    if  let gamesVC = storyboard.instantiateViewController(withIdentifier: "GamesVC") as? GamesVC {
                        if application == .active {
                            
                            let navigationController = self.window?.rootViewController as! UINavigationController
                            
                            let navController = UINavigationController(rootViewController: gamesVC)
                            let viewControllers = navigationController.viewControllers
                            let newViewControllers = NSMutableArray()
                            newViewControllers.addObjects(from: viewControllers)
                            // let putzCardDict = self.putzCardsDetailsDict?.playerCards?[indexId]
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let sPCVCObj = storyboard.instantiateViewController(withIdentifier: "SendPutzCardVC") as! SendPutzCardVC
                            sPCVCObj.gameId = NSNumber.init(value: Int(self.cardInfo?.GameId ?? "")!)
                            sPCVCObj.cardName = self.cardInfo?.CardName ?? ""
                            //  sPCVCObj.cardId = NSNumber.init(value: Int(self.cardInfo?.CardId ?? "")!)
                            sPCVCObj.card =  self.cardInfo?.CardId ?? ""
                            sPCVCObj.senderName = self.cardInfo?.SenderName ?? ""
                            sPCVCObj.cardDescription = self.cardInfo?.CardDescription ?? ""
                            sPCVCObj.isFromNotification = true
                            //  sPCVCObj.putzCardsDetailsDict = self.putzCardsDetailsDict
                            // sPCVCObj.cardsRemaining = self.putzCardsDetailsDict?.playerCards?.count ?? 0
    //                        self.window?.rootViewController = navController
    //                        self.window?.makeKeyAndVisible()
                            newViewControllers.add(sPCVCObj)
                            navigationController.setViewControllers(newViewControllers as! [UIViewController], animated: true)
                        }
                    }
                }
            } catch {
                // handle error
           }

        }
        completionHandler([.sound])
        
    }
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    func okButtonTapped(selectedOption: String, textFieldValue: String) {
        
    }
    
    func cancelButtonTapped() {
        
    }
    

}

