//
//  selectedAddressViewController.swift
//  PeikYab
//
//  Created by Yarima on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class SelectedAddressViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate{
    
    //MARK: - Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "selectedAddressCell"
    var tableArray = [[String:AnyObject]]()
    var menuView:UIView!
    var copyTripIDButton:UIButton!
    var tapGesture:UITapGestureRecognizer!
    var tripID:String! = ""
    var newButton:UIButton!
    var originSelected:Int = 0
    
    var popupView : UIView!
    var favouritAddressLabel:UILabel!
    var favouritAddressTextField : UITextField!
    var addressForDriverLabel:UILabel!
    var addressForDriverTextField : UITextField!
    var saveButton :UIButton!
    var deleteButton:UIButton!
    var transparentView:UIView!
    var addressID:Int = 0
    var paramsToUpdateFavItem:[String:AnyObject]!
    var pageNumber:Int = 1
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool){
        pageNumber = 1
        tableArray = [[String:AnyObject]]()
        getFavouritAddressList()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //getFavouritAddressList()
        if (UserDefaults.standard.object(forKey: "originSelected") as? Int) != nil{
        originSelected = (UserDefaults.standard.object(forKey: "originSelected") as? Int)!
        }
        
        makeTopbar(NSLocalizedString("selectedAddress", comment: ""))
        backButton.addTarget(self, action: #selector(TripsViewController.backAction), for: .touchUpInside)
        self.view.isUserInteractionEnabled = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.white
        self.view.addSubview(tableView)
        
        newButton = makeButton(frame: CGRect(x: screenWidth - 70, y:screenHeight-70, width: 60, height: 60), backImageName: "addToTurnover", backColor: nil, title:"", titleColor: topViewBlue, isRounded: false)
        newButton.addTarget(self, action: #selector(SelectedAddressViewController.newButtonAction), for: .touchUpInside)
        self.view.addSubview(newButton)
        
    }
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        let cell = SelectedAddressCustomCell(style: .default, reuseIdentifier: "favouritAddressCell")
        /*if let str = String(data: data, encoding: NSUTF8StringEncoding) {
         print(str)
         } else {
         print("not a valid UTF-8 sequence")
         }*/
        
        cell.nameLabel.text = tempDic["name"] as! String?
        
        cell.popupButton.addTarget(self, action: #selector(SelectedAddressViewController.popupButtonAction), for: .touchUpInside)
        cell.popupButton.tag = indexPath.row
        
        cell.neighborhoodLabel.text = tempDic["neighbor"] as! String?
        
        if let addressStr:String = tempDic["address"] as? String{
            cell.addressLabel.text = "\(addressStr)"
        }
        
        cell.selectAsDesButton.tag = indexPath.row
        cell.selectAsDesButton.addTarget(self, action: #selector(SelectedAddressViewController.selectAsDesButtonAction), for: .touchUpInside)
        if originSelected == 0{
            cell.selectAsDesButton.setTitle(NSLocalizedString("selectAsOrigin", comment: ""), for: .normal)
        }else if originSelected == 1{
            cell.selectAsDesButton.setTitle(NSLocalizedString("selectAsDest", comment: ""), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: -  TextField Delegate
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
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 110
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 100
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 100
                    self.view.frame = rect
                })
            }
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
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: -  Custom Methods
    func selectAsDesButtonAction(_ sender:UIButton){
        if originSelected == 0 {
            _ = self.navigationController?.popToRootViewController(animated: true)
            let notificationName = Notification.Name("setFavAddressAsOrigin")
            NotificationCenter.default.post(name: notificationName, object: tableArray[sender.tag])
        }else if originSelected == 1{
            _ = self.navigationController?.popToRootViewController(animated: true)
            let notificationName = Notification.Name("setFavAddressAsDestination")
            NotificationCenter.default.post(name: notificationName, object: tableArray[sender.tag])
        }
    }
    
    func backAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Add New Favourite Address
    func newButtonAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FavoriteMapViewController") as! FavoriteMapViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    //Show Popup
    func popupButtonAction(_ sender:UIButton){
        let btn = sender as UIButton
        if tableArray.count == 0 {
            return
        }
        
        let tempDic:[String:AnyObject] = tableArray[btn.tag]
        
        paramsToUpdateFavItem = tempDic
        
        tableView.isUserInteractionEnabled = false
        
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight-64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(transparentView)
        
        popupView = UIView(frame: CGRect(x: 20,y: screenHeight/2-172,width: screenWidth-40,height: 280))
        popupView.backgroundColor = whiteColor
        popupView.layer.cornerRadius = 20
        popupView.layer.shadowColor = UIColor.gray.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popupView.layer.shadowRadius = 20
        transparentView.addSubview(popupView)
        
        favouritAddressLabel = UILabel(frame: CGRect(x: 10, y: 10, width: popupView.frame.size.width - 20, height: 50))
        favouritAddressLabel.backgroundColor = whiteColor
        favouritAddressLabel.textColor = labelTextColor
        favouritAddressLabel.font = FONT_NORMAL(13)
        favouritAddressLabel.text = NSLocalizedString("favouritAddress", comment: "")
        favouritAddressLabel.textAlignment = .right
        favouritAddressLabel.adjustsFontSizeToFitWidth = true
        popupView.addSubview(favouritAddressLabel)
        
        favouritAddressTextField = UITextField(frame: CGRect(x: favouritAddressLabel.frame.origin.x,y: favouritAddressLabel.frame.origin.y+favouritAddressLabel.frame.size.height, width: favouritAddressLabel.frame.size.width, height: 40))
        favouritAddressTextField.font = FONT_NORMAL(13)
        favouritAddressTextField.text = tempDic["name"] as? String
        favouritAddressTextField.textColor = UIColor.black
        favouritAddressTextField.borderStyle = .roundedRect
        favouritAddressTextField.autocorrectionType = UITextAutocorrectionType.no
        favouritAddressTextField.keyboardType = UIKeyboardType.default
        favouritAddressTextField.returnKeyType = UIReturnKeyType.done
        favouritAddressTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        favouritAddressTextField.contentVerticalAlignment = .center
        favouritAddressTextField.contentHorizontalAlignment = .center
        favouritAddressTextField.textAlignment = .right
        favouritAddressTextField.delegate = self
        favouritAddressTextField.adjustsFontSizeToFitWidth = true
        favouritAddressTextField.autocapitalizationType = .none
        favouritAddressTextField.backgroundColor = lightBlue
        favouritAddressTextField.clipsToBounds = true
        favouritAddressTextField.layer.borderWidth = 0.8
        favouritAddressTextField.layer.borderColor = textFieldBorderBlue.cgColor
        favouritAddressTextField.tag = 13
        popupView.addSubview(favouritAddressTextField)
        
        addressForDriverLabel = UILabel(frame: CGRect(x: 10, y: favouritAddressTextField.frame.origin.y+favouritAddressTextField.frame.size.height, width: popupView.frame.size.width - 20, height: 50))
        addressForDriverLabel.backgroundColor = whiteColor
        addressForDriverLabel.textColor = labelTextColor
        addressForDriverLabel.font = FONT_NORMAL(13)
        addressForDriverLabel.text = NSLocalizedString("addressForDriver", comment: "")
        addressForDriverLabel.textAlignment = .right
        addressForDriverLabel.adjustsFontSizeToFitWidth = true
        popupView.addSubview(addressForDriverLabel)
        
        addressForDriverTextField = UITextField(frame: CGRect(x: addressForDriverLabel.frame.origin.x,y: addressForDriverLabel.frame.origin.y+addressForDriverLabel.frame.size.height, width: addressForDriverLabel.frame.size.width, height: 40))
        addressForDriverTextField.font = FONT_NORMAL(13)
        addressForDriverTextField.text = tempDic["address"] as? String
        addressForDriverTextField.textColor = UIColor.black
        addressForDriverTextField.borderStyle = .roundedRect
        addressForDriverTextField.autocorrectionType = UITextAutocorrectionType.no
        addressForDriverTextField.keyboardType = UIKeyboardType.default
        addressForDriverTextField.returnKeyType = UIReturnKeyType.done
        addressForDriverTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        addressForDriverTextField.contentVerticalAlignment = .center
        addressForDriverTextField.contentHorizontalAlignment = .center
        addressForDriverTextField.textAlignment = .right
        addressForDriverTextField.delegate = self
        addressForDriverTextField.adjustsFontSizeToFitWidth = true
        addressForDriverTextField.autocapitalizationType = .none
        addressForDriverTextField.backgroundColor = lightBlue
        addressForDriverTextField.clipsToBounds = true
        addressForDriverTextField.layer.borderWidth = 0.8
        addressForDriverTextField.layer.borderColor = textFieldBorderBlue.cgColor
        addressForDriverTextField.tag = 14
        popupView.addSubview(addressForDriverTextField)
        
        let saveButton = makeButton(frame: CGRect(x: addressForDriverTextField.frame.origin.x+addressForDriverTextField.frame.size.width-50,y: addressForDriverTextField.frame.origin.y+addressForDriverTextField.frame.size.height+20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("save", comment: ""), titleColor: topViewBlue, isRounded: false)
        saveButton.addTarget(self, action: #selector(SelectedAddressViewController.saveButtonAction), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        let deleteButton = makeButton(frame: CGRect(x: popupView.frame.size.width/2-25,y: addressForDriverTextField.frame.origin.y+addressForDriverTextField.frame.size.height+20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("delete", comment: ""), titleColor: UIColor.gray, isRounded: false)
        deleteButton.addTarget(self, action: #selector(SelectedAddressViewController.deleteButtonAction), for: .touchUpInside)
        popupView.addSubview(deleteButton)
        
        let closeButton = makeButton(frame: CGRect(x: 10,y: addressForDriverTextField.frame.origin.y+addressForDriverTextField.frame.size.height+20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(SelectedAddressViewController.closeButtonAction), for: .touchUpInside)
        popupView.addSubview(closeButton)
    }
    func deleteButtonAction(){
        deleteFavouriteAddress()
    }
    
    func saveButtonAction(){
        updateFavouriteAddress()
    }
    
    //Hide Popup
    func closeButtonAction(){
        popupView.removeFromSuperview()
        transparentView.removeFromSuperview()
        tableView.isUserInteractionEnabled = true
    }
    //MARK: - ScrollView Delegate
    //Paging
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            self.pageNumber = self.pageNumber+1
            //tableView.isUserInteractionEnabled = true
            self.getFavouritAddressList()
        }
        if (scrollView.contentOffset.y < 0){
            //reach top
        }
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }
   
    
    //MARK: -  Connections
    
    //Get Favourite Address List Connection
    func getFavouritAddressList(){
        
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
                                                        "page":pageNumber as AnyObject
            ]
            getFavouritAddressListWithCallBack(apiName: "location/getfavoriteaddresslist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in

                if let responseDic = resDic{
                    ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                    })
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
                }//Error
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
    
    //update Favourite Address Connection
    func updateFavouriteAddress(){
        if (favouritAddressTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterFavouriteAddress", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (addressForDriverTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterAddressForDriver", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
        
        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            
            let addressID:Int = paramsToUpdateFavItem["locationid"] as! Int
            let nameString:String = favouritAddressTextField.text!
            let addressString:String = addressForDriverTextField.text!
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> =  ["sessionid": sessionID! as AnyObject,
                                                         "addressid": addressID as AnyObject,
                                                         "name":nameString as AnyObject,
                                                         "address": addressString as AnyObject
            ]
            print ("params:\(params)")
            updateFavouriteAddressWithCallBack(apiName: "location/updatefavoriteaddress", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                
                if let responseDic = resDic{
                    
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async {
                            let msg:String = responseDic.object(forKey: "msg") as! String
                            let alert = UIAlertController(title: NSLocalizedString("setProfile", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                            
                            self.pageNumber = 1
                            self.tableArray = [[String:AnyObject]]()
                            self.getFavouritAddressList()
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
                }//Error
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
        closeButtonAction()
    }
    
    //Delete selected favourite address connection
    func deleteFavouriteAddress(){
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
            
            let addressID:Int = paramsToUpdateFavItem["locationid"] as! Int
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "addressid": addressID as AnyObject,
                                                        ]
            deleteFavouriteAddressWithCallBack(apiName: "location/deletefavoriteaddress", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.sync {
                           // // when just one item remain in list to
                            if self.tableArray.count == 1{
                                self.tableArray = [[String:AnyObject]]()
                                self.tableView.reloadData()
                              //  self.getFavouritAddressList()
                            }
                            self.pageNumber = 1
                            self.tableArray = [[String:AnyObject]]()
                            self.getFavouritAddressList()
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
        closeButtonAction()
    }
}
