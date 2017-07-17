//
//  SupportFinalViewController.swift
//  NewPeikyab
//
//  Created by Developer on 9/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class SupportFinalViewController:BaseViewController,UIScrollViewDelegate,UITextViewDelegate{
    
    //MARK: - Variables
    var scrollView :UIScrollView!
    var supportFinalImage : UIImageView!
    var titleLabel : UILabel!
    var descriptionLabel: UILabel!
    var serviceLabel:UILabel!
    var messageTextView:UITextView!
    var sendButton:UIButton!
    var subjectStr:String!
    var issueID: Double!
    var tripsTripID:Int!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        //Scroll View
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+50)
        self.view.addSubview(scrollView)
        
        self.view.isUserInteractionEnabled = true
        
        makeTopbar(NSLocalizedString("peykyabSupport", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        //Support Final Image
        supportFinalImage = UIImageView(frame: CGRect(x: 0,y: 5, width: screenWidth, height: screenHeight/6))
        supportFinalImage.image = UIImage(named: "finalSupport.png")
        supportFinalImage.contentMode = .scaleAspectFit
        scrollView.addSubview(supportFinalImage)
        
        //TitleLabel
        titleLabel = UILabel(frame: CGRect(x: 20,y: supportFinalImage.frame.origin.y+supportFinalImage.frame.size.height,width: screenWidth-40,height: 50))
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textColor = topViewBlue
        titleLabel.font = FONT_NORMAL(15)
        titleLabel.text = subjectStr
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .right
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(titleLabel)
        
        //descriptionLabel
        descriptionLabel = UILabel(frame: CGRect(x: 20,y: titleLabel.frame.origin.y+titleLabel.frame.size.height,width: screenWidth-40,height: 50))
        descriptionLabel.backgroundColor = UIColor.white
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = FONT_NORMAL(13)
        descriptionLabel.text = NSLocalizedString("finalSupportDescription", comment: "")
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .right
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(descriptionLabel)
        
        //Service Label
        serviceLabel = UILabel(frame: CGRect(x: 20,y: descriptionLabel.frame.origin.y+descriptionLabel.frame.size.height,width: screenWidth-40,height: 40))
        serviceLabel.backgroundColor = UIColor.white
        serviceLabel.textColor = labelGrayColor
        serviceLabel.font = FONT_NORMAL(13)
        serviceLabel.text = NSLocalizedString("finalSupportService", comment: "")
        serviceLabel.numberOfLines = 2
        serviceLabel.textAlignment = .right
        serviceLabel.adjustsFontSizeToFitWidth = true
        serviceLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(serviceLabel)
        
        //Message TextView
        messageTextView = UITextView(frame: CGRect(x: 20,y: serviceLabel.frame.origin.y+serviceLabel.frame.size.height+10, width: screenWidth-40, height: 100))
        messageTextView.textAlignment = .right
        messageTextView.textColor = UIColor.black
        messageTextView.layer.borderColor = textViewBorderColor.cgColor
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.cornerRadius = 5
        messageTextView.delegate = self
        messageTextView.autocorrectionType = .no
        messageTextView.resignFirstResponder()
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            messageTextView.frame.size.height = 110
        }else if DeviceType.IS_IPHONE_5{
            messageTextView.frame.size.height = 180
        }else if DeviceType.IS_IPHONE_6{
            messageTextView.frame.size.height = 260
        }else if DeviceType.IS_IPHONE_6P{
            messageTextView.frame.size.height = 310
        }
        
        scrollView.addSubview(messageTextView)
        
        //Send Button
        sendButton = UIButton(frame: CGRect(x: screenWidth/2-50,y: messageTextView.frame.origin.y+messageTextView.frame.size.height+10,width: 100,height: 30))
        sendButton.backgroundColor = buttonColor1
        sendButton.titleLabel?.font = FONT_MEDIUM(15)
        sendButton.setTitle(NSLocalizedString("send", comment: ""), for:UIControlState())
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        scrollView.addSubview(sendButton)
    }
    
    //MARK: -  TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            scrollView.setContentOffset(CGPoint(x: 1,y: 200), animated: true)
            
        }else if DeviceType.IS_IPHONE_5{
            
            scrollView.setContentOffset(CGPoint(x: 1,y: 100), animated: true)
            
        }else if DeviceType.IS_IPHONE_6{
            //OK
        }
        else if DeviceType.IS_IPHONE_6P{
            //OK
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    //MARK: -  Custom Methods
    
    //Back to Previous VC
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -  Connections
    
    //Support Send Issue Connection
    func sendButtonAction(){
        
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
                 "issueid": issueID as AnyObject,
                 "subject": titleLabel.text! as AnyObject,
                 "description": messageTextView.text! as AnyObject
            ]
            print("Params:\(params)")
            
            //if tripsTripID != 0{
            //  print ("tripsTripID = \(tripsTripID!)")
            // }
            
            supportSendIssueWithCallBack(apiName: "support/sendissue", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        _ = self.navigationController?.popToRootViewController(animated: false)
                        
                        let msg:String = responseDic.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("peykyabSupport", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
//                        let msg:String = responseDic.object(forKey: "msg") as! String
//                        let alert = UIAlertController(title: NSLocalizedString("peykyabSupport", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
                        
                    }else/*status>1*/{
                        //Session Expired
                        if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                            
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                nextViewController.showBackButton = false
                                self.present(nextViewController, animated: true, completion: nil)
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
