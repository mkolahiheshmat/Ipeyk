//
//  ReceiverInfoViewController.swift
//  PeikYab
//
//  Created by Developer on 9/14/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class ReceiverInfoViewController:BaseViewController,UIScrollViewDelegate,UITextFieldDelegate{
    
    //MARK: - Variables
    var scrollView : UIScrollView!
    var ReceiverInfoImage : UIImageView!
    var EnterRecieverInfoLabel:UILabel!
    var nameTextField : UITextField!
    var phoneTextField : UITextField!
    var addressTextField : UITextField!
    var cashAtDestinationLabel:UILabel!
    var cashAtDestinationSwitch:UISwitch!
    var sweepServiceLabel:UILabel!
    var sweepServiceLSwitch:UISwitch!
    var agreementButton:UIButton!
    var priceLabel:UILabel!
    
    var originLatitude:CLLocationDegrees = 0.0
    var originLongitude:CLLocationDegrees = 0.0
    var destinationLatitude:CLLocationDegrees = 0.0
    var destinationLongitude:CLLocationDegrees = 0.0
    var originLocationName:String!
    var destinationLocationName:String!
    var shipPriceString:String?
    var totalPriceString:String?
    var finalPriceString:String?
    var hasReturn:Int?
    var payAtDestination:Int?
    var separatedNumberString:String?
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = ","
//        let intFinalPrice = Int(finalPriceString!)
//        let NSPrice:NSNumber = NSNumber(value:intFinalPrice!)
//        separatedNumberString = formatter.string(from: NSPrice)
        
        makeTopbar(NSLocalizedString("sourceAndDestWereSaved", comment: ""))
        self.hideKeyboardWhenTappedAround()
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        finalPriceString = shipPriceString
        
        //ImageView
        ReceiverInfoImage = UIImageView(frame: CGRect(x: 0,y: 10, width: screenWidth, height: screenHeight/4))
        ReceiverInfoImage.contentMode = .scaleAspectFit
        ReceiverInfoImage.image = UIImage(named: "ReceiverInfo.png")
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            ReceiverInfoImage.frame.size.height = screenHeight/7
        }else if DeviceType.IS_IPHONE_5{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            ReceiverInfoImage.frame.size.height = screenHeight/3.75
        }else if DeviceType.IS_IPHONE_6{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+20)
            ReceiverInfoImage.frame.size.height = screenHeight/3
        }else if DeviceType.IS_IPHONE_6P{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+10)
            ReceiverInfoImage.frame.size.height = screenHeight/2.5
        }
        self.view.addSubview(scrollView)
        scrollView.addSubview(ReceiverInfoImage)
        
        EnterRecieverInfoLabel = UILabel(frame: CGRect(x: 0,y: ReceiverInfoImage.frame.origin.y+ReceiverInfoImage.frame.size.height+20,width: screenWidth,height: 25))
        EnterRecieverInfoLabel.backgroundColor = UIColor.white
        EnterRecieverInfoLabel.textColor = UIColor.black
        EnterRecieverInfoLabel.font = FONT_BOLD(13)
        EnterRecieverInfoLabel.numberOfLines = 1
        EnterRecieverInfoLabel.textAlignment = .center
        EnterRecieverInfoLabel.adjustsFontSizeToFitWidth = true
        EnterRecieverInfoLabel.minimumScaleFactor = 0.5
        EnterRecieverInfoLabel.text = NSLocalizedString("enterReceiverInfo", comment: "")
        scrollView.addSubview(EnterRecieverInfoLabel)
        
        //Name TextField
        nameTextField = UITextField(frame: CGRect(x: 40,y: EnterRecieverInfoLabel.frame.origin.y+EnterRecieverInfoLabel.frame.size.height+10, width: screenWidth-80, height: 30))
        nameTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterName", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //nameTextField.placeholder = NSLocalizedString("enterName", comment: "")
        nameTextField.font = FONT_MEDIUM(12)
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
        nameTextField.text = ""
        nameTextField.autocapitalizationType = .none
        scrollView.addSubview(nameTextField)
        addLineView(nameTextField.frame.origin.x+20,y:nameTextField.frame.origin.y+nameTextField.frame.size.height+10,w:nameTextField.frame.size.width-40,h:2,color:lineViewColor,superView: scrollView)
        
        //Phone TextField
        phoneTextField = UITextField(frame: CGRect(x: 40,y: nameTextField.frame.origin.y+nameTextField.frame.size.height+15, width: screenWidth-80, height: 30))
        phoneTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("callNumber", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //phoneTextField.placeholder = NSLocalizedString("callNumber", comment: "")
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .numberPad
        phoneTextField.layer.borderColor = grayColor.cgColor
        phoneTextField.backgroundColor = whiteColor
        phoneTextField.textAlignment = .center
        phoneTextField.keyboardType = .numberPad
        phoneTextField.font = FONT_MEDIUM(12)
        phoneTextField.autocorrectionType = .no
        phoneTextField.delegate = self
        phoneTextField.tag = 14
        phoneTextField.text = ""
        addLineView(phoneTextField.frame.origin.x+20,y:phoneTextField.frame.origin.y+phoneTextField.frame.size.height+10,w:phoneTextField.frame.size.width-40,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(phoneTextField)
        
        //Address TextField
        addressTextField = UITextField(frame: CGRect(x: 40,y: phoneTextField.frame.origin.y+phoneTextField.frame.size.height+15, width: screenWidth-80, height: 30))
        addressTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("address", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //addressTextField.placeholder = NSLocalizedString("address", comment: "")
        addressTextField.delegate = self
        addressTextField.tag = 15
        addressTextField.layer.borderColor = grayColor.cgColor
        addressTextField.backgroundColor = whiteColor
        addressTextField.textAlignment = .center
        addressTextField.font = FONT_MEDIUM(12)
        addressTextField.text = ""
        addressTextField.autocorrectionType = .no
        addressTextField.autocapitalizationType = .none
        addLineView(addressTextField.frame.origin.x+20,y:addressTextField.frame.origin.y+addressTextField.frame.size.height+10,w:addressTextField.frame.size.width-40,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(addressTextField)
        
        cashAtDestinationLabel = UILabel(frame: CGRect(x: screenWidth-220,y: addressTextField.frame.origin.y+addressTextField.frame.size.height+20,width: 200,height: 25))
        cashAtDestinationLabel.backgroundColor = UIColor.white
        cashAtDestinationLabel.textColor = UIColor.black
        cashAtDestinationLabel.font = FONT_MEDIUM(14)
        cashAtDestinationLabel.numberOfLines = 1
        cashAtDestinationLabel.textAlignment = .right
        cashAtDestinationLabel.adjustsFontSizeToFitWidth = true
        cashAtDestinationLabel.minimumScaleFactor = 0.5
        cashAtDestinationLabel.text = NSLocalizedString("cashAtDestination", comment: "")
        scrollView.addSubview(cashAtDestinationLabel)
        
        cashAtDestinationSwitch=UISwitch(frame:CGRect(x: 30,y: cashAtDestinationLabel.frame.origin.y,width: 50,height: 20))
        cashAtDestinationSwitch.setOn(false, animated: false);
        cashAtDestinationSwitch.addTarget(self, action:#selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        cashAtDestinationSwitch.tag = 1000
        scrollView.addSubview(cashAtDestinationSwitch)
        
        sweepServiceLabel = UILabel(frame: CGRect(x: screenWidth-220,y: cashAtDestinationLabel.frame.origin.y+cashAtDestinationLabel.frame.size.height+20,width: 200,height: 25))
        sweepServiceLabel.backgroundColor = UIColor.white
        sweepServiceLabel.textColor = UIColor.black
        sweepServiceLabel.font = FONT_MEDIUM(14)
        sweepServiceLabel.numberOfLines = 1
        sweepServiceLabel.textAlignment = .right
        sweepServiceLabel.adjustsFontSizeToFitWidth = true
        sweepServiceLabel.minimumScaleFactor = 0.5
        sweepServiceLabel.text = NSLocalizedString("sweepService", comment: "")
        scrollView.addSubview(sweepServiceLabel)
        
        sweepServiceLSwitch = UISwitch(frame:CGRect(x: 30,y: sweepServiceLabel.frame.origin.y,width: 50,height: 20))
        sweepServiceLSwitch.setOn(false, animated: false);
        sweepServiceLSwitch.addTarget(self, action: #selector(SettingViewController.switchValueDidChange(_:)), for: .valueChanged);
        sweepServiceLSwitch.tag = 2000
        scrollView.addSubview(sweepServiceLSwitch)
        
        agreementButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        agreementButton.backgroundColor = tripIDLabelColor
        agreementButton.titleLabel?.font = FONT_MEDIUM(15)
        agreementButton.setTitle(NSLocalizedString("IWillCountinue", comment: ""), for:UIControlState())
        agreementButton.addTarget(self, action: #selector(agreementButtonAction), for: .touchUpInside)
        self.view.addSubview(agreementButton)
        
        priceLabel = UILabel(frame: CGRect(x: 0,y: screenHeight-100,width: screenWidth,height: 40))
        priceLabel.backgroundColor = lightBlue
        priceLabel.textColor = topViewBlue
        priceLabel.font = FONT_NORMAL(15)
        //priceLabel.text = NSLocalizedString("price", comment: "")+"\t"+"\(finalPriceString!)" + NSLocalizedString("rial", comment: "")
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .center
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.isHidden = true
        self.view.addSubview(priceLabel)
        
    }
    //MARK: - Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        addLineView(textField.frame.origin.x+20,y:textField.frame.origin.y+textField.frame.size.height+10,w:textField.frame.size.width-40,h:2,color:greenColor,superView: scrollView)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 13 || textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1,y: 80), animated: true)
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 13 || textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1,y: 70), animated: true)
            }
            
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1, y: 50),animated: true)
            }
            
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 14 || textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 1, y: 70),animated: true)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        addLineView(textField.frame.origin.x+20,y:textField.frame.size.height+textField.frame.origin.y+10,w:textField.frame.size.width-40,h:2,color:lineViewColor,superView: scrollView)
        
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
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
        textField.resignFirstResponder();
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Switch Delegate
    func switchValueDidChange(_ sender:UISwitch!)
    {
        switch sender.tag{
        case 1000:
            //cashAtDestinationSwitch
            if (sender.isOn == true){
            }else{
            }
            break
        case 2000:
            //sweepServiceLSwitch
            if (sender.tag == 2000)&&(sender.isOn == true){
                print("Sweep Service is on")
                
                //getPrice()
                
                finalPriceString = totalPriceString!
                
                print("TOTAL PRICE:\(totalPriceString!)")
                print("FINAL PRICE:\(finalPriceString!)")
                
                priceLabel.text = NSLocalizedString("price", comment: "")+"         "+"\(finalPriceString!)"+NSLocalizedString("rial", comment: "")
                
                if DeviceType.IS_IPHONE_4_OR_LESS {
                    priceLabel.isHidden = false
                    scrollView.setContentOffset(CGPoint(x: 1,y: 80), animated: true)
                }else if DeviceType.IS_IPHONE_5{
                    priceLabel.isHidden = false
                    scrollView.setContentOffset(CGPoint(x: 1,y: 50), animated: true)
                }else if DeviceType.IS_IPHONE_6{
                    priceLabel.isHidden = false
                    scrollView.setContentOffset(CGPoint(x: 1,y: 50), animated: true)
                }else if DeviceType.IS_IPHONE_6P{
                    priceLabel.isHidden = false
                    scrollView.setContentOffset(CGPoint(x: 1,y: 30), animated: true)
                }
            }else{
               finalPriceString = shipPriceString
                priceLabel.text = NSLocalizedString("price", comment: "")+"         "+"\(finalPriceString!)"+NSLocalizedString("rial", comment: "")
                  priceLabel.isHidden = true
               scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
            }
            break
        default:
            print("Nothing")
        }
    }
    //MARK: -  Custom Methods
    
    //Agree To request Trip
    func agreementButtonAction(_ sender: UIButton!) {
        
        //////////////////////////////UNCOMMENT AFTER TEST/////////////////////////////////////////////////////////////////////////
        requestTrip()
        
        //        //////////////////////////////DELETE AFTER TEST/////////////////////////////////////////////////////////////////////////
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        let view = storyBoard.instantiateViewController(withIdentifier: "RequestServiceViewController") as! RequestServiceViewController
        //        //view.tripID = tripid
        //        self.navigationController?.pushViewController(view, animated: true)
        //        //////////////////////////////DELETE AFTER TEST/////////////////////////////////////////////////////////////////////////
    }
    
    //Navigate to Request Service VC
    func RequestServiceViewController(tripid:Int) -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "RequestServiceViewController") as! RequestServiceViewController
        view.tripID = tripid
        self.navigationController?.pushViewController(view, animated: true)
    }
    

    //Back to Previous VC
    func backAction(){
        _ = self.navigationController?.popViewController( animated: true)
    }
    
    //MARK: -  Connections
    
    //Request Trip Connection
    func requestTrip(){
        
        /*
         /////////////////////////////   TextFields Validation    //////////////////////////////////////////////
         
         if (nameTextField.text?.characters.count==0){
         let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterRecieverName", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         
         if ((phoneTextField.text?.characters.count)!<8){
         let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterRecieverPhone", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         if (addressTextField.text?.characters.count==0){
         let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterRecieverAddress", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         */
        
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
        
        UserDefaults.standard.setValue(originLatitude, forKey: "originLatitude")
        UserDefaults.standard.setValue(originLongitude, forKey: "originLongitude")
        UserDefaults.standard.setValue(finalPriceString!, forKey: "tripPrice")
        
        if sweepServiceLSwitch.isOn == true{
            hasReturn = 2
        }else {
            hasReturn = 1
        }
        
        if cashAtDestinationSwitch.isOn == true{
            payAtDestination = 2
        }else {
            payAtDestination = 1
        }
        
        if sessionID != nil {
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> =
                ["sessionid": sessionID! as AnyObject,
                 "origlatitude":originLatitude as AnyObject,
                 "origlongitude":originLongitude as AnyObject,
                 "origlocalname":originLocationName as AnyObject,
                 "destlatitude":destinationLatitude as AnyObject,
                 "destlongitude":destinationLongitude as AnyObject,
                 "destlocalname":destinationLocationName as AnyObject,
                 "hasreturn": hasReturn! as AnyObject,
                 "discountcode":"" as AnyObject,
                 "totalprice":finalPriceString! as AnyObject,
                 "recieverinfotype":1 as AnyObject,
                 "recievername":nameTextField.text! as AnyObject,
                 "recievernumber":phoneTextField.text! as AnyObject,
                 "recieveraddress":addressTextField.text! as AnyObject,
                 "paymenttype":payAtDestination! as AnyObject]
            print("params:(\(params)")
            requestTripWithCallBack(apiName: "trip/requesttrip", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async {
                            
                           // let tripID:Int? = UserDefaults.standard.object(forKey: "tripID") as? Int
                            
                            ////TripID not set Before in getLast InProgress Trip WS in ViewController(Map)
                            //if tripID == nil{
                                
                                let tripId:Int = responseDic.object(forKey: "tripid") as! Int
                                UserDefaults.standard.set(tripId, forKey: "tripID")
                                self.RequestServiceViewController(tripid: tripId)
                                print("tripID:\(tripId)")
                                
//                                //TripID set Before in get Last InProgress Trip WS in ViewController(Map)
//                            }else{
//                                self.RequestServiceViewController(tripid: tripID!)
//                                print("tripID:\(tripID)")
//                            }
                            
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
    /*
    func getPrice(){
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            
            if sweepServiceLSwitch.isOn == true{
                hasReturn = 2
            }else {
                hasReturn = 1
            }
            
            let params :Dictionary<String,AnyObject> =
                ["sessionid": sessionID! as AnyObject,
                 "origlatitude": originLatitude as AnyObject,
                 "origlongitude": originLongitude as AnyObject,
                 "destlatitude": destinationLatitude as AnyObject,
                 "destlongitude": destinationLongitude as AnyObject,
                 "hasreturn": hasReturn as AnyObject
                    //"discountcode": messageTextView.text! as AnyObject
            ]
            
            getPriceWithCallBack(apiName: "trip/getprice", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        //let shipprice:Int? = responseDic.object(forKey: "shipprice") as? Int
                        let totalPrice:Int? = responseDic.object(forKey: "totalprice") as? Int
                        DispatchQueue.main.async {
                            if totalPrice != nil{
                                self.totalPriceString = "\(totalPrice!)"
                                
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .decimal
                                formatter.groupingSeparator = ","
                                let IntTotalPriceString = Int(totalPrice!)
                                let NSPrice:NSNumber = NSNumber(value:IntTotalPriceString)
                                let Separator = formatter.string(from: NSPrice)
                                self.totalPriceString = "\(Separator!)"
                                self.finalPriceString = "\(totalPrice!)"
                                print("finall:\(self.finalPriceString!)")
                                
                                //self.priceButton.setTitle("\(Separator!)"+NSLocalizedString("rial", comment: ""), for: .normal)
                                
                                DispatchQueue.main.async {
                                    self.priceLabel.isHidden = false
                                    self.priceLabel.text = NSLocalizedString("price", comment: "")+"         "+"\(Separator!)"+NSLocalizedString("rial", comment: "")
                                    
                                }
                            }
                            
//                            if totalPrice != nil{
//                                
//                                let formatter = NumberFormatter()
//                                formatter.numberStyle = .decimal
//                                formatter.groupingSeparator = ","
//                                let IntTotalPrice = Int(totalPrice!)
//                                let NSPrice:NSNumber = NSNumber(value:IntTotalPrice)
//                                let SeparatorNumber = formatter.string(from: NSPrice)
//                                
//                                self.totalPriceString = "\(SeparatorNumber!)"
//                            }
                            
                            
                            if totalPrice == nil{
                                DispatchQueue.main.async {
                                    self.getPrice()
                                    /*
                                     let msg:String = NSLocalizedString("NOPrice", comment: "")
                                     let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                     alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                     self.present(alert, animated: true, completion: nil)
                                     */
                                }
                            }
                            
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
                    DispatchQueue.main.async {
                       // self.indicatorForPrice.stopAnimating()
                    }
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
 */

}

