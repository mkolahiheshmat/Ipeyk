//
//  MenuViewController.swift
//  NewPeikyab
//
//  Created by Developer on 9/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: - Variables
    var menuImage :UIImageView!
    var tableView : UITableView!
    var btnCloseMenuOverlay : UIButton!
    var tableArray = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    let cellReuseIdendifier = "cellMenu"
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        
        let numbers = [1, 2, 3]
        let doubledNumbers = numbers.map {$0 * 2}.filter {$0 > 2}
        let doubledNumbers2 = numbers.map {$0 * $0}.filter {$0 % 2 == 0}
        let total = numbers.reduce(0,+)
        print(doubledNumbers, doubledNumbers2, total)
        makeTopbar(NSLocalizedString("menu", comment: ""))
        
        menuImage = UIImageView(frame: CGRect(x: 20,y: 64,width: screenWidth-20,height: screenHeight/5))
        menuImage.image = UIImage(named: "menuImage.png")
        menuImage.contentMode = .scaleAspectFit
        self.view.addSubview(menuImage)
        
        tableView = UITableView(frame: CGRect(x: 0,y: menuImage.frame.origin.y+menuImage.frame.size.height+10,width: screenWidth,height: screenHeight-(menuImage.frame.origin.y+menuImage.frame.size.height)))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        updatetableArray()
        self.view.addSubview(tableView)
        
        tableView.register(MenuCustomCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        backButton.isHidden = true
        
        var frame = menuButton.frame
        frame .origin.y = 28
        menuButton.frame = frame
        let img = UIImage(named: "menu_back.png")
        menuButton.setBackgroundImage(img , for: UIControlState())
        menuButton.addTarget(self, action: #selector(MenuViewController.menuButtonAction), for: .touchUpInside)
    }
    //MARK: -  tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = MenuCustomCell(style: .default, reuseIdentifier: "cell")
        cell.menuLabel.text = tableArray[(indexPath as NSIndexPath).row]["title"]!
        //cell.menuImage.image = UIImage(named:tableArray[indexPath.row]["icon"]!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 140.0/255, green: 189.0/255, blue: 250.0/255, alpha: 1.0)
        tableView.deselectRow(at: indexPath, animated: true)
        slideMenuItemSelectedAtIndex((indexPath as NSIndexPath).row)
    }
    //MARK: -  custom methods
    
    func updatetableArray(){
        tableArray.append(["icon":"","title":NSLocalizedString("turnover", comment: "") ])
        tableArray.append(["icon":"","title":NSLocalizedString("trips", comment: "")   ])
        tableArray.append(["icon":"","title":NSLocalizedString("editInfo", comment: "")   ])
        tableArray.append(["icon":"","title":NSLocalizedString("selectedAddress", comment: "")   ])
        tableArray.append(["icon":"","title":NSLocalizedString("messages", comment: "")   ])
        tableArray.append(["icon":"","title":NSLocalizedString("support", comment: "")   ])
        tableArray.append(["icon":"","title":NSLocalizedString("setting", comment: "")  ])
        tableArray.append(["icon":"","title":NSLocalizedString("aboutPeykYab", comment: "")  ])
        tableArray.append(["icon":"","title":NSLocalizedString("exit", comment: "")  ])
//        tableArray.append(["icon":"","title":"IntroView" ])
//        tableArray.append(["icon":"","title":"RequestService" ])
//        tableArray.append(["icon":"","title":"ReceiverInfo" ])
//        tableArray.append(["icon":"","title":"DriverInfo" ])
//        tableArray.append(["icon":"","title":"Peik arrived at origin" ])
//        tableArray.append(["icon":"","title":"Rating" ])
        tableView.reloadData()
    }
    func menuButtonAction() {
        //self.dismissViewControllerAnimated(true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        let turnover = 0 , trips=1,editInfo=2,selectedAddress=3,messages=4,support=5,setting = 6,aboutPeykYab=7,exit=8
        //,intro=9,requestService=10,receiverInfo=11,driverInfo=12,peikarrivedatorigin=13,rating=14
        switch(index){
        case turnover:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TurnoverViewController") as! TurnoverViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case trips:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TripsViewController") as! TripsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case editInfo:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditInfoViewController") as! EditInfoViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case selectedAddress:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectedAddressViewController") as! SelectedAddressViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case messages:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case support:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case setting:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case aboutPeykYab:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AboutPeykYabViewController") as! AboutPeykYabViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
            
            //MARK: -  Connections
            
            //MARK: Logout
        
        //Logout Connection
        case exit:
            
            let alertController = UIAlertController(title: NSLocalizedString("exit", comment: ""), message:NSLocalizedString("exitMessage", comment: ""), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) {
                (action:UIAlertAction!) in
                
                let userName = UserDefaults.standard.object(forKey: "userName")
                let sessionID = UserDefaults.standard.object(forKey: "sessionID")
                
                let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject,
                                                            "username":userName! as AnyObject
                                                           ]
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
                
                logoutWithCallBack(apiName: "logout", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
                    
                    ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                    
                    if let responseDic = resDic{
                        if (responseDic.object(forKey: "status") as! Int) == 1{
                            
                            //clean login data
                            //UserDefaults.standard.set(false, forKey: "firstlaunch1.0")
                            //UserDefaults.standard.set("",forKey:"sessionID")
                            UserDefaults.standard.removeObject(forKey:"sessionID")
                            UserDefaults.standard.removeObject(forKey:"userName")
                            UserDefaults.standard.removeObject(forKey:"firstlaunch1.0")
                            UserDefaults.standard.removeObject(forKey:"FirstLaunchFlag")
                            UserDefaults.standard.removeObject(forKey:"originLatitude")
                            UserDefaults.standard.removeObject(forKey:"originLongitude")
                            UserDefaults.standard.removeObject(forKey:"tripPrice")
                            UserDefaults.standard.removeObject(forKey:"tripID")
                            UserDefaults.standard.set(0,forKey:"originSelected")
                            UserDefaults.standard.removeObject(forKey:"mobileNumber")
                            UserDefaults.standard.removeObject(forKey:"driverName")
                            UserDefaults.standard.removeObject(forKey:"driverPelak")
                            UserDefaults.standard.removeObject(forKey:"driverMobileNumber")
                            UserDefaults.standard.removeObject(forKey:"driverImageURL")
                            
                            //show alert
                            DispatchQueue.main.async {
                                
                               // let cancelButtonNotification = Notification.Name("cancelButton")
                               // NotificationCenter.default.post(name: cancelButtonNotification, object: nil)
                                
                              //  let backButtonNotification = Notification.Name("backButton")
                              //  NotificationCenter.default.post(name: backButtonNotification, object: nil)
                                
                                _ = self.navigationController?.popViewController(animated: false)
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                                self.present(nextViewController, animated: true, completion: nil)
                                /*
                                let msg:String = responseDic.object(forKey: "msg") as! String
                                let alert = UIAlertController(title: NSLocalizedString("exit", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                 */
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
            let cancelAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .cancel)
            { (action:UIAlertAction!) in}
            
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion:nil)
            break
            /*

        case rating:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break

                    case intro:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case requestService:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RequestServiceViewController") as! RequestServiceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
            
        case receiverInfo:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ReceiverInfoViewController") as! ReceiverInfoViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case driverInfo:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case peikarrivedatorigin:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PeikArrivedAtOriginViewController") as! PeikArrivedAtOriginViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
         */
            
        default:
            print("default\n")
        }
    }
}
