//
//  PeikArrivedAtOriginViewController.swift
//  PeikYab
//
//  Created by Developer on 9/14/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class PeikArrivedAtOriginViewController:BaseViewController,UIScrollViewDelegate,UITextFieldDelegate{
    
    //MARK: - Variables
    var scrollView:UIScrollView!
    var driverProfileImageView:UIImageView!
    var driverImageURL:String!
    var nameLabel:UILabel!
    var pelakLabel:UILabel!
    var motorImage:UIImageView!
    var arriveMessageLabel:UILabel!
    var hopeLabel:UILabel!
    var walletImage:UIImageView!
    var tripCode:Int = 0
    var tripCodeLabel:UILabel!
    var cashButton:UIButton!
    var callDriverButton:UIButton!
    var messageToDriverButton:UIButton!
    var sendpopupView:UIView!
    var desiredTextLabel:UILabel!
    var messageTextField:UITextField!
    var templateMessageButton1:UIButton!
    var templateMessageButton2:UIButton!
    var tapGesture:UITapGestureRecognizer!
    var transparentView:UIView!
    var templateMessageArray = [[String:AnyObject]]()
    var templateMessageid1 :Int = 0
    var templateMessageText1 :String = ""
    var templateMessageid2 :Int = 0
    var templateMessageText2 :String = ""
    var messageID:Int = 0
    var tripCost:String!
    //var driverName:String = ""
    //var pelak:String = ""
    //var driverMobileNumber:String = ""
    
    var cashTransparentView:UIView!
    var cashPopupView : UIView!
    var amountToPayLabel:UILabel!
    var cashPriceLabel:UILabel!
    var currentCreditLabel:UILabel!
    var currentCredit:Int = 0
    
    var addCreditTransparentView:UIView!
    var addCreditPopupView:UIView!
    var addCreditCurrentCreditLabel:UILabel!
    var amountTextField:UITextField!
    var addCreditTapGesture:UIGestureRecognizer!
    var paymentNumber : Int = 0
    var onlinePaymentButton:UIButton!
    //var USSDPaymentButton:UIButton!
    var peykyabButton:UIButton!
    var payButton:UIButton!
    var webViewURL:String!
    var addCreditCloseButton:UIButton!
    
    var imageTapGesture:UITapGestureRecognizer!
    
    //MARK: -  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        paymentNumber = 0 
        getTripCost()
        //getTripDriverInfo()
        //getCredit()
        getMessageToDriverTemplate()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PeikArrivedAtOriginViewController.NavigateToMapVC(notification:)), name: NSNotification.Name(rawValue: "event106"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PeikArrivedAtOriginViewController.NavigateToMapOnCancelByDriver(notification:)), name: NSNotification.Name(rawValue: "event111"), object: nil)
        
        // getTripDriverInfo()
        
        // getTripCost()
        
        // getMessageToDriverTemplate()
        
        self.hideKeyboardWhenTappedAround()
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200)
        }else if DeviceType.IS_IPHONE_5{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
        }else if DeviceType.IS_IPHONE_6{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }else if DeviceType.IS_IPHONE_6P{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }
        self.view.addSubview(scrollView)
        self.view.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        self.hideKeyboardWhenTappedAround()
        
        // Driver Image
        driverProfileImageView = UIImageView(frame: CGRect(x: screenWidth-80,y: 20, width: 50, height: 50))
        driverImageURL = UserDefaults.standard.object(forKey: "driverImageURL") as? String
        if driverImageURL != nil{
            self.driverProfileImageView.imageFromServerURL(urlString: driverImageURL)
            
        }else{
            driverProfileImageView.image = UIImage(named: "driverProfileImage")
        }
        //driverProfileImageView.image = UIImage(named: "driverProfileImage")
        driverProfileImageView.contentMode = .scaleAspectFit
        driverProfileImageView.isUserInteractionEnabled = true
        scrollView.addSubview(driverProfileImageView)
        
        // DriverName Label
        nameLabel = UILabel(frame: CGRect(x: 20,y: 20,width: 200,height: 25))
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textColor = topViewBlue
        nameLabel.font = FONT_NORMAL(15)
        
        let driverName:String? = UserDefaults.standard.object(forKey: "driverName") as? String
        print("driverName:\(driverName)")
        nameLabel.text = driverName   //NSLocalizedString("Nima", comment: "")
        
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(nameLabel)
        
        // Pelak Label
        pelakLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x,y: nameLabel.frame.origin.y+nameLabel.frame.size.height,width: 200,height: 25))
        pelakLabel.backgroundColor = UIColor.white
        pelakLabel.textColor = UIColor.darkGray
        pelakLabel.font = FONT_NORMAL(15)
        
        let pelak:String? = UserDefaults.standard.object(forKey: "driverPelak") as? String
        print("pelak:\(pelak)")
        pelakLabel.text = pelak  //"۵۴۸ خ ۱۲۷"
        pelakLabel.numberOfLines = 1
        pelakLabel.textAlignment = .left
        pelakLabel.adjustsFontSizeToFitWidth = true
        pelakLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(pelakLabel)
        
        // Motor Image
        motorImage = UIImageView(frame: CGRect(x: 80,y: pelakLabel.frame.origin.y+pelakLabel.frame.size.height, width: screenWidth-160, height: 80))
        motorImage.image = UIImage(named: "arrivedMotorImage")
        motorImage.contentMode = .scaleAspectFit
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            motorImage.frame.size.height = 70
        }else if DeviceType.IS_IPHONE_5{
            motorImage.frame.size.height = 100
        }else if DeviceType.IS_IPHONE_6{
            motorImage.frame.size.height = 140
        }else if DeviceType.IS_IPHONE_6P{
            motorImage.frame.size.height = 160
        }
        scrollView.addSubview(motorImage)
        
        // Arrive Message Label
        arriveMessageLabel = UILabel(frame: CGRect(x: 0,y: motorImage.frame.origin.y+motorImage.frame.size.height+15,width: screenWidth,height: 25))
        arriveMessageLabel.backgroundColor = UIColor.white
        arriveMessageLabel.textColor = topViewBlue
        arriveMessageLabel.font = FONT_NORMAL(15)
        arriveMessageLabel.text = NSLocalizedString("yourPeikArrived", comment: "")
        arriveMessageLabel.numberOfLines = 1
        arriveMessageLabel.textAlignment = .center
        arriveMessageLabel.adjustsFontSizeToFitWidth = true
        arriveMessageLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(arriveMessageLabel)
        
        // Hope Label
        hopeLabel = UILabel(frame: CGRect(x: 50,y: arriveMessageLabel.frame.origin.y+arriveMessageLabel.frame.size.height+10,width: screenWidth-100,height: 60))
        hopeLabel.backgroundColor = UIColor.white
        hopeLabel.textColor = labelGrayColor
        hopeLabel.font = FONT_NORMAL(13)
        hopeLabel.text = NSLocalizedString("hopeMessage", comment: "")
        hopeLabel.numberOfLines = 2
        hopeLabel.textAlignment = .center
        hopeLabel.adjustsFontSizeToFitWidth = true
        hopeLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(hopeLabel)
        
        // wallet Image
        walletImage = UIImageView(frame: CGRect(x: 50,y: hopeLabel.frame.origin.y+hopeLabel.frame.size.height, width: screenWidth-100, height: 80))
        walletImage.image = UIImage(named: "walletImage")
        walletImage.contentMode = .scaleAspectFit
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            walletImage.frame.size.height = 70
        }else if DeviceType.IS_IPHONE_5{
            walletImage.frame.size.height = 100
        }else if DeviceType.IS_IPHONE_6{
            walletImage.frame.size.height = 140
        }else if DeviceType.IS_IPHONE_6P{
            walletImage.frame.size.height = 160
        }
        scrollView.addSubview(walletImage)
        
        // Price Label
        tripCodeLabel = UILabel(frame: CGRect(x: screenWidth/2-100,y: walletImage.frame.origin.y+walletImage.frame.size.height+20,width: 200,height: 25))
        tripCodeLabel.backgroundColor = UIColor.white
        tripCodeLabel.textColor = topViewBlue
        tripCodeLabel.font = FONT_NORMAL(13)
        tripCodeLabel.text = NSLocalizedString("peikPrice", comment: "")
        tripCodeLabel.numberOfLines = 1
        tripCodeLabel.textAlignment = .center
        tripCodeLabel.adjustsFontSizeToFitWidth = true
        tripCodeLabel.minimumScaleFactor = 0.5
        
        scrollView.addSubview(tripCodeLabel)
        
        // Cash Button
        cashButton = UIButton(frame: CGRect(x: 0,y: screenHeight-120,width: screenWidth,height: 60))
        cashButton.backgroundColor = greenColor
        cashButton.titleLabel!.font = FONT_MEDIUM(15)
        cashButton.tintColor = whiteColor
        let price:String? = UserDefaults.standard.object(forKey: "tripPrice") as? String
        
        let priceString = "\(price!)"+NSLocalizedString("rial", comment: "")+"         "+NSLocalizedString("cash", comment: "")
        cashButton.setTitle(priceString,for:UIControlState())
        
        //        if price != nil{
        //            let priceString = price!  + NSLocalizedString("rial", comment: "")
        //            cashButton.setTitle(priceString+"         "+NSLocalizedString("cash", comment: ""), for:UIControlState())
        //        }
        //        else{
        //            getTripInfo()
        //            let priceString = String(describing: tripCost)  + NSLocalizedString("rial", comment: "")
        //            cashButton.setTitle(priceString+"         "+NSLocalizedString("cash", comment: ""), for:UIControlState())
        //        }
        cashButton.addTarget(self, action: #selector(cashButtonAction), for: .touchUpInside)
        self.view.addSubview(cashButton)
        
        // Call Driver Button
        callDriverButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: 60,height: 60))
        callDriverButton.backgroundColor = greenColor
        callDriverButton.titleLabel?.font = FONT_MEDIUM(15)
        //callDriverButton.setTitle(NSLocalizedString("", comment: ""), forState:.Normal)
        callDriverButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.callDriverButtonAction), for: .touchUpInside)
        callDriverButton.setBackgroundImage(UIImage(named: "callImage"), for: UIControlState())
        self.view.addSubview(callDriverButton)
        
        // Message To Driver Button
        messageToDriverButton = UIButton(frame: CGRect(x: 60,y: screenHeight-60,width: screenWidth-60,height: 60))
        messageToDriverButton.backgroundColor = tripIDLabelColor
        messageToDriverButton.titleLabel?.font = FONT_MEDIUM(15)
        messageToDriverButton.setTitle(NSLocalizedString("SMSToDriver", comment: ""), for:UIControlState())
        messageToDriverButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.messageToDriverButtonAction), for: .touchUpInside)
        self.view.addSubview(messageToDriverButton)
        
        /*
         // Add Tap Gesture to Hide Popup
         imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTapGesture))
         driverProfileImageView.addGestureRecognizer(imageTapGesture)
         */
    }
    
    //MARK: -  textField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 13 {
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 95
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 80
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 100
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 100
                self.view.frame = rect
            })
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    //MARK: -  Custom Methods
    
    // Send Message To Driver
    func  sendButtonAction(_ sender:UIButton!){
        let messageTextLength = messageTextField.text?.characters.count
        if messageTextLength! > 0{
            
            sendMessageToDriver()
        }else{
            let alertController = UIAlertController(title: NSLocalizedString("SMSToDriver", comment: ""), message:NSLocalizedString("pleaseFillMessageTextField", comment: ""), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: .default) {
                (action:UIAlertAction!) in
            }
            
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion:nil)
        }
    }
    
    //Push Notification Selector
    //Navigate to Map VC
    func NavigateToMapVC(notification: Notification) {
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        
        let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        
        self.tripCode = data["details"]!["tripcode"] as! Int
        
        tripCodeLabel.text = NSLocalizedString("tripID", comment: "")+"      "+String(tripCode)
        
        self.perform(#selector(PeikArrivedAtOriginViewController.showMapVC), with: nil, afterDelay: 0.7)
        
        //_ = self.navigationController?.popToRootViewController(animated: false)
        
        let notificationName = Notification.Name("showAlert")
        NotificationCenter.default.post(name: notificationName, object: tempDic)
    }
    
    func NavigateToMapOnCancelByDriver(notification: Notification) {
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        
        let notificationName = Notification.Name("showAlert")
        NotificationCenter.default.post(name: notificationName, object: tempDic)
        self.perform(#selector(DriverInfoViewController.showMapVC), with: nil, afterDelay: 0.7)
        
    }
    
    func showMapVC(){
            _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Call Driver Button Action
    func callDriverButtonAction(_ sender: UIButton!) {
        let driverMobileNumber = UserDefaults.standard.object(forKey:"driverMobileNumber")
        let phoneNumber = driverMobileNumber
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber!)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    // Hide Popup
    func handleGesture(_ sender: UITapGestureRecognizer){
        
        if sendpopupView != nil{
            sendpopupView.removeFromSuperview()
        }
        
        if transparentView != nil{
            transparentView.removeFromSuperview()
        }
    }
    
    // Cash Button Action
    func cashButtonAction(_ sender: UIButton!) {
        popupButtonAction()
    }
    
    func popupButtonAction(){
        
        cashTransparentView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        cashTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cashTransparentView.isUserInteractionEnabled = true
        self.view.addSubview(cashTransparentView)
        
        cashPopupView = UIView(frame: CGRect(x: 20,y: screenHeight/2-140,width: screenWidth-40,height: 280))
        cashPopupView.backgroundColor = whiteColor
        cashPopupView.layer.shadowColor = UIColor.gray.cgColor
        cashPopupView.layer.shadowOpacity = 0.5
        cashPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cashPopupView.layer.shadowRadius = 20
        cashPopupView.isUserInteractionEnabled = true
        cashTransparentView.addSubview(cashPopupView)
        
        let  cashLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cashPopupView.frame.size.width , height: 50))
        cashLabel.backgroundColor = DriverInfoOrange
        cashLabel.textColor = whiteColor
        cashLabel.font = FONT_NORMAL(13)
        cashLabel.text = NSLocalizedString("cash", comment: "")
        cashLabel.textAlignment = .center
        cashLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(cashLabel)
        
        let amountToPayLabel = UILabel(frame: CGRect(x: 0, y: cashLabel.frame.origin.x+cashLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        amountToPayLabel.backgroundColor = whiteColor
        amountToPayLabel.textColor = tripIDLabelColor
        amountToPayLabel.font = FONT_NORMAL(13)
        amountToPayLabel.text = NSLocalizedString("amountToPay", comment: "")
        amountToPayLabel.textAlignment = .center
        amountToPayLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(amountToPayLabel)
        
        cashPriceLabel = UILabel(frame: CGRect(x: 0, y: amountToPayLabel.frame.origin.y+amountToPayLabel.frame.size.height, width: cashPopupView.frame.size.width , height: 30))
        cashPriceLabel.backgroundColor = whiteColor
        cashPriceLabel.textColor = topViewBlue
        cashPriceLabel.font = FONT_NORMAL(13)
        let price = UserDefaults.standard.object(forKey: "tripPrice")
        cashPriceLabel.text = (price as! String?)! + NSLocalizedString("rial", comment: "")
        cashPriceLabel.textAlignment = .center
        cashPriceLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(cashPriceLabel)
        
        // popup Current Label
        let currentLabel = UILabel(frame: CGRect(x: 0,y: cashPriceLabel.frame.origin.y+cashPriceLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        currentLabel.backgroundColor = whiteColor
        currentLabel.textColor = grayColor
        currentLabel.font = FONT_NORMAL(13)
        currentLabel.text = NSLocalizedString("currentCredit", comment: "")
        currentLabel.textAlignment = .center
        cashPopupView.addSubview(currentLabel)
        
        // popup Current Credit Label
        currentCreditLabel = UILabel(frame: CGRect(x:0,y: currentLabel.frame.origin.y+currentLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        currentCreditLabel.backgroundColor = whiteColor
        currentCreditLabel.textColor = grayColor
        currentCreditLabel.font = FONT_NORMAL(13)
        //currentCreditLabel.text = "\(currentCredit)" + NSLocalizedString("rial", comment: "")
        currentCreditLabel.textAlignment = .center
        cashPopupView.addSubview(currentCreditLabel)
        getCredit()
        
        // popup Trip Price Will pay from your credit Label
        let tripPriceWillPayLabel = UILabel(frame: CGRect(x:30,y: currentCreditLabel.frame.origin.y+currentCreditLabel.frame.size.height, width: cashPopupView.frame.size.width-60, height: 60))
        tripPriceWillPayLabel.backgroundColor = UIColor.white
        tripPriceWillPayLabel.textColor = topViewBlue
        tripPriceWillPayLabel.font = FONT_NORMAL(13)
        tripPriceWillPayLabel.text = NSLocalizedString("tripPriceWillPayFromYourCredit", comment: "")
        tripPriceWillPayLabel.numberOfLines = 2
        tripPriceWillPayLabel.textAlignment = .center
        tripPriceWillPayLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(tripPriceWillPayLabel)
        
        let addCreditButton = makeButton(frame: CGRect(x: 10,y: tripPriceWillPayLabel.frame.origin.y+tripPriceWillPayLabel.frame.size.height,width: 80,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("addCredit", comment: ""), titleColor: topViewBlue, isRounded: false)
        addCreditButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.addCreditButtonAction), for: .touchUpInside)
        addCreditButton.titleLabel?.font = FONT_MEDIUM(15)
        cashPopupView.addSubview(addCreditButton)
        
        let closeButton = makeButton(frame: CGRect(x: cashPopupView.frame.size.width-90,y: tripPriceWillPayLabel.frame.origin.y+tripPriceWillPayLabel.frame.size.height,width:80,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.closeButtonAction), for: .touchUpInside)
        closeButton.titleLabel?.font = FONT_MEDIUM(15)
        cashPopupView.addSubview(closeButton)
    }
    
    // popup Add Credit Button Action
    func addCreditButtonAction(){
        closeButtonAction()
        addCredit()
    }
    
    // Hide Popup
    func closeButtonAction(){
        cashPopupView.removeFromSuperview()
        cashTransparentView.removeFromSuperview()
    }
    
    // Add Credit Button Action
    func addCredit(){
        
        // Popup Transparent View
        addCreditTransparentView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        addCreditTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addCreditTransparentView.isUserInteractionEnabled = true
        self.view.addSubview(addCreditTransparentView)
        
        // Add Credit Popup View
        addCreditPopupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-200,width: screenWidth-100,height: 350))
        addCreditPopupView.backgroundColor = whiteColor
        addCreditPopupView.layer.cornerRadius = 0
        addCreditPopupView.layer.shadowColor = UIColor.gray.cgColor
        addCreditPopupView.layer.shadowOpacity = 0.5
        addCreditPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        addCreditPopupView.layer.shadowRadius = 20
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            addCreditPopupView.frame.origin.y = 70
        }
        self.view.addSubview(addCreditPopupView)
        
        // popup Add Credit Label
        let addCreditLabel = UILabel(frame: CGRect(x: 0,y: 0, width: addCreditPopupView.frame.size.width, height: 50))
        addCreditLabel.backgroundColor = orangeColor2
        addCreditLabel.textColor = whiteColor
        addCreditLabel.font = FONT_NORMAL(17)
        addCreditLabel.text = NSLocalizedString("addCredit", comment: "")
        addCreditLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditLabel)
        
        // Add Creditpopup Current Label
        let addCreditCurrentLabel = UILabel(frame: CGRect(x: addCreditPopupView.frame.size.width/2,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width/2, height: 50))
        addCreditCurrentLabel.backgroundColor = UIColor.white
        addCreditCurrentLabel.textColor = topViewBlue
        addCreditCurrentLabel.font = FONT_NORMAL(13)
        addCreditCurrentLabel.text = NSLocalizedString("currentCredit", comment: "")
        addCreditCurrentLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditCurrentLabel)
        
        // popup Current Credit Label
        addCreditCurrentCreditLabel = UILabel(frame: CGRect(x:0,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width/2, height: 50))
        addCreditCurrentCreditLabel.backgroundColor = UIColor.white
        addCreditCurrentCreditLabel.textColor = topViewBlue
        addCreditCurrentCreditLabel.font = FONT_NORMAL(13)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let NSPrice:NSNumber = NSNumber(value:currentCredit)
        let Separator = formatter.string(from: NSPrice)
        
        addCreditCurrentCreditLabel.text = "\(Separator!)" + NSLocalizedString("rial", comment: "")
        addCreditCurrentCreditLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditCurrentCreditLabel)
        getCredit()
        
        // addCreditThrough Label
        let  addCreditThroughLabel = UILabel(frame: CGRect(x: addCreditCurrentCreditLabel.frame.origin.x,y: addCreditCurrentCreditLabel.frame.origin.y+addCreditCurrentCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width, height: 50))
        addCreditThroughLabel.backgroundColor = whiteColor
        addCreditThroughLabel.textColor = labelTextColor
        addCreditThroughLabel.font = FONT_NORMAL(15)
        addCreditThroughLabel.text = NSLocalizedString("addCreditThrough", comment: "")
        addCreditThroughLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditThroughLabel)
        lineView = UIView(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+45,width: addCreditThroughLabel.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        // popup online Payment Button
        onlinePaymentButton = makeButton(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+addCreditThroughLabel.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("onlinePayment", comment: ""), titleColor: grayColor, isRounded: false)
        onlinePaymentButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.onlinePaymentButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(onlinePaymentButton)
        
        lineView = UIView(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+45,width: onlinePaymentButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        /*
         // popup USSD Payment Button
         USSDPaymentButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("USSDPayment", comment: ""), titleColor: grayColor, isRounded: false)
         USSDPaymentButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.USSDPaymentButtonAction), for: .touchUpInside)
         addCreditPopupView.addSubview(USSDPaymentButton)
         lineView = UIView(frame: CGRect(x: USSDPaymentButton.frame.origin.x,y: USSDPaymentButton.frame.origin.y+45,width: USSDPaymentButton.frame.size.width,height: 1))
         lineView.backgroundColor = lineViewColor
         addCreditPopupView.addSubview(lineView)
         */
        
        // popup peykyab Button
        peykyabButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("peykyabCard", comment: ""), titleColor: grayColor, isRounded: false)
        peykyabButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.peykYabButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(peykyabButton)
        lineView = UIView(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+45,width: peykyabButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        // popup amount TextField
        amountTextField = UITextField(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+peykyabButton.frame.size.height,width: addCreditPopupView.frame.size.width,height: 50))
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("amountToAdd", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
        amountTextField.backgroundColor = lightBlue
        amountTextField.font = FONT_NORMAL(13)
        amountTextField.textColor = labelGrayColor
        amountTextField.borderStyle = .none
        amountTextField.autocorrectionType = UITextAutocorrectionType.no
        amountTextField.keyboardType = UIKeyboardType.default
        amountTextField.returnKeyType = UIReturnKeyType.done
        amountTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        amountTextField.contentVerticalAlignment = .center
        amountTextField.contentHorizontalAlignment = .center
        amountTextField.textAlignment = .center
        amountTextField.delegate=self
        amountTextField.keyboardType = .numberPad
        amountTextField.tag = 13
        addCreditPopupView.addSubview(amountTextField)
        
        // Popup Pay Button
        payButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x+amountTextField.frame.size.width-50,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("pay", comment: ""), titleColor: topViewBlue, isRounded: false)
        payButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.payButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(payButton)
        
        // popup Close Button
        let closeButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.addCreditCloseButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(closeButton)
    }
    /*
     // USSD PaymentButton Action
     func USSDPaymentButtonAction(){
     onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
     peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
     USSDPaymentButton.setTitleColor(topViewBlue,for: UIControlState())
     amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
     payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
     paymentNumber = 2
     }
     */
    
    // Online Payment Action
    func onlinePaymentButtonAction(){
        // USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("amountToAdd", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
        payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
        paymentNumber = 1
    }
    
    // Peykyab Button Action
    func peykYabButtonAction(){
        //USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterChargeCardCode", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("enterChargeCardCode", comment: "")
        payButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        paymentNumber = 3
    }
    // Pay Button Action
    func payButtonAction(){
        switch paymentNumber
        {
        case 0:
            let alert = UIAlertController(title: NSLocalizedString("addCredit", comment: ""), message:NSLocalizedString("selectAddCreditWay", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break

        case 1:
            shaparak()
            break
            //case 2:
            //USSD()
        //break
        case 3:
            giftCard()
            break
        default:
            print("Nothing")
            break
        }
    }
    
    func addCreditCloseButtonAction(){
        
        addCreditPopupView.removeFromSuperview()
        addCreditTransparentView.removeFromSuperview()
    }
    
    // Show Message to Driver popup
    func messageToDriverButtonAction(_ sender: UIButton!) {
        let messageTemplateNumber = templateMessageArray.count
        print("Number of MessageTemplate:\(messageTemplateNumber)")
        //Have 1 MessageToDriverTemplate in Server
        if messageTemplateNumber == 1{
            let tempDic1:Dictionary = templateMessageArray[0] as Dictionary
            
            templateMessageid1 = tempDic1["id"] as! Int
            templateMessageText1 = tempDic1["Title"] as! String
            
            //Have 2 MessageToDriverTemplate in Server
        }else{
            let tempDic1:Dictionary = templateMessageArray[0] as Dictionary
            let tempDic2:Dictionary = templateMessageArray[1] as Dictionary
            
            templateMessageid1 = tempDic1["id"] as! Int
            templateMessageText1 = tempDic1["Title"] as! String
            
            templateMessageid2 = tempDic2["id"] as! Int
            templateMessageText2 = tempDic2["Title"] as! String
        }
        transparentView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        // Add Tap Gesture to Hide Popup
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        self.transparentView.addGestureRecognizer(tapGesture)
        
        sendpopupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-125,width: screenWidth-100,height: 250))
        sendpopupView.backgroundColor = whiteColor
        sendpopupView.layer.cornerRadius = 0
        sendpopupView.layer.shadowColor = UIColor.gray.cgColor
        sendpopupView.layer.shadowOpacity = 0.5
        sendpopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        sendpopupView.layer.shadowRadius = 20
        self.view.addSubview(sendpopupView)
        
        templateMessageButton1 = makeButton(frame: CGRect(x: 0,y: 0,width: sendpopupView.frame.width,height: 50), backImageName: nil, backColor: orangeColor1, title: templateMessageText1, titleColor: whiteColor, isRounded: false)
        templateMessageButton1.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.templateMessageButtonAction1), for: .touchUpInside)
        sendpopupView.addSubview(templateMessageButton1)
        
        templateMessageButton2 = makeButton(frame: CGRect(x: templateMessageButton1.frame.origin.x,y: templateMessageButton1.frame.origin.y+templateMessageButton1.frame.size.height,width: sendpopupView.frame.width,height: 50), backImageName: nil, backColor: orangeColor2, title: templateMessageText2, titleColor: whiteColor, isRounded: false)
        templateMessageButton2.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.templateMessageButtonAction2), for: .touchUpInside)
        sendpopupView.addSubview(templateMessageButton2)
        
        desiredTextLabel = UILabel(frame: CGRect(x: templateMessageButton2.frame.origin.x,y: templateMessageButton2.frame.origin.y+templateMessageButton2.frame.size.height, width: sendpopupView.frame.size.width, height: 50))
        desiredTextLabel.backgroundColor = lightBlue
        desiredTextLabel.textColor = UIColor.black
        desiredTextLabel.font = FONT_NORMAL(15)
        desiredTextLabel.text = NSLocalizedString("desiredText", comment: "")
        desiredTextLabel.textAlignment = .center
        sendpopupView.addSubview(desiredTextLabel)
        
        messageTextField = UITextField(frame: CGRect(x: desiredTextLabel.frame.origin.x,y: desiredTextLabel.frame.origin.y+desiredTextLabel.frame.size.height,width: sendpopupView.frame.size.width,height: 50))
        messageTextField.attributedPlaceholder = NSAttributedString(string:"",attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //messageTextField.placeholder = ""
        messageTextField.font = FONT_NORMAL(13)
        messageTextField.textColor = labelGrayColor
        messageTextField.borderStyle = .line
        messageTextField.autocorrectionType = UITextAutocorrectionType.no
        messageTextField.keyboardType = UIKeyboardType.default
        messageTextField.returnKeyType = UIReturnKeyType.done
        messageTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        messageTextField.contentVerticalAlignment = .center
        messageTextField.contentHorizontalAlignment = .center
        messageTextField.textAlignment = .center
        messageTextField.delegate=self
        messageTextField.keyboardType = .default
        messageTextField.tag = 13
        sendpopupView.addSubview(messageTextField)
        
        let sendButton = makeButton(frame: CGRect(x: messageTextField.frame.origin.x,y: messageTextField.frame.origin.y+messageTextField.frame.size.height,width: sendpopupView.frame.size.width,height: 50), backImageName: nil, backColor: sendMessageBlue, title: NSLocalizedString("send", comment: ""), titleColor: whiteColor, isRounded: false)
        sendButton.addTarget(self, action: #selector(PeikArrivedAtOriginViewController.sendButtonAction), for: .touchUpInside)
        sendpopupView.addSubview(sendButton)
    }
    
    // templateMessageButtonAction1
    //Set messageTextField.text accoording to templateMessageButton titleLabel and set messageID
    func  templateMessageButtonAction1(_ sender:UIButton!){
        messageTextField.text = sender.titleLabel?.text
        messageID = templateMessageid1
    }
    
    // templateMessageButtonAction2
    //Set messageTextField.text accoording to templateMessageButton titleLabel and set messageID
    func  templateMessageButtonAction2(_ sender:UIButton!){
        messageTextField.text = sender.titleLabel?.text
        messageID = templateMessageid2
    }
    //MARK: -  Connections
    
    // Call getMessageToDriverTemplate Connection
    func getMessageToDriverTemplate(){
        
        // Check Internet Connection
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
        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "page": 1 as AnyObject
            ]
            getMessageToDriverTemplateWithCallBack(apiName: "messagetemplate/getmessagestemplatelist/subscriber_to_driver_message", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        if let tempMessageArray = responseDic["data"] as? NSArray {
                            for tempMessage in tempMessageArray {
                                
                                self.templateMessageArray.append(tempMessage as! [String : AnyObject])
                            }
                            DispatchQueue.main.async {
                                //                                let msg:String = responseDic.object(forKey: "msg") as! String
                                //                                let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                //                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                //                                self.present(alert, animated: true, completion: nil)
                                //                                self.sendpopupView.removeFromSuperview()
                                //                                self.transparentView.removeFromSuperview()
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
    
    // Call sendMessagetoDriver Connection
    func sendMessageToDriver(){
        
        // Check Internet Connection
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
        let tripID:Int = UserDefaults.standard.object(forKey: "tripID") as! Int
        
        if sessionID != nil {
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }

            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "tripid": tripID as AnyObject,
                                                        "messageid": messageID as AnyObject,
                                                        "messagetext": messageTextField.text! as AnyObject,
                                                        ]
            
            sendMessageToDriverWithCallBack(apiName: "trip/sendmessagetodriver", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                print("Params:\(params)")
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async {
                            print("Params:\(params)")
                            let msg:String = responseDic.object(forKey: "msg") as! String
                            let alert = UIAlertController(title: NSLocalizedString("SMSToDriver", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.sendpopupView.removeFromSuperview()
                            self.transparentView.removeFromSuperview()
                        }
                        print("Params:\(params)")
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
    // get Trip Cost Connection
    func getTripCost(){
        
        // Check Internet Connection
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
        let tripID:Int = UserDefaults.standard.object(forKey: "tripID") as! Int
        
        if sessionID != nil {
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "tripid": tripID as AnyObject,
                                                        ]
            
            getTripCostInfoWithCallBack(apiName: "trip/gettripcostinfo", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                print("Params:\(params)")
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        let tripPrice   = responseDic.object(forKey: "tripprice") as! Int
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.groupingSeparator = ","
                        let NSPrice:NSNumber = (tripPrice as NSNumber)
                        let Separator = formatter.string(from: NSPrice)
                        
                        self.tripCost = Separator
                        
                        //self.priceButton.setTitle("\(Separator!)"+NSLocalizedString("rial", comment: ""), for: .normal)
                        
                        
                        //                        DispatchQueue.main.async {
                        //                            print("Params:\(params)")
                        //                            let msg:String = responseDic.object(forKey: "msg") as! String
                        //                            let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        //                            self.present(alert, animated: true, completion: nil)
                        //                            self.sendpopupView.removeFromSuperview()
                        //                            self.transparentView.removeFromSuperview()
                        //                        }
                        print("Params:\(params)")
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
     
     // Get Trip Driver Info Connection
     func getTripDriverInfo(){
     
     // Check Internet Connection
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
     
     let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
     let tripID:Int = UserDefaults.standard.object(forKey: "tripID") as! Int
     
     if sessionID != nil {
     
     let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
     "tripid": tripID as AnyObject,
     ]
     
     getTripDriverInfoWithCallBack(apiName: "trip/gettripdriverinfo", params: params as NSDictionary?){
     (resDic:NSDictionary?, error:NSError?) in
     print("Params:\(params)")
     ARSLineProgress.hideWithCompletionBlock({ () -> Void in
     })
     if let responseDic = resDic{
     if (responseDic.object(forKey: "status") as! Int) == 1{
     
     self.driverName = responseDic.object(forKey: "nicename") as! String
     self.nameLabel.text = self.driverName
     self.pelak = responseDic.object(forKey: "pelak") as! String
     self.pelakLabel.text = self.pelak
     self.driverMobileNumber = responseDic.object(forKey: "mobile") as! String
     
     //                        DispatchQueue.main.async {
     //                            print("Params:\(params)")
     //                            let msg:String = responseDic.object(forKey: "msg") as! String
     //                            let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
     //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
     //                            self.present(alert, animated: true, completion: nil)
     //                            self.sendpopupView.removeFromSuperview()
     //                            self.transparentView.removeFromSuperview()
     //                        }
     print("Params:\(params)")
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
     */
    
    
    // get Trip Info Connection
    func getTripInfo(){
        
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
        let tripID:Int = UserDefaults.standard.object(forKey: "tripID") as! Int
        
        if sessionID != nil {
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "tripid": tripID as AnyObject,
                                                        ]
            
            getTripInfoWithCallBack(apiName: "trip/gettripinfo", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                print("Params:\(params)")
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        let totalPrice:Int = responseDic.object(forKey: "totalprice") as! Int
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.groupingSeparator = ","
                        let IntTotalPrice = Int(totalPrice)
                        let NSPrice:NSNumber = NSNumber(value:IntTotalPrice)
                        let Separator = formatter.string(from: NSPrice)
                        
                        self.tripCost = Separator
                        
                        //                        DispatchQueue.main.async {
                        //                            print("Params:\(params)")
                        //                            let msg:String = responseDic.object(forKey: "msg") as! String
                        //                            let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        //                            self.present(alert, animated: true, completion: nil)
                        //                            self.sendpopupView.removeFromSuperview()
                        //                            self.transparentView.removeFromSuperview()
                        //                        }
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
    
    // get Credit Connection
    func getCredit(){
        
        // Check Internet Connection
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
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        ]
            getCreditWithCallBack(apiName: "billing/getcredit", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    
                    if (resDic?.object(forKey: "status") as! Int) == 1{
                        
                        self.currentCredit = resDic?.object(forKey: "credit") as! Int
                        
                        DispatchQueue.main.async{
                            
                            self.currentCredit = resDic?.object(forKey: "credit") as! Int!
                            
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.groupingSeparator = ","
                            let NSPrice:NSNumber = NSNumber(value:self.currentCredit)
                            let Separator = formatter.string(from: NSPrice)
                            
                            self.currentCreditLabel.text = "\(Separator!)" + NSLocalizedString("rial", comment: "")
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
    
    // Add Credit via Online Payment in Webview Connection
    func shaparak(){
        
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Check Internet Connection
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
        //let chargeamount:Int? = Int(amountTextField.text!)!
        
        //convert persian number to english number
        let NumberStr: String = amountTextField.text!
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        let final = Formatter.number(from: NumberStr)
        if final != 0 {
            print("\(final!)")
        }
        let chargeamount:Int? = Int(final!)
        print (chargeamount!)
        
        if sessionID != nil {
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "paymenttype":paymentNumber as AnyObject,
                                                        "chargeamount":chargeamount! as AnyObject
            ]
            shaparakWithCallBack(apiName: "billing/creditcharge", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async{
                            
                            self.addCreditPopupView.removeFromSuperview()
                            self.addCreditTransparentView.removeFromSuperview()
                            
                            self.webViewURL = responseDic.object(forKey: "url") as! String
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShaparakViewController") as! ShaparakViewController
                            nextViewController.webViewURL = self.webViewURL
                            self.present(nextViewController, animated:true, completion:nil)
                            
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
    
    // Add Credit  via peikyab Charge Card Connection
    func giftCard(){
        
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Check Internet Connection
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
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "chargecardcode":amountTextField.text! as AnyObject
            ]
            setChargeCardWithCallBack(apiName: "billing/setchargecard", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        self.addCreditPopupView.removeFromSuperview()
                        
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
}
