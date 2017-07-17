
//
//  LoginViewController.swift
//  PeikYab
//
//  Created by nooran on 9/6/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
var sessionID :String!
class LoginViewController:BaseViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate{
    
    //MARK: - Variables
    var scrollView :UIScrollView!
    var loginImage : UIImageView!
    var nameTextField : UITextField!
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var notBecomeMemberButton : UIButton!
    var loginToAppButton : UIButton!
    var forgetPassButton : UIButton!
    var titleLabel : UILabel!
    var popupView : UIView!
    var emailForgetTextField : UITextField!
    var getPassButton :UIButton!
    var getPassImage :UIImageView!
    var tapGesture:UITapGestureRecognizer!
    var transparentView:UIView!
    var showBackButton:Bool = true
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let session = UserDefaults.standard.object(forKey: "sessionID")
        if session != nil{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("sessionExpired", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.hideKeyboardWhenTappedAround()
        
        makeTopbar(NSLocalizedString("login", comment: ""))
        
        //Check to show back button in Login or not
        if showBackButton == false{
            backButton.isHidden = true
        }else if showBackButton == true{
            backButton.isHidden = false
            backButton.addTarget(self, action: #selector(LoginViewController.backButtonAction), for: .touchUpInside)
        }
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight-64))
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.isUserInteractionEnabled = true
        
        //ImageView
        loginImage = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/3))
        loginImage.contentMode = .scaleAspectFit
        loginImage.image = UIImage(named: "signup.png")
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            loginImage.frame.size.height = screenHeight/4
        }else if DeviceType.IS_IPHONE_5{
            loginImage.frame.size.height = screenHeight/3
        }else if DeviceType.IS_IPHONE_6{
            loginImage.frame.size.height = screenHeight/2.5
        }else if DeviceType.IS_IPHONE_6P{
            loginImage.frame.size.height = screenHeight/2.5
        }
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(loginImage)
        
        //Email TextField
        emailTextField = UITextField(frame: CGRect(x: 60,y: loginImage.frame.origin.y+loginImage.frame.size.height+10, width: screenWidth-120, height: 40))
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("email", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //emailTextField.placeholder = NSLocalizedString("email", comment: "")
        //emailTextField.font = FONT_NORMAL(20)
        emailTextField.textColor = UIColor.black
        emailTextField.borderStyle = .none
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.autocapitalizationType = .none
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        emailTextField.contentVerticalAlignment = .center
        emailTextField.contentHorizontalAlignment = .center
        emailTextField.textAlignment = .center
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.tag = 13
        emailTextField.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(emailTextField)
        addLineView(emailTextField.frame.origin.x,y:emailTextField.frame.origin.y+40,w:emailTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        
        //Password TextField
        passwordTextField = UITextField(frame: CGRect(x: 60,y: emailTextField.frame.origin.y+emailTextField.frame.size.height+10, width: screenWidth-120, height: 40))
        passwordTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("password", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //passwordTextField.placeholder = NSLocalizedString("password", comment: "")
        //passwordTextField.font = FONT_NORMAL(20)
        passwordTextField.textColor = UIColor.black
        passwordTextField.borderStyle = .none
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordTextField.contentVerticalAlignment = .center
        passwordTextField.contentHorizontalAlignment = .center
        passwordTextField.textAlignment = .center
        passwordTextField.delegate = self
        passwordTextField.tag = 14
        passwordTextField.isSecureTextEntry = true
        passwordTextField.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(passwordTextField)
        addLineView(passwordTextField.frame.origin.x,y:passwordTextField.frame.origin.y+40,w:passwordTextField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
        
        //Forget Password Button
        forgetPassButton = UIButton(frame: CGRect(x: 0,y: passwordTextField.frame.origin.y+passwordTextField.frame.size.height+10,width: screenWidth,height: 30))
        forgetPassButton.backgroundColor = UIColor.white
        forgetPassButton.titleLabel!.font = FONT_MEDIUM(13)
        forgetPassButton.setTitleColor(buttonColor1,for: UIControlState())
        forgetPassButton.setTitle(NSLocalizedString("forgetPass", comment: ""), for:UIControlState())
        forgetPassButton.addTarget(self, action: #selector(forgetPassAction), for: .touchUpInside)
        scrollView.addSubview(forgetPassButton)
        
        //Not signup Before
        notBecomeMemberButton = UIButton(frame: CGRect(x: 0,y: screenHeight-120,width: screenWidth,height: 60))
        notBecomeMemberButton.backgroundColor = buttonColor2
        notBecomeMemberButton.titleLabel!.font = FONT_MEDIUM(15)
        notBecomeMemberButton.tintColor = whiteColor
        notBecomeMemberButton.setTitle(NSLocalizedString("notBecomeMemberBefore", comment: ""), for:UIControlState())
        notBecomeMemberButton.addTarget(self, action: #selector(notBecomeMemeberBeforeAction), for: .touchUpInside)
        self.view.addSubview(notBecomeMemberButton)
        
        //Login Button
        loginToAppButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        loginToAppButton.backgroundColor = buttonColor1
        loginToAppButton.titleLabel?.font = FONT_MEDIUM(15)
        loginToAppButton.setTitle(NSLocalizedString("loginToApp", comment: ""), for:UIControlState())
        loginToAppButton.addTarget(self, action: #selector(loginToAppAction), for: .touchUpInside)
        self.view.addSubview(loginToAppButton)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    //MARK: -  Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+40,w:textField.frame.size.width,h:2,color:greenColor,superView: scrollView)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 13 || textField.tag == 14{
                scrollView.setContentOffset(CGPoint(x: 1,y: 100), animated: true)
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 14{
                scrollView.setContentOffset(CGPoint(x: 1,y: 100), animated: true)
            }
        }else if DeviceType.IS_IPHONE_6{
        }else if DeviceType.IS_IPHONE_6P{
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+40,w:textField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        if !emailTextField.text!.isEmail{
            let alertController = UIAlertController(title: NSLocalizedString("wrongEmail", comment: ""), message:NSLocalizedString("wrongEmailMessage", comment: ""), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("back", comment: ""), style:  .default) {
                (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion:nil)
            self.emailTextField.resignFirstResponder()
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: -  Custom Methods
    
    //Hide Popup
    func handleGesture(_ sender: UITapGestureRecognizer){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if popupView != nil{
            self.popupView.removeFromSuperview()
        }
        
        if transparentView != nil{
            self.transparentView.removeFromSuperview()
        }
    }
    
    //Back to previous VC
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //Not Signup Before,navigate to Signup VC
    func notBecomeMemeberBeforeAction(_ sender:UIButton){
        self .dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "callMembershipAction"), object: nil)
    }
    
    //Show Forget Password popup
    func forgetPassAction(_ sender: UIButton!) {
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        popupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-150,width: screenWidth-100,height: 300))
        popupView.backgroundColor = whiteColor
        popupView.layer.cornerRadius = 20
        popupView.layer.shadowColor = UIColor.gray.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popupView.layer.shadowRadius = 20
        self.view.addSubview(popupView)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: popupView.frame.size.width - 20, height: 50))
        titleLabel.backgroundColor = whiteColor
        titleLabel.textColor = UIColor.black
        titleLabel.font = FONT_NORMAL(15)
        titleLabel.text = NSLocalizedString("resetPassword", comment: "")
        titleLabel.textAlignment = .center
        popupView.addSubview(titleLabel)
        
        emailForgetTextField = UITextField(frame: CGRect(x: titleLabel.frame.origin.x,y: titleLabel.frame.origin.y+70, width: titleLabel.frame.size.width, height: 40))
        emailForgetTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("email", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //emailForgetTextField.placeholder = NSLocalizedString("email", comment: "")
        //emailForgetTextField.font = FONT_NORMAL(20)
        emailForgetTextField.textColor = UIColor.black
        emailForgetTextField.borderStyle = .none
        emailForgetTextField.autocorrectionType = UITextAutocorrectionType.no
        emailForgetTextField.keyboardType = UIKeyboardType.default
        emailForgetTextField.returnKeyType = UIReturnKeyType.done
        emailForgetTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        emailForgetTextField.contentVerticalAlignment = .center
        emailForgetTextField.contentHorizontalAlignment = .center
        emailForgetTextField.textAlignment = .center
        emailForgetTextField.delegate = self
        emailForgetTextField.adjustsFontSizeToFitWidth = true
        emailForgetTextField.autocapitalizationType = .none
        popupView.addSubview(emailForgetTextField)
        lineView = UIView(frame: CGRect(x: emailForgetTextField.frame.origin.x,y: emailForgetTextField.frame.origin.y+45,width: emailForgetTextField.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        popupView.addSubview(lineView)
        
        getPassButton = UIButton(frame: CGRect(x: emailForgetTextField.frame.origin.x,y: emailForgetTextField.frame.origin.y+80,width: emailForgetTextField.frame.size.width,height: 50))
        getPassButton.backgroundColor = UIColor.white
        getPassButton.titleLabel?.font = FONT_MEDIUM(15)
        getPassButton.setTitle(NSLocalizedString("getPassword", comment: ""), for:UIControlState())
        getPassButton.setTitleColor(buttonColor1,for: UIControlState())
        getPassButton.addTarget(self, action: #selector(getPassAction), for: .touchUpInside)
        popupView.addSubview(getPassButton)
        getPassImage = UIImageView(frame: CGRect(x: getPassButton.frame.origin.x+90,y: getPassButton.frame.origin.y+70,width: 40,height: 40))
        getPassImage.image = UIImage(named: "getPassImage.png")
        popupView.addSubview(getPassImage)
    }
    
    //MARK: -  Connections
    
    //Login Connection
    func loginToAppAction(_ sender: UIButton!) {
        
        if (emailTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterEmail", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (passwordTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterPassword", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (!emailTextField.text!.isEmail){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("wrongEmailMessage", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //        if ((passwordTextField.text?.characters.count)!<6){
        //            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterSignupPassword", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        //            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        //            self.present(alert, animated: true, completion: nil)
        //            return
        //        }
        
        
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
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        
        let params :Dictionary<String,AnyObject> = ["username":emailTextField.text! as AnyObject,
                                                    "password":passwordTextField.text! as AnyObject
        ]
        print ("Params:\(params)")
        loginWithCallBack(apiName: "login", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    sessionID = "\(responseDic.object(forKey: "sessionid")!)"
                    let userName = "\(responseDic.object(forKey: "username")!)"
                    UserDefaults.standard.set(sessionID,forKey:"sessionID")
                    UserDefaults.standard.set(userName,forKey:"userName")
                    UserDefaults.standard.synchronize()
                    
                    //register device token
                    self.registerDeviceToken()
                    
                    UserDefaults.standard.set(true, forKey: "firstlaunch1.0")
                    self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: Notification.Name(rawValue: "callDismissIntro"), object: nil)
                        
                        let notificationName = Notification.Name("getFavouriteAddressAfterSignin")
                        NotificationCenter.default.post(name: notificationName, object: nil)
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
    
    //Forget Password Connection
    func getPassAction(_ sender:UIButton){
        //   if ARSLineProgress.shown { return }
        
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
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        //Connect to server
        let params :Dictionary<String,AnyObject> = ["mobile_email":emailForgetTextField.text! as AnyObject
        ]
        forgotPasswordWithCallBack(apiName: "forgot", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    DispatchQueue.main.async {
                        let msg:String = resDic!.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("resetPassword", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
