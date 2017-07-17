//
//  settingViewController.swift
//  PeikYab
//
//  Created by Yarima on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController:BaseViewController,UIScrollViewDelegate{
    
    //MARK: - Variables
    var scrollView :UIScrollView!
    var settingImage : UIImageView!
    var subscriptionsLabel: UILabel!
    var getNewsLabel : UILabel!
    var getNewsSwitch : UISwitch!
    var getInfoEmailLabel: UILabel!
    var getInfoEmailSwitch:UISwitch!
    var getInfoSMSLabel:UILabel!
    var getInfoSMSSwitch:UISwitch!
    var getTurnoverSMSLabel:UILabel!
    var getTurnoverSMSSwitch:UISwitch!
    var getTurnoverEmailLabel:UILabel!
    var getTurnoverEmailSwitch:UISwitch!
    var getNews:Int = 0
    var infoSMS:Int = 0
    var infoEmail:Int = 0
    var turnoverSMS:Int = 0
    var turnoverEmail:Int = 0
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSetting()
        
        makeTopbar(NSLocalizedString("setting", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200)
        }else if DeviceType.IS_IPHONE_5{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }else if DeviceType.IS_IPHONE_6{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }else if DeviceType.IS_IPHONE_6P{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }
        self.view.addSubview(scrollView)
        self.view.isUserInteractionEnabled = true
        
        settingImage = UIImageView(frame: CGRect(x: 0,y: 0, width: screenWidth,height: screenHeight/4))
        settingImage.image = UIImage(named: "setting.png")
        settingImage.contentMode = .scaleAspectFit
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(settingImage)
        
        subscriptionsLabel = UILabel(frame: CGRect(x: screenWidth-220,y: settingImage.frame.origin.y+settingImage.frame.size.height,width: 200,height: 40))
        subscriptionsLabel.backgroundColor = UIColor.white
        subscriptionsLabel.textColor = topViewBlue
        subscriptionsLabel.font = FONT_NORMAL(15)
        subscriptionsLabel.numberOfLines = 1
        subscriptionsLabel.textAlignment = .right
        subscriptionsLabel.adjustsFontSizeToFitWidth = true
        subscriptionsLabel.minimumScaleFactor = 0.5
        subscriptionsLabel.text = NSLocalizedString("subscriptions", comment: "")
        scrollView.addSubview(subscriptionsLabel)
        
        getNewsLabel = UILabel(frame: CGRect(x: subscriptionsLabel.frame.origin.x,y: subscriptionsLabel.frame.origin.y+subscriptionsLabel.frame.size.height+20,width: 200,height: 40))
        getNewsLabel.backgroundColor = UIColor.white
        getNewsLabel.textColor = UIColor.black
        getNewsLabel.font = FONT_NORMAL(13)
        getNewsLabel.numberOfLines = 1
        getNewsLabel.textAlignment = .right
        getNewsLabel.adjustsFontSizeToFitWidth = true
        getNewsLabel.minimumScaleFactor = 0.5
        getNewsLabel.text = NSLocalizedString("getNews", comment: "")
        scrollView.addSubview(getNewsLabel)
        
        getNewsSwitch=UISwitch(frame:CGRect(x: 30,y: getNewsLabel.frame.origin.y,width: 50,height: 50))
        getNewsSwitch.addTarget(self, action: #selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        getNewsSwitch.tag = 1000
        scrollView.addSubview(getNewsSwitch)
        
        getInfoEmailLabel = UILabel(frame: CGRect(x: getNewsLabel.frame.origin.x,y: getNewsLabel.frame.origin.y+getNewsLabel.frame.size.height+20,width: 200,height: 40))
        getInfoEmailLabel.backgroundColor = UIColor.white
        getInfoEmailLabel.textColor = UIColor.black
        getInfoEmailLabel.font = FONT_NORMAL(13)
        getInfoEmailLabel.numberOfLines = 1
        getInfoEmailLabel.textAlignment = .right
        getInfoEmailLabel.adjustsFontSizeToFitWidth = true
        getInfoEmailLabel.minimumScaleFactor = 0.5
        getInfoEmailLabel.text = NSLocalizedString("getInfoEmail", comment: "")
        scrollView.addSubview(getInfoEmailLabel)
        
        getInfoEmailSwitch=UISwitch(frame:CGRect(x: 30,y: getInfoEmailLabel.frame.origin.y,width: 50,height: 50))
        getInfoEmailSwitch.addTarget(self, action: #selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        getInfoEmailSwitch.tag = 2000
        scrollView.addSubview(getInfoEmailSwitch)
        
        getInfoSMSLabel = UILabel(frame: CGRect(x: getInfoEmailLabel.frame.origin.x,y: getInfoEmailLabel.frame.origin.y+getInfoEmailLabel.frame.size.height+20,width: 200,height: 40))
        getInfoSMSLabel.backgroundColor = UIColor.white
        getInfoSMSLabel.textColor = UIColor.black
        getInfoSMSLabel.font = FONT_NORMAL(13)
        getInfoSMSLabel.numberOfLines = 1
        getInfoSMSLabel.textAlignment = .right
        getInfoSMSLabel.adjustsFontSizeToFitWidth = true
        getInfoSMSLabel.minimumScaleFactor = 0.5
        getInfoSMSLabel.text = NSLocalizedString("getInfoSMS", comment: "")
        scrollView.addSubview(getInfoSMSLabel)
        
        getInfoSMSSwitch=UISwitch(frame:CGRect(x: 30,y: getInfoSMSLabel.frame.origin.y,width: 50,height: 50))
        getInfoSMSSwitch.addTarget(self, action:#selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        getInfoSMSSwitch.tag = 3000
        scrollView.addSubview(getInfoSMSSwitch)
        
        getTurnoverSMSLabel = UILabel(frame: CGRect(x: getInfoSMSLabel.frame.origin.x,y: getInfoSMSLabel.frame.origin.y+getInfoSMSLabel.frame.size.height+20,width: 200,height: 40))
        getTurnoverSMSLabel.backgroundColor = UIColor.white
        getTurnoverSMSLabel.textColor = UIColor.black
        getTurnoverSMSLabel.font = FONT_NORMAL(13)
        getTurnoverSMSLabel.numberOfLines = 1
        getTurnoverSMSLabel.textAlignment = .right
        getTurnoverSMSLabel.adjustsFontSizeToFitWidth = true
        getTurnoverSMSLabel.minimumScaleFactor = 0.5
        getTurnoverSMSLabel.text = NSLocalizedString("getTurnoverSMS", comment: "")
        scrollView.addSubview(getTurnoverSMSLabel)
        
        getTurnoverSMSSwitch=UISwitch(frame:CGRect(x: 30,y: getTurnoverSMSLabel.frame.origin.y,width: 50,height: 50))
        getTurnoverSMSSwitch.addTarget(self, action: #selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        getTurnoverSMSSwitch.tag = 4000
        scrollView.addSubview(getTurnoverSMSSwitch)
        
        getTurnoverEmailLabel = UILabel(frame: CGRect(x: getTurnoverSMSLabel.frame.origin.x,y: getTurnoverSMSLabel.frame.origin.y+getTurnoverSMSLabel.frame.size.height+20,width: 200,height: 40))
        getTurnoverEmailLabel.backgroundColor = UIColor.white
        getTurnoverEmailLabel.textColor = UIColor.black
        getTurnoverEmailLabel.font = FONT_NORMAL(13)
        getTurnoverEmailLabel.numberOfLines = 1
        getTurnoverEmailLabel.textAlignment = .right
        getTurnoverEmailLabel.adjustsFontSizeToFitWidth = true
        getTurnoverEmailLabel.minimumScaleFactor = 0.5
        getTurnoverEmailLabel.text = NSLocalizedString("getTurnoverEmail", comment: "")
        scrollView.addSubview(getTurnoverEmailLabel)
        
        getTurnoverEmailSwitch=UISwitch(frame:CGRect(x: 30,y: getTurnoverEmailLabel.frame.origin.y,width: 50,height: 50))
        getTurnoverEmailSwitch.addTarget(self, action: #selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        getTurnoverEmailSwitch.tag = 5000
        scrollView.addSubview(getTurnoverEmailSwitch)
    }
    
    //MARK: -  Switch Delegate
    func switchValueDidChange(_ sender:UISwitch!){
        switch sender.tag{
        case 1000:
            if (sender.isOn == true){
                getNews = 1
            }else{
                getNews = 0
            }
            setSetting()
            break
        case 2000:
            if (sender.tag == 2000)&&(sender.isOn == true){
                infoEmail = 1
            }else{
                infoEmail = 0
            }
            setSetting()
            break
        case 3000:
            if (sender.isOn == true){
                infoSMS = 1
            }else{
                infoSMS = 0
            }
            setSetting()
            break
        case 4000:
            if (sender.isOn == true){
                turnoverSMS = 1
            }else{
                turnoverSMS = 0
            }
            setSetting()
            break
        case 5000:
            if (sender.isOn == true){
                turnoverEmail = 1
            }else{
                turnoverEmail = 0
            }
            setSetting()
            break
        default:
            print("Nothing")
        }
    }
    
    //MARK: -  Custom Methods
    
    //Back to previous VC
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Update Switches states on UI
    func updateUI(){
        //update getnews Switch
        if getNews == 1{
            getNewsSwitch.setOn(true, animated:true)
        }else{
            getNewsSwitch.setOn(false, animated:true)
        }
        
        //update infoEmail Switch
        if infoEmail == 1{
            getInfoEmailSwitch.setOn(true, animated:true)
        }else{
            getInfoEmailSwitch.setOn(false, animated:true)
        }
        
        //update info SMS switch
        if infoSMS == 1{
            getInfoSMSSwitch.setOn(true, animated:true)
        }else{
            getInfoSMSSwitch.setOn(false, animated:true)
        }
        
        //update turnoverSMS switch
        if turnoverSMS == 1{
            getTurnoverSMSSwitch.setOn(true, animated:true)
        }else{
            getTurnoverSMSSwitch.setOn(false, animated:true)
        }
        
        //update turnoverEmail switch
        if turnoverEmail == 1{
            getTurnoverEmailSwitch.setOn(true, animated:true)
        }else{
            getTurnoverEmailSwitch.setOn(false, animated:true)
        }
    }
    
    //MARK: -  Connections
    
    //Get Setting Connection
    func getSetting(){
        
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
        

        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject]
        
        getSettingWithCallBack(apiName: "getsettings", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                
                if (resDic?.object(forKey: "status") as! Int) == 1{
                    
                    if let array = responseDic["data"] as? [[String:AnyObject]] {
                        
                        for item in array {
                            
                            let keyString:String = item["key"] as! String
                            // let value:Int? = item["value"] as! Int
                            
                            let value:Int? = (item["value"] as! NSString).integerValue
                        
                            switch keyString{
                            case "sendnewsletter":
                                self.getNews = value!
                                break
                            case "sendtripinfobysms":
                                self.infoSMS = value!
                                break
                            case "sendtripinfobyemail":
                                self.infoEmail = value!
                                break
                            case "sendtransactionbysms":
                                self.turnoverSMS = value!
                                break
                            case "sendtransactionbyemail":
                                self.turnoverEmail = value!
                                break
                            default:
                                break
                                
                            }//Switch
                        }// For
                        //update UI
                        DispatchQueue.main.async {
                            self.updateUI()
                        }//Dispatch
                    }//IF
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
    
    // Set Setting Connection
    func setSetting(){
        
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

        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject,
                                                    "sendnewsletter":getNews as AnyObject ,
                                                    "sendtripinfobyemail":infoEmail as AnyObject,
                                                    "sendtripinfobysms":infoSMS as AnyObject,
                                                    "sendtransactionbyemail":turnoverEmail as AnyObject,
                                                    "sendtransactionbysms":turnoverSMS as AnyObject,
                                                    "language": "farsi" as AnyObject
        ]
        setSettingWithCallBack(apiName: "setsettings", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    DispatchQueue.main.async {
                        //                        let alert = UIAlertController(title: NSLocalizedString("setSetting", comment: ""), message: NSLocalizedString("saveProfile", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                        //                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
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
}
