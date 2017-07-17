//
//  MembershipViewController.swift
//  PeikYab
//
//  Created by nooran on 9/6/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class MembershipViewController:BaseViewController,UITextFieldDelegate,UIScrollViewDelegate/*,UIAlertViewDelegate*/{
    
    //MARK: - Variables
    var scrollView : UIScrollView!
    var membershipImage : UIImageView!
    var nameTextField : UITextField!
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var getNewsButton : UIButton!
    var membershipButton : UIButton!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTopbar(NSLocalizedString("membership", comment: ""))
        backButton.addTarget(self, action: #selector(MembershipViewController.backButtonAction), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight-120))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //ImageView
        membershipImage = UIImageView(frame: CGRect(x: 0,y: 0, width: screenWidth, height: screenHeight/3))
        membershipImage.contentMode = .scaleAspectFit
        membershipImage.image = UIImage(named: "signup.png")
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            membershipImage.frame.size.height = screenHeight/4.3
        }else if DeviceType.IS_IPHONE_5{
            
            membershipImage.frame.size.height = screenHeight/3
        }else if DeviceType.IS_IPHONE_6{
            membershipImage.frame.size.height = screenHeight/3
        }else if DeviceType.IS_IPHONE_6P{
            membershipImage.frame.size.height = screenHeight/2.5
        }
        self.view.addSubview(scrollView)
        scrollView.addSubview(membershipImage)
        
        //Name TextField
        nameTextField = UITextField(frame: CGRect(x: 60,y: membershipImage.frame.origin.y+membershipImage.frame.size.height+15, width: screenWidth-120, height: 40))
        nameTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterName", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //nameTextField.placeholder = NSLocalizedString("enterName", comment: "")
        //nameTextField.font = FONT_NORMAL(20)
        nameTextField.textColor = UIColor.black
        nameTextField.borderStyle = .none
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        nameTextField.contentVerticalAlignment = .center
        nameTextField.contentHorizontalAlignment = .center
        nameTextField.textAlignment = .center
        nameTextField.keyboardType = .namePhonePad
        nameTextField.delegate = self
        nameTextField.tag = 13
        scrollView.addSubview(nameTextField)
        addLineView(nameTextField.frame.origin.x,y:nameTextField.frame.origin.y+40,w:nameTextField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
        
        //Email TextField
        emailTextField = UITextField(frame: CGRect(x: 60,y: nameTextField.frame.origin.y+nameTextField.frame.size.height+15, width: screenWidth-120, height: 40))
        emailTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("email", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //emailTextField.placeholder = NSLocalizedString("email", comment: "")
        //emailTextField.font = FONT_NORMAL(20)
        emailTextField.textColor = UIColor.black
        emailTextField.borderStyle = .none
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        emailTextField.contentVerticalAlignment = .center
        emailTextField.contentHorizontalAlignment = .center
        emailTextField.textAlignment = .center
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.tag = 14
        emailTextField.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(emailTextField)
        addLineView(emailTextField.frame.origin.x,y:emailTextField.frame.origin.y+40,w:emailTextField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
        
        //Password TextField
        passwordTextField = UITextField(frame: CGRect(x: 60,y: emailTextField.frame.origin.y+emailTextField.frame.size.height+15, width: screenWidth-120, height: 40))
        passwordTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("signupPassword", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //passwordTextField.placeholder = NSLocalizedString("signupPassword", comment: "")
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
        passwordTextField.tag = 15
        passwordTextField.isSecureTextEntry = true
        passwordTextField.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(passwordTextField)
        addLineView(passwordTextField.frame.origin.x,y:passwordTextField.frame.origin.y+40,w:passwordTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        
        //        getNewsButton = UIButton(frame: CGRect(x: 0,y: screenHeight-120,width: screenWidth,height: 60))
        //        getNewsButton.backgroundColor = buttonColor1
        //        getNewsButton.titleLabel?.font = FONT_MEDIUM(15)
        //        getNewsButton.setTitle(NSLocalizedString("getNews", comment: ""), for:UIControlState())
        //        getNewsButton.addTarget(self, action: #selector(getNewsAction), for: .touchUpInside)
        //        self.view.addSubview(getNewsButton)
        
        membershipButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        membershipButton.backgroundColor = buttonColor2
        membershipButton.titleLabel?.font = FONT_MEDIUM(15)
        membershipButton.setTitle(NSLocalizedString("membershipInPeykyab", comment: ""), for:UIControlState())
        membershipButton.addTarget(self, action: #selector(membershipAction), for: .touchUpInside)
        self.view.addSubview(membershipButton)
    }
    //MARK: -  Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+40,w:textField.frame.size.width,h:2,color:greenColor,superView: scrollView)
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 13 || textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1,y: 100), animated: true)
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 13 || textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1,y: 100), animated: true)
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1, y: 100),animated: true)
            }
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1, y: 80),animated: true)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+40,w:textField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //scrollView.setContentOffset(CGPointMake(0,0), animated: true)
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -  Custom Methods
    
    //    func getNewsAction(_ sender:UIButton){
    //        //toggle button to enable/disable get news
    //    }
    
    //Back to Previous VC
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: -  Connections
    
    //Signup Connection
    func membershipAction(_ sender: UIButton!) {
        if (nameTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterYourName", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (emailTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterEmail", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if ((passwordTextField.text?.characters.count)!<6){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterSignupPassword", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
        //connect to server
        let params :Dictionary<String,AnyObject> = ["username":emailTextField.text! as AnyObject,
                                                    "password":passwordTextField.text! as AnyObject,
                                                    "password_repeated":passwordTextField.text! as AnyObject,
                                                    "nicename":nameTextField.text! as AnyObject,
                                                    "mobile":"" as AnyObject,
                                                    "email":emailTextField.text! as AnyObject,
                                                    "activate_type":1 as AnyObject,
                                                    "type":"client" as AnyObject
        ]
        signupWithCallBack(apiName: "register", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    //call login to get session id
                    self.loginToAppAction()
                    
                    /*
                     DispatchQueue.main.async {
                     
                     let msg:String = responseDic.object(forKey: "msg") as! String
                     let alert = UIAlertController(title: NSLocalizedString("membership", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                     alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                     
                     //call login to get session id
                     self.loginToAppAction()
                     }
                     */
                    
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
    
    //Login Connection
    func loginToAppAction() {
        
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
                    })
                    
                    DispatchQueue.main.async{
                        //                        self.dismiss(animated: true, completion: {NotificationCenter.default.post(name: Notification.Name(rawValue: "callDismissIntro"), object: nil)
                        //                        })
                        let msg:String = responseDic.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("register", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
            registerTokenAsyncWithCallBack(apiName: "push/registertokenasync", params: params as NSDictionary?) { (responseDic:NSDictionary?, error:NSError?) in
                if let resDic = responseDic{
                    print(resDic)
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
