//
//  RatingViewController.swift
//  PeikYab
//
//  Created by Developer on 9/18/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class RatingViewController:BaseViewController,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: - Variables
    var scrollView:UIScrollView!
    var returnButton:UIButton!
    var sharingButton:UIButton!
    var ratingImageView:UIImageView!
    var messageLabel:UILabel!
    var driverProfileImageView:UIImageView!
    var driverImageURL:String!
    var driverNameLabel:UILabel!
    var ideaTextField:UITextField!
    var ratingButton:UIButton!
    var ratingControl: RatingControl!
    var rating:Int = 0 //Pass from Rating ViewController
    var tableView:UITableView!
    let cellReuseIdendifier = "cellDetailRating"
    var tableArray = [Rating]()
    var messageTableArray = [[String:AnyObject]]()
    var selectedOptionsArray = NSMutableArray()
    var isTableViewShowing = false
    var driverName:String = ""
    var messageIdsArray = NSMutableArray()
    var tripID:Int!
    var messageID:Int!
    var messageIndex:Int!
    var IsCallFromTripsVC:Bool! = false
    var tripsTripID:Int!
    
    //var MessageIDSet = Set<Int>()
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool) {
        //getTripDriverInfo()
        // getUnsatisfiedMessagelist()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationName = Notification.Name("ratingControlDidChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(ratingControlDidChanged(notification:)), name: notificationName, object: nil)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //ImageView
        
        ratingImageView = UIImageView(frame: CGRect(x: 0,y: 0, width: screenWidth, height: 150))
        ratingImageView.contentMode = .scaleAspectFit
        ratingImageView.image = UIImage(named: "ratingImage")
        ratingImageView.isUserInteractionEnabled = true
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            ratingImageView.frame.size.height = screenHeight/7
            
        }else if DeviceType.IS_IPHONE_5{
            
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
            ratingImageView.frame.size.height = screenHeight/4
            
        }else if DeviceType.IS_IPHONE_6{
            
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
            ratingImageView.frame.size.height = screenHeight/2.7
            
        }else if DeviceType.IS_IPHONE_6P{
            
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
            ratingImageView.frame.size.height = screenHeight/2.5
            
        }
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(ratingImageView)
        
        backButton = UIButton(frame: CGRect(x: 10,y: 5,width: 40,height: 40))
        let backimg = UIImage(named:"ratingBack")
        backButton.setBackgroundImage(backimg, for: UIControlState())
        backButton.addTarget(self, action: #selector(RatingViewController.backAction), for: .touchUpInside)
        ratingImageView.addSubview(backButton)
        
        messageLabel = UILabel(frame: CGRect(x: 70,y: ratingImageView.frame.origin.y+ratingImageView.frame.size.height+30,width: screenWidth-140,height: 60))
        messageLabel.backgroundColor = UIColor.white
        messageLabel.textColor = grayColor
        messageLabel.font = FONT_BOLD(13)
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.text = NSLocalizedString("iHopeToSatisfiedFromPeykyabService", comment: "")
        scrollView.addSubview(messageLabel)
        
        driverProfileImageView = UIImageView(frame: CGRect(x: screenWidth/2-25,y: messageLabel.frame.origin.y+messageLabel.frame.size.height+20,width: 50, height: 50))
        driverImageURL = UserDefaults.standard.object(forKey: "driverImageURL") as? String
        if driverImageURL != nil{
            self.driverProfileImageView.imageFromServerURL(urlString: driverImageURL)
            
        }else{
            driverProfileImageView.image = UIImage(named: "driverProfileImage")
        }
        //driverProfileImageView.image = UIImage(named: "driverProfileImage")
        driverProfileImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(driverProfileImageView)
        
        driverNameLabel = UILabel(frame: CGRect(x: 0,y: driverProfileImageView.frame.origin.y+driverProfileImageView.frame.size.height+20,width: screenWidth,height: 25))
        driverNameLabel.backgroundColor = UIColor.white
        driverNameLabel.textColor = topViewBlue
        driverNameLabel.font = FONT_NORMAL(15)
        
        let driverName:String? = UserDefaults.standard.object(forKey: "driverName") as? String
        driverNameLabel.text = driverName  //NSLocalizedString("Nima", comment: "")
        
        driverNameLabel.numberOfLines = 1
        driverNameLabel.textAlignment = .center
        driverNameLabel.adjustsFontSizeToFitWidth = true
        driverNameLabel.minimumScaleFactor = 0.5
        scrollView.addSubview(driverNameLabel)
        
        ratingControl = RatingControl(frame: CGRect(x: 20,y: driverNameLabel.frame.origin.y+driverNameLabel.frame.size.height,width: screenWidth-40,height: 50))
        ratingControl.rating = 0
        scrollView.addSubview(ratingControl)
        
        //idea TextField
        ideaTextField = UITextField(frame: CGRect(x: 5,y: screenHeight-120, width: screenWidth-10, height: 60))
        ideaTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("sendIdea", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //ideaTextField.placeholder = NSLocalizedString("sendIdea", comment: "")
        ideaTextField.delegate = self
        ideaTextField.tag = 15
        ideaTextField.layer.borderWidth = 1.0
        ideaTextField.layer.borderColor = UIColor.gray.cgColor
        ideaTextField.backgroundColor = UIColor.white
        ideaTextField.clipsToBounds = true
        ideaTextField.textAlignment = .right
        ideaTextField.font = FONT_MEDIUM(12)
        ideaTextField.autocorrectionType = .no
        self.view.addSubview(ideaTextField)
        
        ratingButton = makeButton(frame: CGRect(x: 0, y: screenHeight-60, width: screenWidth, height: 60), backImageName: nil, backColor: buttonColor2, title: NSLocalizedString("registerRating", comment: ""), titleColor: whiteColor, isRounded: false)
        ratingButton.addTarget(self, action: #selector(RatingViewController.ratingButtonAction), for: .touchUpInside)
        self.view.addSubview(ratingButton)
        
        if self.IsCallFromTripsVC == false {
            tripID = UserDefaults.standard.object(forKey: "tripID") as! Int
            backButton.isHidden = true
        }else if self.IsCallFromTripsVC == true{
            tripID = tripsTripID as Int
            backButton.isHidden = false
        }
    }
    //MARK: -  Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 180
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_5{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 155
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 155
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6P{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 165
                self.view.frame = rect
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: -  tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("messageTableArray.count:\(messageTableArray.count)")
        return messageTableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = RatingCustomCell(style: .default, reuseIdentifier: "RatingCell")
        let tempDic = tableArray[(indexPath as NSIndexPath).row]
        let tempDic2:Dictionary = messageTableArray[indexPath.row] as Dictionary
        
        let circleImage:String = tempDic.circle
        cell.circleImage.image = UIImage(named: circleImage)
        
        //let ratingLabel:String = tempDic.title
        cell.ratingLabel.text = tempDic2["Title"] as? String
        messageID = (tempDic2["id"] as? Int)!
        
        //        if !messageIdsArray.contains(String(messageID)){
        //
        //            messageIdsArray.add(messageID)//.append(String(messageID))
        //        }
        
        let nameOfAvatar:String = tempDic.avatar
        cell.avataImage.image = UIImage(named:nameOfAvatar)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 140.0/255, green: 189.0/255, blue: 250.0/255, alpha: 1.0)
        var indexOfElement = 10000
        for index in 0..<selectedOptionsArray.count{
            let tempNumber:Int? = selectedOptionsArray.object(at: index) as? Int
            if tempNumber == (indexPath as NSIndexPath).row
            {   indexOfElement = index
                break;
            }
        }
        if indexOfElement == 10000/*element not found*/ {
            self.selectedOptionsArray.add((indexPath as NSIndexPath).row)
            let tempDic = tableArray[(indexPath as NSIndexPath).row]
            tempDic.circle = "ratingDetailOn"
            let cell = tableView.cellForRow(at: indexPath) as! RatingCustomCell
            cell.circleImage.image = UIImage(named:tempDic.circle)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            /*
             //add Message ID to Message ID Set
             MessageIDSet.insert(messageID)
             print("MessageIDSet:\(MessageIDSet)")
             */
            
            //Add message ID to Message IDs Array if not added in Before
            if !messageIdsArray.contains(String(messageID)){
                messageIdsArray.add(String(messageID))
            }
            
            print ("Message IDs Array:\(String(describing: messageIdsArray))")
            print ("Message IDs Array Count:\(messageIdsArray.count)")
            //print("Message Array:\(messageIdsArray)")
            
        }else/*element founded*/{
            tableArray[(indexPath as NSIndexPath).row].circle = "ratingDetailOff"
            selectedOptionsArray.removeObject(at: indexOfElement)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            /*
             //Remove Message Id From Message ID Set
             MessageIDSet.remove(messageID)
             print("MessageIDSet:\(MessageIDSet)")
             */
            
            //Find and remove messageID from message IDs Array
            for index in 0..<messageIdsArray.count{
                
                let tempNumber = Int(messageIdsArray[index] as! String)
                
                //print("object:\(messageIdsArray[index])")
                //print("MessageIDs Array Count :\(messageIdsArray.count)")
                //print ("tempNumber:\(tempNumber!)")
                //print("messageID:\(messageID!)")
                
                if tempNumber! == messageID!
                {
                    //print("indexOfMessageID:\(indexOfMessageID)")
                    messageIndex = index
                    
                    break;
                }
            }
            messageIdsArray.removeObject(at: messageIndex)
            
            print ("Removed Message IDs Array:\(messageIdsArray)")
            print ("Removed Message IDs Array Count:\(messageIdsArray.count)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -  Custom Methods
    
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Save Rating Button Action
    func ratingButtonAction(_ sender: UIButton!) {
        print("ratingButton tapped with \(ratingControl.rating)")
        
        if  isTableViewShowing == false {
            setTripRate()
        }else if messageIdsArray.count == 0{
            let alertController = UIAlertController(title: NSLocalizedString("setRating", comment: ""), message:NSLocalizedString("pleaseSelectItems", comment: ""), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: .default) {
                (action:UIAlertAction!) in
            }
            
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion:nil)
        }else{
            setTripRate()
        }

        /*
         //Navigate to Map VC(ViewController)
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
         self.navigationController?.pushViewController(nextViewController, animated: true)
         */
    }
    
    func ratingControlDidChanged(notification: Notification) -> Void {
        let newRating:Int = notification.object! as! Int
        
        //if rate < 5 then show tableview
        if newRating < 5 && isTableViewShowing == false{
            self.makeRatingTableView()
        }else{
            //Send rating to server
        }
        
        //if rate = 5 then hide tableview
        if newRating == 5 &&  isTableViewShowing == true{
            self.hideRatingTableView()
            messageTableArray.removeAll()
            tableView.reloadData()
        }
    }
    
    func hideRatingTableView(){
        if IsCallFromTripsVC == true{
          backButton.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.ratingControl.frame
            //CGRect(x: 20,y: driverNameLabel.frame.origin.y+driverNameLabel.frame.size.height,width: screenWidth-40,height: 50)
            rect.origin.x = 20
            rect.origin.y = self.driverNameLabel.frame.origin.y + self.driverNameLabel.frame.size.height
            self.ratingControl.frame = rect
            
            self.ratingImageView.isHidden = false
            self.ratingImageView.image = UIImage(named: "ratingImage")
        })
        isTableViewShowing = false
        self.tableView.removeFromSuperview()
    }
    
    func makeRatingTableView(){
        if IsCallFromTripsVC == true{
          backButton.isHidden = true
        }
        updatetableArray()
        getUnsatisfiedMessagelist()
        //ratingImageView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.ratingControl.frame
            rect.origin.x = 30
            rect.origin.y = 20
            self.ratingControl.frame = rect
            
            self.tableView = UITableView(frame: CGRect(x: 0,y: self.ratingControl.frame.origin.y+self.ratingControl.frame.size.height+20,width: screenWidth,height: screenHeight-120))//(5+50+60+60)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.allowsSelection = true
            self.tableView.showsVerticalScrollIndicator = false
            self.tableView.showsHorizontalScrollIndicator = false
            self.tableView.separatorColor = UIColor.clear
            self.tableView.register(RatingCustomCell.self, forCellReuseIdentifier: self.cellReuseIdendifier)
            self.scrollView.addSubview(self.tableView)
            self.isTableViewShowing = true
            
            //self.ratingImageView.isHidden = true
            self.ratingImageView.image = UIImage(named: "white")
        })
    }
    //Update Table Array
    func updatetableArray(){
        let item1 = Rating()
        item1.circle = "ratingDetailOff"
        //item1.title = NSLocalizedString("noSecurity", comment: "")
        item1.avatar = "avatar1"
        let item2 = Rating()
        item2.circle = "ratingDetailOff"
        //item2.title = NSLocalizedString("badBehavior", comment: "")
        item2.avatar = "avatar2"
        let item3 = Rating()
        item3.circle = "ratingDetailOff"
        //item3.title = NSLocalizedString("delay", comment: "")
        item3.avatar = "avatar3"
        let item4 = Rating()
        item4.circle = "ratingDetailOff"
        //item4.title = NSLocalizedString("moreMoney", comment: "")
        item4.avatar = "avatar4"
        tableArray = [item1,item2,item3,item4]
    }
    
    //MARK: -  Connections
    
    //get Unsatisfied Message List Connection
    func getUnsatisfiedMessagelist(){
        
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
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        ]
            getUnsatisfiedMessagelistWithCallBack(apiName: "messagetemplate/getmessagestemplatelist/unsatisfiedlist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    print ("Response:\(resDic)")
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        if let messageArray = responseDic["data"] as? NSArray {
                            for message in messageArray {
                                //self.messageTableArray = [[String:AnyObject]]()
                                self.messageTableArray.append(message as! [String : AnyObject])
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
    
    /*
     
     //get Trip Driver Info Connection
     func getTripDriverInfo(){
     
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
     
     let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
     
     if self.IsCallFromTripsVC == false{
     tripID = UserDefaults.standard.object(forKey: "tripID") as! Int
     }
     
     if sessionID != nil {
     
     let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
     "tripid": tripID as AnyObject,
     ]
     
     print("Params:\(params)")
     
     getTripDriverInfoWithCallBack(apiName: "trip/gettripdriverinfo", params: params as NSDictionary?){
     (resDic:NSDictionary?, error:NSError?) in
     print("Params:\(params)")
     
     ARSLineProgress.hideWithCompletionBlock({ () -> Void in
     })
     if let responseDic = resDic{
     if (responseDic.object(forKey: "status") as! Int) == 1{
     
     self.driverName = responseDic.object(forKey: "nicename") as! String
     
     print("DriverName:\(responseDic.object(forKey: "nicename") as! String)")
     
     DispatchQueue.main.async {
     print("Params:\(params)")
     let msg:String = responseDic.object(forKey: "msg") as! String
     let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
     alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
     self.present(alert, animated: true, completion: nil)
     //self.sendpopupView.removeFromSuperview()
     // self.transparentView.removeFromSuperview()
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
     */
    
    //Set Trip Rate Connection
    func setTripRate(){
        
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
        
        var tempString:String = ""
        for i in 0 ..< messageIdsArray.count{
            tempString.append(String(describing: messageIdsArray[i]))
            
            if i != messageIdsArray.count - 1{
                tempString.append(",")
            }
        }
        print(tempString)
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject,
                                                    "tripid":tripID as AnyObject ,
                                                    "messageids":tempString as AnyObject,// Change if use Set instead of NSMutableArray
            "messagetext":ideaTextField.text! as AnyObject,
            "rate":ratingControl.rating as AnyObject
        ]
        print("params:\(params)")
        
        setTripRateWithCallBack(apiName: "trip/settriprate", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    DispatchQueue.main.async {
                        
                        //Navigate to Map VC(ViewController)
                        //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        //             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        //            self.navigationController?.pushViewController(nextViewController, animated: true)
                        
                        // UserDefaults.standard.set(false,forKey:"navigateRatingToMap")
                        //  print("navigateRatingToMap:\(UserDefaults.standard.object(forKey: "navigateRatingToMap"))")
                        _ = self.navigationController?.popToRootViewController(animated: false)
                        
                        let msg:String = responseDic.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("setRating", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))

//                        let alert = UIAlertController(title: NSLocalizedString("setRating", comment: ""), message: NSLocalizedString("saveProfile", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        //Navigate to Map VC(ViewController)
                        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        // let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        
                    }
                    
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
