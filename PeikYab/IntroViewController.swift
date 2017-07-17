//
//  IntroViewController.swift
//  NewPeikyab
//
//  Created by Developer on 9/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class IntroViewController:UIViewController, UIScrollViewDelegate, GIDSignInUIDelegate{
    
    //MARK: - Variables
    var scrollView : UIScrollView!
    var peykyabLabel:UILabel!
    var welcomeLabel : UILabel!
    var pageControl : UIPageControl!
    var googleLoginButton : GIDSignInButton!
    var googlePlusImage : UIImageView!
    var membershipButton : UIButton!
    var loginButton : UIButton!
    var imageArray:[String]=["intro1", "intro2", "intro3"]
    var introImage : UIImageView!
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool) {
        let str:String? = UserDefaults.standard.object(forKey: "dismissIntro") as? String
        if str == "YES"{
            UserDefaults.standard.removeObject(forKey: "dismissIntro")
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        //NotificationCenter.default.addObserver(self,selector: #selector(IntroViewController.receiveToggleAuthUINotification(notification:)),name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.googleLogin(notification:)), name: NSNotification.Name(rawValue: "googleLogin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.googleSignout(notification:)), name: NSNotification.Name(rawValue: "googleSignout"), object: nil)
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        scrollView = UIScrollView(frame:CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight-60))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: screenWidth*3, height: screenHeight/2)
        self.view.addSubview(scrollView)
        
        var xPos:CGFloat = 50
        for index in 0 ..< imageArray.count{
            introImage = UIImageView(frame: CGRect(x: xPos, y: 70, width: screenWidth-100,height: screenHeight/2-100 ))
            let imageName:String = imageArray[index]
            introImage.image = UIImage(named: imageName)
            scrollView.addSubview(introImage)
            xPos += screenWidth
        }
        
        peykyabLabel = UILabel(frame:CGRect(x: 80,y: introImage.frame.origin.y+introImage.frame.size.height+50,width: screenWidth-160,height: 20))
        peykyabLabel.backgroundColor = whiteColor
        peykyabLabel.textColor = grayColor
        peykyabLabel.font = FONT_NORMAL(13)
        peykyabLabel.text = "ipeyk"
        peykyabLabel.numberOfLines = 1
        peykyabLabel.textAlignment = .center
        peykyabLabel.adjustsFontSizeToFitWidth = true
        peykyabLabel.minimumScaleFactor = 0.5
        self.view.addSubview(peykyabLabel)
        
        welcomeLabel = UILabel(frame:CGRect(x: 80,y: introImage.frame.origin.y+introImage.frame.size.height+80,width: screenWidth-160,height: 60))
        welcomeLabel.backgroundColor = whiteColor
        welcomeLabel.textColor = grayColor
        welcomeLabel.font = FONT_NORMAL(20)
        welcomeLabel.text = NSLocalizedString("welcome", comment: "")
        welcomeLabel.numberOfLines = 2
        welcomeLabel.textAlignment = .center
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.minimumScaleFactor = 0.5
        self.view.addSubview(welcomeLabel)
        
        pageControl = UIPageControl(frame: CGRect(x: screenWidth/2 - 50,y: welcomeLabel.frame.origin.y+welcomeLabel.frame.size.height+15,width: 100,height: 30))
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.gray
        pageControl.pageIndicatorTintColor = grayColor
        pageControl.currentPageIndicatorTintColor = pageControllerCurrentPageColor
        self.view.addSubview(pageControl)
        
        googleLoginButton = GIDSignInButton(frame: CGRect(x: 0,y: screenHeight-120,width: screenWidth,height: 60))
        googleLoginButton.backgroundColor = UIColor.clear
        //googleLoginButton.setTitleColor(UIColor.black, for: .normal)
        //googleLoginButton.layer.borderWidth = 1.0
        //googleLoginButton.layer.borderColor = UIColor.gray.cgColor
        //googleLoginButton.titleLabel?.font = FONT_MEDIUM(15)
        //googleLoginButton.setTitle(NSLocalizedString("loginToSystem", comment: ""), for:UIControlState())
        //googleLoginButton.addTarget(self, action: #selector(setter: googleLoginButton), for: .touchUpInside)
        self.view.addSubview(googleLoginButton)
        
        googlePlusImage = UIImageView(frame: CGRect(x: 0,y: screenHeight-120, width: 50, height: 50))
        googlePlusImage.contentMode = .scaleAspectFit
        googlePlusImage.image = UIImage(named: "googlePlus.png")
        //self.view.addSubview(googlePlusImage)
        
        membershipButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth/2,height: 60))
        membershipButton.backgroundColor = buttonColor1
        membershipButton.titleLabel?.font = FONT_MEDIUM(15)
        membershipButton.setTitle(NSLocalizedString("membership", comment: ""), for:UIControlState())
        membershipButton.addTarget(self, action: #selector(membershipAction), for: .touchUpInside)
        self.view.addSubview(membershipButton)
        
        loginButton = UIButton(frame: CGRect(x: screenWidth/2,y: screenHeight-60,width: screenWidth/2,height: 60))
        loginButton.backgroundColor = buttonColor2
        loginButton.titleLabel?.font = FONT_MEDIUM(15)
        loginButton.setTitle(NSLocalizedString("login", comment: ""), for:UIControlState())
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        //register observer
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.membershipAction(_:)), name: NSNotification.Name(rawValue: "callMembershipAction"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.dismissButtonAction), name: NSNotification.Name(rawValue: "callDismissIntro"), object: nil)
    }
    
    //MARK: -  ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    //MARK: - Google Login
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    //    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    //        //myActivityIndicator.stopAnimating()
    //    }
    //
    //    // Present a view that prompts the user to sign in with Google
    //    func signIn(signIn: GIDSignIn!,
    //                presentViewController viewController: UIViewController!) {
    //        self.present(viewController, animated: true, completion: nil)
    //        //self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: Notification.Name(rawValue: "callDismissIntro"), object: nil)
    //        // })
    //    }
    //
    //    // Dismiss the "Sign in with Google" view
    //    func signIn(signIn: GIDSignIn!,
    //                dismissViewController viewController: UIViewController!) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //
    //MARK: -  Custom Methods
    //google Login Button Action
    
    // Signup
    func membershipAction(_ sender: UIButton!) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
        self.present(nextViewController, animated:true, completion:nil)
        //self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // Login
    func loginAction(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
        //self.navigationController?.pushViewController(nextViewController , animated: true)
    }
    // Dismiss Intro
    func dismissButtonAction()
    {
        self.dismiss(animated: false, completion: nil)
    }
    //Google SignOut
    func googleSignout(notification: Notification){
        //GIDSignIn.sharedInstance().signOut()
    }
    
