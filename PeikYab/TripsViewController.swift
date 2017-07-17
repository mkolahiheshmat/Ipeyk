//
//  TripsViewController.swift
//  NewPeikyab
//
//  Created by Developer on 9/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class TripsViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //MARK: - Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "cellTrip"
    var tableArray = [[String:AnyObject]]()
    var cellPopupView:UIView!
    var copyTripIDButton:UIButton!
    var supportButton:UIButton!
    var ratingButton:UIButton!
    var closeButton:UIButton!
    var tapGesture:UITapGestureRecognizer!
    var tripID:Int!
    var pageNumber:Int = 1
    var transparentView:UIView!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTripList()
        
        makeTopbar(NSLocalizedString("trips", comment: ""))
        backButton.addTarget(self, action: #selector(TripsViewController.backAction), for: .touchUpInside)
        self.view.isUserInteractionEnabled = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.white
        self.view.addSubview(tableView)
        
        //tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        // self.cellPopupView.addGestureRecognizer(tapGesture)
    }
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TripsCustomCell(style: .default, reuseIdentifier: "tripCell")
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        let ID:Int = tempDic["tripid"] as! Int
        cell.tripIDLabel.text = "\(ID)"
        cell.sourceLabel.text = NSLocalizedString("source", comment: "")
        cell.sourceAddressLabel.text = tempDic["origlocalname"] as! String?
        cell.destinationLabel.text = NSLocalizedString("destination", comment: "")
        cell.destinationAddressLabel.text = tempDic["destlocalname"] as! String?
        cell.tripStatus.text = NSLocalizedString("tripStatus", comment: "")
        cell.tripStatusDescLabel.text = tempDic["tripstatustext"] as! String?

        if let price = tempDic["totalprice"]{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let NSChargeAmount:NSNumber = (price as! NSNumber)
            let SeparatorNumber = formatter.string(from: NSChargeAmount)
            cell.priceLabel.text = "\(SeparatorNumber!)" + " " + NSLocalizedString("rial", comment: "")
        }
        
        //        if let chargeAmount = tempDic["chargeamount"]{
        //
        //            let formatter = NumberFormatter()
        //            formatter.numberStyle = .decimal
        //            formatter.groupingSeparator = ","
        //            let NSChargeAmount:NSNumber = (chargeAmount as! NSNumber)
        //            let SeparatorNumber = formatter.string(from: NSChargeAmount)
        //            cell.priceAmountLabel.text = "\(SeparatorNumber!)"
        //        }
        //
        
        let dateInMilliSeconds:Double = tempDic["tripdate"] as! Double
        let dateInMilli: TimeInterval = dateInMilliSeconds/1000
        let normaldate = NSDate(timeIntervalSince1970: dateInMilli)
        
        let normalDateString:String = "\(normaldate)"
        let dateComponentsArray = normalDateString.characters.split{$0 == "-"}.map(String.init)
        let spaceComponentsArray = dateComponentsArray[2].characters.split{$0 == " "}.map(String.init)
        let colonComponentsArray = spaceComponentsArray[1].characters.split{$0 == ":"}.map(String.init)
        //let dateArray:Array = [Int(dateComponentsArray[0])!, Int(dateComponentsArray[1])!, Int(spaceComponentsArray[0])!, Int(colonComponentsArray[0]), Int(colonComponentsArray[1])]
        let persianDateInstance = PersianDate()
        let persianDateString:String = persianDateInstance.convertToPersianDateFinal(withYear: Int(dateComponentsArray[0])!, month: Int(dateComponentsArray[1])!, day: Int(spaceComponentsArray[0])!, hour: Int(colonComponentsArray[0])!, minute: Int(colonComponentsArray[1])!)
        cell.dateTimeLabel.text = persianDateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        print ("tempDic:\(tempDic)")
        tripID =  tempDic["tripid"] as! Int!
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tripRate = tempDic["rate"] as! Int
        print("TripRate:\(tripRate)")
        if tripRate == 0{
            
            showPopupWithRating()
            
        }else if tripRate != 0{
            
            showPopupWithoutRating()
        }
        
        //        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        //        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        transparentView.isUserInteractionEnabled = true
        //        self.view.addSubview(transparentView)
        //
        //        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        //        self.transparentView.addGestureRecognizer(tapGesture)
        //
        //        cellPopupView = UIView(frame: CGRect(x: screenWidth/2-125,y: screenHeight/2-100,width: 250,height: 200))
        //        cellPopupView.backgroundColor = whiteColor
        //        cellPopupView.layer.cornerRadius = 0
        //        cellPopupView.layer.shadowColor = UIColor.gray.cgColor
        //        cellPopupView.layer.shadowOpacity = 0.5
        //        cellPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        //        cellPopupView.layer.shadowRadius = 20
        //        self.view.addSubview(cellPopupView)
        //
        //        copyTripIDButton = makeButton(frame: CGRect(x: 0,y: 0,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("copyTripID", comment: ""), titleColor: topViewBlue, isRounded: false)
        //        copyTripIDButton.addTarget(self, action: #selector(TripsViewController.copyTripIDButtonAction), for: .touchUpInside)
        //        cellPopupView.addSubview(copyTripIDButton)
        //
        //        supportButton = makeButton(frame: CGRect(x: copyTripIDButton.frame.origin.x,y: copyTripIDButton.frame.origin.y+copyTripIDButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("support", comment: ""), titleColor: topViewBlue, isRounded: false)
        //        supportButton.addTarget(self, action: #selector(TripsViewController.supportButtonAction), for: .touchUpInside)
        //        cellPopupView.addSubview(supportButton)
        //
        //        ratingButton = makeButton(frame: CGRect(x: supportButton.frame.origin.x,y: supportButton.frame.origin.y+supportButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("registerRating", comment: ""), titleColor: topViewBlue, isRounded: false)
        //        ratingButton.addTarget(self, action: #selector(TripsViewController.ratingButtonAction), for: .touchUpInside)
        //        cellPopupView.addSubview(ratingButton)
        //
        //        closeButton = makeButton(frame: CGRect(x: ratingButton.frame.origin.x,y: ratingButton.frame.origin.y+ratingButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red , isRounded: false)
        //        closeButton.addTarget(self, action: #selector(TripsViewController.closeButtonAction), for: .touchUpInside)
        //        cellPopupView.addSubview(closeButton)
    }
    
    //MARK: -  Custom Methods
    override func menuAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func showPopupWithRating(){
        
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        self.transparentView.addGestureRecognizer(tapGesture)
        
        cellPopupView = UIView(frame: CGRect(x: screenWidth/2-125,y: screenHeight/2-100,width: 250,height: 200))
        cellPopupView.backgroundColor = whiteColor
        cellPopupView.layer.cornerRadius = 0
        cellPopupView.layer.shadowColor = UIColor.gray.cgColor
        cellPopupView.layer.shadowOpacity = 0.5
        cellPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellPopupView.layer.shadowRadius = 20
        self.view.addSubview(cellPopupView)
        
        copyTripIDButton = makeButton(frame: CGRect(x: 0,y: 0,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("copyTripID", comment: ""), titleColor: topViewBlue, isRounded: false)
        copyTripIDButton.addTarget(self, action: #selector(TripsViewController.copyTripIDButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(copyTripIDButton)
        
        supportButton = makeButton(frame: CGRect(x: copyTripIDButton.frame.origin.x,y: copyTripIDButton.frame.origin.y+copyTripIDButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("support", comment: ""), titleColor: topViewBlue, isRounded: false)
        supportButton.addTarget(self, action: #selector(TripsViewController.supportButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(supportButton)
        
        ratingButton = makeButton(frame: CGRect(x: supportButton.frame.origin.x,y: supportButton.frame.origin.y+supportButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("registerRating", comment: ""), titleColor: topViewBlue, isRounded: false)
        ratingButton.addTarget(self, action: #selector(TripsViewController.ratingButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(ratingButton)
        
        closeButton = makeButton(frame: CGRect(x: ratingButton.frame.origin.x,y: ratingButton.frame.origin.y+ratingButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red , isRounded: false)
        closeButton.addTarget(self, action: #selector(TripsViewController.closeButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(closeButton)
        
    }
    func showPopupWithoutRating(){
        
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        self.transparentView.addGestureRecognizer(tapGesture)
        
        cellPopupView = UIView(frame: CGRect(x: screenWidth/2-125,y: screenHeight/2-75,width: 250,height: 150))
        cellPopupView.backgroundColor = whiteColor
        cellPopupView.layer.cornerRadius = 0
        cellPopupView.layer.shadowColor = UIColor.gray.cgColor
        cellPopupView.layer.shadowOpacity = 0.5
        cellPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cellPopupView.layer.shadowRadius = 20
        self.view.addSubview(cellPopupView)
        
        copyTripIDButton = makeButton(frame: CGRect(x: 0,y: 0,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("copyTripID", comment: ""), titleColor: topViewBlue, isRounded: false)
        copyTripIDButton.addTarget(self, action: #selector(TripsViewController.copyTripIDButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(copyTripIDButton)
        
        supportButton = makeButton(frame: CGRect(x: copyTripIDButton.frame.origin.x,y: copyTripIDButton.frame.origin.y+copyTripIDButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("support", comment: ""), titleColor: topViewBlue, isRounded: false)
        supportButton.addTarget(self, action: #selector(TripsViewController.supportButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(supportButton)
        
        //ratingButton = makeButton(frame: CGRect(x: supportButton.frame.origin.x,y: supportButton.frame.origin.y+supportButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("registerRating", comment: ""), titleColor: topViewBlue, isRounded: false)
        //ratingButton.addTarget(self, action: #selector(TripsViewController.ratingButtonAction), for: .touchUpInside)
        //cellPopupView.addSubview(ratingButton)
        
        closeButton = makeButton(frame: CGRect(x: supportButton.frame.origin.x,y: supportButton.frame.origin.y+supportButton.frame.size.height,width: cellPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red , isRounded: false)
        closeButton.addTarget(self, action: #selector(TripsViewController.closeButtonAction), for: .touchUpInside)
        cellPopupView.addSubview(closeButton)
    }
    
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    //Hide popup when user tap around it
    func handleGesture(_ sender: UITapGestureRecognizer){
        if cellPopupView != nil {
            cellPopupView.removeFromSuperview()
            transparentView.removeFromSuperview()
        }
    }
    
    //Copy Trip ID
    func copyTripIDButtonAction(){
        closeButtonAction()
        UIPasteboard.general.string = String(tripID)
        cellPopupView.removeFromSuperview()
    }
    
    //Navigate To Rating VC
    func ratingButtonAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        nextViewController.tripsTripID = self.tripID
        nextViewController.IsCallFromTripsVC = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        if cellPopupView != nil {
            closeButtonAction()
        }
    }
    // Close Popup
    func closeButtonAction(){
        cellPopupView.removeFromSuperview()
        transparentView.removeFromSuperview()
    }
    //Support Button Action that navigate to support VC
    func supportButtonAction(){
        closeButtonAction()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        
        nextViewController.tripsTripID = self.tripID
        print(tripID)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        if cellPopupView != nil {
            cellPopupView.removeFromSuperview()
        }
    }
    //MARK: - ScrollView Delegate
    // Paging
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            self.pageNumber = self.pageNumber+1
            getTripList()
        }
        if (scrollView.contentOffset.y < 0){
            //reach top
        }
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }
    //MARK: -  Connections
    
    //Get Trip List Connection
    func getTripList(){
        
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
            //35.748428
            //51.285110
            let status:Int = 0
            let page:Int = self.pageNumber
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "status":status as AnyObject,
                                                        "page":page as AnyObject
            ]
            getTripListWithCallBack(apiName: "trip/gettriplist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                self.tableArray.append(location as! [String : AnyObject])
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
}
