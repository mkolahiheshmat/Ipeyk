//
//  supportViewController.swift
//  PeikYab
//
//  Created by nooran on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class SupportViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: - Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "cellSupport"
    var tableArray = [[String:AnyObject]]()
    var appConfigTableArray = [[String:AnyObject]]()
    var callButton : UIButton!
    var tripsTripID :Int!
    
    var supportEmailsString:String!
    var supportEmail1:String!
    var supportEmail2:String!
    var supportPhoneNumbersString:String!
    var supportPhoneNumber1:String!
    var supportPhoneNumber2:String!
    var activationStatus:Int!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSupportIssueList()
        getAppConfig()
        
        makeTopbar(NSLocalizedString("peykyabSupport", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        self.view.isUserInteractionEnabled = true
        
        //Table View
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 124))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        self.view.addSubview(tableView)
        
        //Call Support Button
        callButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        callButton.backgroundColor = callOrangeColor
        callButton.titleLabel?.font = FONT_MEDIUM(15)
        callButton.setTitle(NSLocalizedString("callSupport", comment: ""), for:UIControlState())
        callButton.addTarget(self, action: #selector(callButtonAction), for: .touchUpInside)
        self.view.addSubview(callButton)
    }
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SupportCustomCell(style: .default, reuseIdentifier: "supportCell")
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        cell.supportOptionLabel.text =  tempDic["Subject"] as! String?
        
        let tempArray:[[String:AnyObject]]? = tempDic["data"] as? [[String:AnyObject]]
        
        if tempArray == nil{
            cell.moreImageView.isHidden = true
        }else{
            //print(tempArray)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        //        selectedCell.contentView.backgroundColor = UIColor(red: 140.0/255, green: 189.0/255, blue: 250.0/255, alpha: 1.0)
        
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        let tempArray:[[String:AnyObject]]? = tempDic["data"] as? [[String:AnyObject]]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if tempArray == nil{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportFinalViewController") as! SupportFinalViewController
            nextViewController.issueID = tempDic["Id"] as! Double
            nextViewController.subjectStr = tempDic["Subject"] as! String
            nextViewController.tripsTripID = self.tripsTripID
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportViewController2") as! SupportViewController2
            nextViewController.tableArray = tempArray!
            nextViewController.tripsTripID = self.tripsTripID
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    //MARK: - Custom Methods
    
    //Back to Previous VC
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Call Support
    func callButtonAction(){
        
        print (supportPhoneNumber1)
        print (supportPhoneNumber2)
        print(supportEmail1)
        print (supportEmail2)
        
        supportPhoneNumber1 = "00"+supportPhoneNumber1
        supportPhoneNumber2 = "00"+supportPhoneNumber2
        
        print("SupportPhone=\(supportPhoneNumber1!)")
        //print("supportPhon=\(supportPhoneNumber2!)")
        
        let phoneNumber = supportPhoneNumber1!
        print("PhoneNumber=\(phoneNumber)")
    
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    //MARK: -  Connections
    
    //Get Support issue List Connection
    func getSupportIssueList(){
        
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
            
            let type:Int = 0
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "type": type as AnyObject
            ]
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            getSupportIssueListWithCallBack(apiName: "support/getsupportissuelist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        if let issueArray = responseDic["data"] as? NSArray {
                            for issue in issueArray {
                                self.tableArray.append(issue as! [String : AnyObject])
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
    
    func getAppConfig(){
        
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
        
        getAppConfigWithCallBack(apiName: "getappconfig", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    if let array = responseDic["data"] as? [[String:AnyObject]] {
                        
                        for item in array {
                            
                            let keyString:String = item["key"] as! String
                            // let value:Int? = item["value"] as! Int
                            
                            let value:String = item["value"] as! String
                            
                            switch keyString{
                            case "activationStatus":
                                self.activationStatus = Int(value)
                                break
                            case "SubscriberSupportEmails":
                                self.supportEmailsString = value
                                let supportEmailArray : [String] = self.supportEmailsString.components(separatedBy: ",")
                                self.supportEmail1 = supportEmailArray[0]
                                self.supportEmail2 = supportEmailArray[1]
                                break
                            case "SubscriberSupportNumbers":
                                self.supportPhoneNumbersString = value
                                let supportPhoneNumberArray : [String] = self.supportPhoneNumbersString.components(separatedBy: ",")
                                self.supportPhoneNumber1 = supportPhoneNumberArray[0]
                                self.supportPhoneNumber2 = supportPhoneNumberArray[1]
                                break
                            default:
                                break
                                
                            }//Switch
                        }// For
                        //update UI
                        DispatchQueue.main.async {
                           
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
}

