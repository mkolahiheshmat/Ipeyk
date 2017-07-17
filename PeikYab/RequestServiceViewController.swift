//
//  RequestServiceViewController.swift
//  PeikYab
//
//  Created by Developer on 9/14/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class RequestServiceViewController:BaseViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate{
    
    //MARK: - Variables
    var scrollView : UIScrollView!
    var RequestServiceMapImage : UIImageView!
    var RequestServiceLabel:UILabel!
    var RequestServiceMotorImage:UIImageView!
    var cancelButton:UIButton!
    var tripID:Int!
    var tapGesture:UITapGestureRecognizer!
    var longPress:UILongPressGestureRecognizer!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RequestServiceViewController.NavigateToDriverInfoVC(notification:)), name: NSNotification.Name(rawValue: "event102"), object: nil)
        
        //MARK: Display Notification Message in alert instead of پیام از سرور جایگزین شود
        NotificationCenter.default.addObserver(self, selector: #selector(RequestServiceViewController.NavigateToMapVC(notification:)), name: NSNotification.Name(rawValue: "event103"), object: nil)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        
        RequestServiceMapImage = UIImageView(frame: CGRect(x: 0,y: 0, width: screenWidth, height: screenHeight/3))
        RequestServiceMapImage.contentMode = .scaleAspectFill
        RequestServiceMapImage.backgroundColor = UIColor.blue
        RequestServiceMapImage.isUserInteractionEnabled = true
        RequestServiceMapImage.image = UIImage(named: "RequestServiceMap.png")
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+20)
            RequestServiceMapImage.frame.size.height = screenHeight/4
        }else if DeviceType.IS_IPHONE_5{
            
            RequestServiceMapImage.frame.size.height = screenHeight/3
        }else if DeviceType.IS_IPHONE_6{
            RequestServiceMapImage.frame.size.height = screenHeight/2.5
        }else if DeviceType.IS_IPHONE_6P{
            RequestServiceMapImage.frame.size.height = screenHeight/2.5
        }
        self.view.addSubview(scrollView)
        scrollView.addSubview(RequestServiceMapImage)
        
        //Request Service Label
        RequestServiceLabel = UILabel(frame: CGRect(x: 50,y: RequestServiceMapImage.frame.origin.y+RequestServiceMapImage.frame.size.height+90,width: screenWidth-100,height: 60))
        RequestServiceLabel.backgroundColor = UIColor.white
        RequestServiceLabel.textColor = grayColor
        RequestServiceLabel.font = FONT_MEDIUM(15)
        RequestServiceLabel.numberOfLines = 2
        RequestServiceLabel.textAlignment = .center
        RequestServiceLabel.adjustsFontSizeToFitWidth = true
        RequestServiceLabel.minimumScaleFactor = 0.5
        RequestServiceLabel.text = NSLocalizedString("peykRequstIsSending", comment: "")
        scrollView.addSubview(RequestServiceLabel)
        
        //Request Service Motor Image
        RequestServiceMotorImage = UIImageView(frame: CGRect(x: 50,y: RequestServiceLabel.frame.origin.y+RequestServiceLabel.frame.size.height+40, width: screenWidth-100, height: 30))
        RequestServiceMotorImage.contentMode = .scaleAspectFill
        RequestServiceMotorImage.image = UIImage(named: "RequestServiceMotor.png")
        scrollView.addSubview(RequestServiceMotorImage)
        
        //Cancel Trip Button
        cancelButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        cancelButton.backgroundColor = UIColor(red: 254.0/255, green: 100.0/255, blue: 105.0/255, alpha: 1.0)
        cancelButton.titleLabel?.font = FONT_MEDIUM(15)
        cancelButton.setTitle(NSLocalizedString("cancelService", comment: ""), for:UIControlState())
        cancelButton.addTarget(self, action: #selector(cancelTripAlert), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        //tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        //tapGesture.delegate = self
        //RequestServiceMapImage.isUserInteractionEnabled = true
        //RequestServiceMapImage.addGestureRecognizer(tapGesture)
        /*
         longPress = UILongPressGestureRecognizer(target: self, action: #selector(RequestServiceViewController.longPress(sender:)))
         longPress.minimumPressDuration = 1.0
         longPress.delegate = self
         
         cancelButton.addGestureRecognizer(longPress)
         */
    }
    
    //MARK: -  Custom Methods
    //Cancel Trip Action
    func cancelServiceButtonAction(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Long Tap
    func longPress(sender : UILongPressGestureRecognizer){
        
        let alertController = UIAlertController(title: NSLocalizedString("cancelService", comment: ""), message:NSLocalizedString("doYouWantToCancelTrip", comment: ""), preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) {
            (action:UIAlertAction!) in
            self.cancelTrip()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel)
        { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:nil)
        //cancelServiceButtonAction()
    }
    
    func cancelTripAlert(){
        
        let alertController = UIAlertController(title: NSLocalizedString("cancelService", comment: ""), message:NSLocalizedString("doYouWantToCancelTrip", comment: ""), preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) {
            (action:UIAlertAction!) in
            self.cancelTrip()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel)
        { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:nil)
        //cancelServiceButtonAction()
    }
    
    //Handle Gesture
    //    func handleGesture(_ sender: UITapGestureRecognizer){
    //
    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
    //        self.navigationController?.pushViewController(nextViewController, animated: true)
    //    }
    
    //MARK: Push Notification Selector
    //navigate to DriverInfo VC
    func NavigateToDriverInfoVC(notification: Notification){
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        print(tempDic)
        let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        let driverID:Int = data["details"]!["driverid"] as! Int
        
        print("Driver ID:\(driverID)")
        
        let tripID:Int = data["details"]!["tripid"] as! Int
        
        print("Trip ID:\(tripID)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: Push Notification Selector
    //Display Notification Message in alert instead of پیام از سرور جایگزین شود
    //navigate to Map VC
    func NavigateToMapVC(notification: Notification) {
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        
        let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        var message:String = data["details"]!["message"] as! String
        
        message = message.removingPercentEncoding!
        message = message.replacingOccurrences(of: "+", with: " ")
        
        let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message:message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.perform(#selector(RequestServiceViewController.showMapVC), with: nil, afterDelay: 0.7)
        
        //_ = self.navigationController?.popToRootViewController(animated: false)
        
        let notificationName = Notification.Name("showAlert")
        NotificationCenter.default.post(name: notificationName, object: tempDic)
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //_ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    func showMapVC(){
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    //MARK: -  Connections
    
    //Cancel Trip Connection
    func cancelTrip(){
        
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
        if sessionID != nil {
           ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        } 
            let params :Dictionary<String,AnyObject> =
                ["sessionid": sessionID! as AnyObject,
                 "tripid":tripID as AnyObject]
            
            cancelTripWithCallBack(apiName: "trip/canceltrip", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    print(responseDic)
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        DispatchQueue.main.async {
                            
                            self.cancelServiceButtonAction()
                            
                            let msg:String = responseDic.object(forKey: "msg") as! String
                            // let alertController = UIAlertController(title: NSLocalizedString("cancelService", comment: ""), message:msg, preferredStyle: .alert)
                            //let OKAction = UIAlertAction(title: NSLocalizedString("back", comment: ""), style:  .default) {
                            //    (action:UIAlertAction!) in
                            // }
                            //alertController.addAction(OKAction)
                            //self.present(alertController, animated: true, completion: nil)
                            
                            let notificationName = Notification.Name("showCancelTripAlert")
                            NotificationCenter.default.post(name: notificationName, object: msg)
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
                                
                                let notificationName = Notification.Name("showCancelTripAlert")
                                NotificationCenter.default.post(name: notificationName, object: msg)
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
}
