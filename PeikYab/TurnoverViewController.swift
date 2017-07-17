//
//  turnoverViewController.swift
//  PeikYab
//
//  Created by nooran on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class TurnoverViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    //MARK: - Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "cellTurnover"
    var tableArray = [[String:AnyObject]]()
    var addCreditButton:UIButton!
    var popupView:UIView!
    var currentLabel:UILabel!
    var addCreditLabel:UILabel!
    var currentCreditLabel:UILabel!
    var addCreditThroughLabel:UILabel!
    var amountTextField:UITextField!
    var tapGesture:UIGestureRecognizer!
    var paymentNumber : Int = 0
    var onlinePaymentButton:UIButton!
    //var USSDPaymentButton:UIButton!
    var peykyabButton:UIButton!
    var payButton:UIButton!
    var webViewURL:String!
    var currentCredit:Int = 0
    var transparentView:UIView!
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool) {
        paymentNumber = 0
        //tableArray = [[String:AnyObject]]()
        getTransactionsList()
        //getCredit()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getTransactionsList()
        
        makeTopbar(NSLocalizedString("turnover", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        self.view.isUserInteractionEnabled = true
        
        //TableView
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        self.view.addSubview(tableView)
        addCreditButton = makeButton(frame: CGRect(x: screenWidth-70, y: screenHeight-70, width: 60, height: 60), backImageName: "addToTurnover", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        addCreditButton.addTarget(self, action: #selector(TurnoverViewController.addCreditButtonAction), for: .touchUpInside)
        self.view.addSubview(addCreditButton)
        
    }
    
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableArray.count == 0{
            return 0
        }
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TurnoverCustomCell(style: .default, reuseIdentifier: "tripCell")
        //if tableArray[indexPath.row].keys.count>0 {
            
        let tempDic:Dictionary? = tableArray[indexPath.row]
        
        //        if tableArray.count == 0{
        //
        //            let alert = UIAlertController(title: NSLocalizedString("turnover", comment: ""), message:NSLocalizedString("listIsEmpty", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
        //            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
        let paymentMode:Int = tempDic!["paymentmode"] as! Int
        if paymentMode == 1{
            
            cell.creditConditionLabel.text = NSLocalizedString("addCredit", comment: "")
            cell.creditConditionLabel.textColor = topViewBlue
            cell.priceAmountLabel.textColor = topViewBlue
            
        }else if paymentMode == -1{
            
            cell.creditConditionLabel.text = NSLocalizedString("reduceCredit", comment: "")
            cell.creditConditionLabel.textColor = UIColor.red
            cell.priceAmountLabel.textColor = UIColor.red
            
        }
        if let chargeAmount = tempDic?["chargeamount"]{
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","
            let NSChargeAmount:NSNumber = (chargeAmount as! NSNumber)
            let SeparatorNumber = formatter.string(from: NSChargeAmount)
            cell.priceAmountLabel.text = "\(SeparatorNumber!)"
        }
        //Convert Date if needed
        //cell.dateTimeLabel.text = NSLocalizedString("dateTime", comment: "")
        if let _:String = tempDic?["transactiontime"]?.stringValue{
            
            let dateInMilliSeconds:Double = tempDic!["transactiontime"] as! Double
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
            
        }
        if let paymentMessage:String = tempDic?["paymentmessage"] as? String{
            cell.descriptionTextLabel.text = "\(paymentMessage)"
        }
        //}
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -  TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // USSDPaymentButton.setTitleColor(grayColor,for: UIControlState())
       // onlinePaymentButton.setTitleColor(grayColor,for: UIControlState())
       // peykyabButton.setTitleColor(grayColor,for: UIControlState())
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 180
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_5{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 130
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 100
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6P{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 100
                self.view.frame = rect
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    
    //MARK: -  Custom Methods
    func backAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func closeButtonAction(){
        popupView.removeFromSuperview()
        transparentView.removeFromSuperview()
    }
    func handleGesture(_ sender:UITapGestureRecognizer){
        if popupView != nil {
            
            view.endEditing(true)
            //popupView.removeFromSuperview()
            //transparentView.removeFromSuperview()
        }
        amountTextField.resignFirstResponder()
        
    }
    
    //Add Credit Button Action
    func addCreditButtonAction(){
        
        //Popup Transparent View
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        transparentView.addGestureRecognizer(tapGesture)
        
        //Popup View
        popupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-200,width: screenWidth-100,height: 350))
        popupView.backgroundColor = whiteColor
        popupView.layer.cornerRadius = 0
        popupView.layer.shadowColor = UIColor.gray.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popupView.layer.shadowRadius = 20
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            popupView.frame.origin.y = 70
        }
        self.view.addSubview(popupView)
        
        //popup Add Credit Label
        addCreditLabel = UILabel(frame: CGRect(x: 0,y: 0, width: popupView.frame.size.width, height: 50))
        addCreditLabel.backgroundColor = orangeColor2
        addCreditLabel.textColor = whiteColor
        addCreditLabel.font = FONT_NORMAL(17)
        addCreditLabel.text = NSLocalizedString("addCredit", comment: "")
        addCreditLabel.textAlignment = .center
        popupView.addSubview(addCreditLabel)
        
        //popup Current Label
        currentLabel = UILabel(frame: CGRect(x: popupView.frame.size.width/2,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: popupView.frame.size.width/2, height: 50))
        currentLabel.backgroundColor = UIColor.white
        currentLabel.textColor = topViewBlue
        currentLabel.font = FONT_NORMAL(13)
        currentLabel.text = NSLocalizedString("currentCredit", comment: "")
        currentLabel.textAlignment = .center
        popupView.addSubview(currentLabel)
        
        //popup Current Credit Label
        currentCreditLabel = UILabel(frame: CGRect(x:0,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: popupView.frame.size.width/2, height: 50))
        currentCreditLabel.backgroundColor = UIColor.white
        currentCreditLabel.textColor = topViewBlue
        currentCreditLabel.font = FONT_NORMAL(13)
        //currentCreditLabel.text = "\(currentCredit)" + NSLocalizedString("rial", comment: "")
        currentCreditLabel.textAlignment = .center
        popupView.addSubview(currentCreditLabel)
        getCredit()
        
        //addCreditThrough Label
        addCreditThroughLabel = UILabel(frame: CGRect(x: currentCreditLabel.frame.origin.x,y: currentCreditLabel.frame.origin.y+currentCreditLabel.frame.size.height, width: popupView.frame.size.width, height: 50))
        addCreditThroughLabel.backgroundColor = whiteColor
        addCreditThroughLabel.textColor = labelTextColor
        addCreditThroughLabel.font = FONT_NORMAL(15)
        addCreditThroughLabel.text = NSLocalizedString("addCreditThrough", comment: "")
        addCreditThroughLabel.textAlignment = .center
        popupView.addSubview(addCreditThroughLabel)
        lineView = UIView(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+45,width: addCreditThroughLabel.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        popupView.addSubview(lineView)
        
        //popup online Payment Button
        onlinePaymentButton = makeButton(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+addCreditThroughLabel.frame.size.height,width: popupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("onlinePayment", comment: ""), titleColor: grayColor, isRounded: false)
        onlinePaymentButton.addTarget(self, action: #selector(TurnoverViewController.onlinePaymentButtonAction), for: .touchUpInside)
        popupView.addSubview(onlinePaymentButton)
        
        lineView = UIView(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+45,width: onlinePaymentButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        popupView.addSubview(lineView)
        /*
         //popup USSD Payment Button
         USSDPaymentButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: popupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("USSDPayment", comment: ""), titleColor: grayColor, isRounded: false)
         USSDPaymentButton.addTarget(self, action: #selector(TurnoverViewController.USSDPaymentButtonAction), for: .touchUpInside)
         popupView.addSubview(USSDPaymentButton)
         lineView = UIView(frame: CGRect(x: USSDPaymentButton.frame.origin.x,y: USSDPaymentButton.frame.origin.y+45,width: USSDPaymentButton.frame.size.width,height: 1))
         lineView.backgroundColor = lineViewColor
         popupView.addSubview(lineView)
         */
        
        //popup peykyab Button
        peykyabButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: popupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("peykyabCard", comment: ""), titleColor: grayColor, isRounded: false)
        peykyabButton.addTarget(self, action: #selector(TurnoverViewController.peykYabButtonAction), for: .touchUpInside)
        popupView.addSubview(peykyabButton)
        lineView = UIView(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+45,width: peykyabButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        popupView.addSubview(lineView)
        
        //popup amount TextField
        amountTextField = UITextField(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+peykyabButton.frame.size.height,width: popupView.frame.size.width,height: 50))
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
        popupView.addSubview(amountTextField)
        
        //Popup Pay Button
        payButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x+amountTextField.frame.size.width-50,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("pay", comment: ""), titleColor: topViewBlue, isRounded: false)
        payButton.addTarget(self, action: #selector(TurnoverViewController.payButtonAction), for: .touchUpInside)
        popupView.addSubview(payButton)
        
        //popup Close Button
        let closeButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(TurnoverViewController.closeButtonAction), for: .touchUpInside)
        popupView.addSubview(closeButton)
    }
    
    /*
     //USSD PaymentButton Action
     func USSDPaymentButtonAction(){
     onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
     peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
     USSDPaymentButton.setTitleColor(topViewBlue,for: UIControlState())
     amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
     payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
     paymentNumber = 2
     }
     */
    
    //Online Payment Action
    func onlinePaymentButtonAction(){
        // USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("amountToAdd", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
        payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
        paymentNumber = 1
    }
    
    //Peykyab Button Action
    func peykYabButtonAction(){
        // USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterChargeCardCode", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("enterChargeCardCode", comment: "")
        payButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        paymentNumber = 3
    }
    //Pay Button Action
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
            // case 2:
            //USSD()
        // break
        case 3:
            giftCard()
            break
        default:
            print("Nothing")
            break
        }
    }
    //MARK: -  Connections
    
    //Get List of Transactions Connection
    func getTransactionsList(){
        
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
        
        print ("SessionID:\(sessionID)")
        
        if sessionID != nil {
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject
            ]
            getTransactionsListWithCallBack(apiName: "billing/gettransactions", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        self.tableArray = [[String:AnyObject]]()
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                
                                self                            .tableArray.append(location as! [String : AnyObject])
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
    
    //Add Credit via Online Payment in Webview Connection
    func shaparak(){
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
                            
                            self.popupView.removeFromSuperview()
                            self.transparentView.removeFromSuperview()
                            
                            
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
    //Add Credit  via peikyab Charge Card Connection
    func giftCard(){
        
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
                        
                        self.popupView.removeFromSuperview()
                        
                        self.getTransactionsList()
                        
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
    //get Credit Connection
    func getCredit(){
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
            getCreditWithCallBack(apiName: "billing/getcredit", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    
                    if (resDic?.object(forKey: "status") as! Int) == 1{
                        
                        //self.currentCredit = resDic?.object(forKey: "credit") as! Int
                        
                        DispatchQueue.main.async{
                            
                            self.currentCredit = resDic?.object(forKey: "credit") as! Int!
                            
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.groupingSeparator = ","
                            let NSCredit:NSNumber = (self.currentCredit as NSNumber)
                            let SeparatorNumber = formatter.string(from: NSCredit)
                            
                            self.currentCreditLabel.text = "\(SeparatorNumber!)" + NSLocalizedString("rial", comment: "")
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