//    func toggleAuthUI() {
//        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
//            // Signed in
//            //googleLoginButton.isHidden = true
//            googleLogin()
//            //self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: Notification.Name(rawValue: "callDismissIntro"), object: nil)
//            // })
//            
//            //signOutButton.hidden = false
//            //disconnectButton.hidden = false
//        } else {
//            googleLoginButton.isHidden = false
//            //signOutButton.hidden = true
//            //disconnectButton.hidden = true
//            //statusText.text = "Google Sign in\niOS Demo"
//        }
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),object: nil)
//    }
//    
//    
//    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
//        if (notification.name.rawValue == "ToggleAuthUINotification") {
//            //self.toggleAuthUI()
//            GIDSignIn.sharedInstance().signIn()
//            self.googleLogin()
//            if notification.userInfo != nil {
//                let userInfo:Dictionary<String,String?> =
//                    notification.userInfo as! Dictionary<String,String?>
//                self.welcomeLabel.text = userInfo["statusText"]!
//            }
//        }
//    }
 
    // MARK: - Connections
    func googleLogin(notification: Notification) {
        //Check Internet Connection
        let isConnectionAvailable:Bool = isInternetAvailable()
        if isConnectionAvailable == false{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("checkInternetConnection", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        let googleUserID = tempDic["uid"]
        let googleIdToken = tempDic["idToken"]
    
        //let googleUserID = UserDefaults.standard.object(forKey: "googleUserId")
        //let googleIdToken = UserDefaults.standard.object(forKey: "googleIdToken")
        
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["id":googleUserID! as AnyObject,
                                                    "idToken":googleIdToken! as AnyObject
        ]
        print ("Params:\(params)")
        GoogleLoginWithCallBack(apiName: "googlelogin", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    sessionID = "\(responseDic.object(forKey: "sessionid")!)"
                    let userName = "\(responseDic.object(forKey: "username")!)"
                    let email = "\(responseDic.object(forKey: "email")!)"
                    print("session:\(sessionID!)")
                    print("username:\(userName)")
                    print("Email:\(email)")
                    UserDefaults.standard.set(sessionID!,forKey:"sessionID")
                    UserDefaults.standard.set(userName,forKey:"userName")
                    UserDefaults.standard.set(email,forKey:"customerEmail")
                    UserDefaults.standard.synchronize()
                    
                    //register device token
                    self.registerDeviceToken()
                    
                    UserDefaults.standard.set(true, forKey: "firstlaunch1.0")
                    self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: Notification.Name(rawValue: "callDismissIntro"), object: nil)
                    })
                    DispatchQueue.main.async{
                        let msg:String = responseDic.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("login", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else/*status>1*/{
                    //Session Expired
                    if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                        
                        DispatchQueue.main.async {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            nextViewController.showBackButton = false
                            self.present(nextViewController, animated: true, completion: nil)
                            
                            //                                let msg:String = responseDic.object(forKey: "msg") as! String
                            //                                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                            //                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                            //                                self.present(alert, animated: true, completion: nil)
                        }
                    }else/*code!=403 and status!=0(Session Not Expired)*/{
                        DispatchQueue.main.async {
                            let msg:String = responseDic.object(forKey: "msg") as! String
                            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            //Error
            if let responseError = error{
                print(responseError.localizedDescription)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:responseError.localizedDescription as String , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Register Device Token
    func registerDeviceToken() -> Void {
        let token:String? = UserDefaults.standard.object(forKey: "deviceToken") as? String
        if token != nil {
            let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
            
            let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject,
                                                        "token":token! as AnyObject,
                                                        "os":"ios" as AnyObject,
                                                        "phoneNum":"" as AnyObject]
            print(params)
            registerTokenAsyncWithCallBack(apiName: "push/registertokenasync", params: params as NSDictionary?) { (responseDic:NSDictionary?, error:NSError?) in
                
                let status:Int = responseDic!["status"] as! Int
                if status == 0{
                    self.registerDeviceToken()
                }
                if let responseError = error{
                    print(responseError.localizedDescription)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:responseError.localizedDescription as String , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
