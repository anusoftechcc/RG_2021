//
//  HomeScreenVC.swift
//  CaddieCards
//
//  Created by Madhusudhan Reddy on 08/03/19.
//  Copyright © 2019 Madhusudhan Reddy. All rights reserved.
//

import UIKit
import GoogleSignIn
import MBProgressHUD
import FacebookLogin
import FBSDKLoginKit
import SafariServices


class HomeScreenVC: BaseViewController,GIDSignInDelegate,LoginButtonDelegate,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    @IBOutlet weak var emailLoginInBtn: UIButton!
    @IBOutlet weak var facebookLoginInBtn: UIButton!
    var dict : [String : AnyObject]!
    var dictSocialLogin = [String: String]()
    
    //MARK: - ViewDidLoad Start
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
       // GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        //automatically sign in the user.
        // GIDSignIn.sharedInstance().signInSilently()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Login Button Action Methods
    
    @IBAction func emailLoginBtnTapped(_ sender: Any) {
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVCNavId") as! UINavigationController
         //let loginVCObj = initialViewController.viewControllers[0] as! LoginVC
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = initialViewController
         */
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVCObj = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginVCObj, animated: true)
    }
    
    
    @IBAction func googleLoginBtnTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func facebookLoginBtnTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    // MARK: - Google Sign In Delegate Methods
    
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    // Present a view that prompts the user to sign in with Google
    private func signIn(signIn: GIDSignIn!,
                        presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    private func signIn(signIn: GIDSignIn!,
                        dismissViewController viewController: UIViewController!) {
        startLoadingIndicator(loadTxt: "Loading...")
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            dictSocialLogin["user_id"] = userId
            dictSocialLogin["idToken"] = idToken
            dictSocialLogin["fullName"] = fullName
            dictSocialLogin["givenName"] = givenName
            dictSocialLogin["familyName"] = familyName
            dictSocialLogin["email"] = email
            
            self.checkActiveUserOrNot(socialLoginDict: self.dictSocialLogin, email: email ?? "")
            
//            self.navigationController?.navigationItem.backBarButtonItem?.title = ""
//            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let signUpVCObj = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
//            signUpVCObj.dictSocialLogin = dictSocialLogin
//            signUpVCObj.isFromScocialLogin = true
//            self.navigationController?.pushViewController(signUpVCObj, animated: true)
        } else {
            print("\(error!)")
        }
    }
    
    // MARK: - Facebook Sign In Delegate Methods
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as? [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    self.dictSocialLogin["user_id"] = self.dict["email"] as? String
                    self.dictSocialLogin["fullName"] = self.dict["name"] as? String
                    let nameStr: String = self.dict["name"]  as! String
                    let fullNameArr = nameStr.components(separatedBy: " ")
                    if fullNameArr.count == 1 {
                        self.dictSocialLogin["givenName"] = fullNameArr[0]
                    }else if fullNameArr.count == 2 {
                        self.dictSocialLogin["givenName"] = fullNameArr[0]
                        self.dictSocialLogin["familyName"] = fullNameArr[1]
                    }else {
                        self.dictSocialLogin["givenName"] = ""
                        self.dictSocialLogin["familyName"] = ""
                    }
                    self.dictSocialLogin["email"] = self.dict["email"] as? String
                    
                    self.checkActiveUserOrNot(socialLoginDict: self.dictSocialLogin, email: (self.dict["email"] as? String)!)
            
                }
            })
        }
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        startLoadingIndicator(loadTxt: "Login...")
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as? [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        stopLoadingIndicator()
    }
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        startLoadingIndicator(loadTxt: "Login...")
//        if((AccessToken.current) != nil){
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    self.dict = result as? [String : AnyObject]
//                    print(result!)
//                    print(self.dict)
//                }
//            })
//        }
//    }
    
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        stopLoadingIndicator()
//    }
    
    func checkActiveUserOrNot(socialLoginDict: [String : String], email: String) {
        
        let osVersion = UIDevice.current.systemVersion
        let model = UIDevice.current.model
        var manufacturer:String = ""
        if  UIDevice.current.userInterfaceIdiom == .phone{
            manufacturer = "iphone"
        }else{
            manufacturer = "ipad"
        }
        
        let params: Parameters = [
            "UserName": email,
            "Password": "",
            "DeviceType": manufacturer,
            "DeviceToken": Token.fcmToken!,
            "Ip_Address": "",
            "OS_Version": osVersion,
            "Manufacturer": "Apple",
            "Model": model
        ]
        print(params)
        
        self.startLoadingIndicator(loadTxt: "Loading...")
        ApiCall.sendRequest(onView: self, isBody: true, urlString: MyStrings().setActiveUsersUrl, urlParams: params as [String : AnyObject]) { (response) in
            print(response as Any)
            
            //Modified by andydev 03232019 5:43pm
            //Added if conidtion to avoid crash when reqest to the server failed to fetch the data
            
            if(response.isSuccess){
                
                let message = response.responseDictionary["ErrorMessage"] as? String
                print(message as Any)
                let isError = response.responseDictionary["IsError"] as! Bool
                print(isError)
//                guard isError == false else {
//                    return
//                }
                if isError == false {
                print(response.responseDictionary)
                let dict = response.responseDictionary
                
                let ResdataDict = ["userid":dict["CustomerId"]!,"UserName":dict["UserName"]!,"FirstName":dict["FirstName"] ?? "","AccessToken":dict["AccessToken"]!,"LastName":dict["LastName"] ?? ""]
                UserDefaults.standard.setValue(ResdataDict, forKey: "userData")
                UserDefaults.standard.setValue(dict["CustomerId"]!, forKey: "CustomerId")
                UserDefaults.standard.setValue(email, forKey: "CustomerEmail")
                UserDefaults.standard.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "DashboardNavVC") as! UINavigationController
                // let topVc = initialViewController.viewControllers[0] as! DashboardVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
                    
                } else {
                    self.navigationController?.navigationItem.backBarButtonItem?.title = ""
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let signUpVCObj = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    signUpVCObj.dictSocialLogin = self.dictSocialLogin
                    signUpVCObj.isFromScocialLogin = true
                    self.navigationController?.pushViewController(signUpVCObj, animated: true)
                }
                
            } else {
                
                self.navigationController?.navigationItem.backBarButtonItem?.title = ""
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signUpVCObj = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                signUpVCObj.dictSocialLogin = self.dictSocialLogin
                signUpVCObj.isFromScocialLogin = true
                self.navigationController?.pushViewController(signUpVCObj, animated: true)
            }
        }
    }
    @IBAction func soaringBtnTapped(_ sender: Any) {
        let url = NSURL.init(string: "https://www.soaring.dev/")
        let vc = SFSafariViewController(url: url! as URL)
        vc.delegate = self
        self.present(vc, animated: true)
    }
   // MARK: - SafariViewController Delegate Methods
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }

}
