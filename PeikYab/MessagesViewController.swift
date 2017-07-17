//
//  messagesViewController.swift
//  PeikYab
//
//  Created by nooran on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
class MessagesViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    
    //MARK: - Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "cellTrip"
    var tableArray = [[String:AnyObject]]()
    var messageImage:UIImageView!
    var messageLabel:UILabel!
    var peykyabLabel:UILabel!
    var page:Int = 1
    //MARK: -  viewWillAppear
    override func viewDidAppear(_ animated: Bool) {
        getMessageList()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTopbar(NSLocalizedString("messages", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        //makeUI()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.isHidden = true
        tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        //tableView.estimatedRowHeight = 50
        //tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        
        self.view.isUserInteractionEnabled = true
    }
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        
        var str = tempDic["Message"] as! String?
        
        str = str?.removingPercentEncoding!
        str = str?.replacingOccurrences(of: "+", with: " ")
        print("height:\(getHeightOfString(labelText: str!))")
        return getHeightOfString(labelText: str!) + 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = MessageCustomCell(style: .default, reuseIdentifier: "tripCell")
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        
        //let ID:Int = tempDic["Id"] as! Int
        //cell.messageIDLabel.text = "\(ID)"
        
        cell.titleLabel.text = NSLocalizedString("messageText", comment: "")
        
        var msg = tempDic["Message"] as! String?
        
        msg = msg?.removingPercentEncoding!
        msg = msg?.replacingOccurrences(of: "+", with: " ")
        
        cell.messageTextLabel.text = msg?.removingPercentEncoding!
        
        var rect: CGRect = cell.messageTextLabel.frame
        rect.size.height = getHeightOfString(labelText: cell.messageTextLabel.text!) + 40
        cell.messageTextLabel.frame = rect
        
        rect = cell.dateTimeLabel.frame
        rect.origin.y = cell.messageTextLabel.frame.origin.y+cell.messageTextLabel.frame.size.height+20
        cell.dateTimeLabel.frame = rect
        
        let dateInMilliSeconds:Double = tempDic["InsertTime"] as! Double
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
        
        rect = cell.lineView.frame
        rect.origin.y = cell.dateTimeLabel.frame.origin.y+cell.dateTimeLabel.frame.size.height+10
        cell.lineView.frame = rect
        
        return cell
    }
    //MARK: -  Custom Methods
    
    //Make UI accoording to Messages count
    
    //Hide table view if messages not exist and just show message image
    func makeUI(){
        if self.tableArray.count == 0 {
            
            self.tableView.isHidden = true
            self.makeViewForEmptyMessages()
            
        }
        else if self.tableArray.count>0{
            tableView.isHidden = false
        }
    }
    
    //Back To Previous VC
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Show messageImage When messages not exist
    func makeViewForEmptyMessages(){
        
        messageImage = UIImageView(frame: CGRect(x: screenWidth/2-50,y: screenHeight/2-50,width: 100,height: 100))
        messageImage.image = UIImage(named: "message")
        messageImage.contentMode = .scaleAspectFit
        self.view.addSubview(messageImage)
        
        messageLabel = UILabel(frame: CGRect(x: 60,y: messageImage.frame.origin.y+messageImage.frame.size.height+30,width: screenWidth-120,height: 60))
        messageLabel.backgroundColor = UIColor.white
        messageLabel.textColor = UIColor.black
        messageLabel.font = FONT_MEDIUM(13)
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.text = NSLocalizedString("MessagesOFFSuggestion", comment: "")
        self.view.addSubview(messageLabel)
    }
    
    func getHeightOfString(labelText:String)->CGFloat{
        
        var font:UIFont = FONT_NORMAL(13)!
        
        if(DeviceType.IS_IPAD){
            font = FONT_NORMAL(22)!
        }
        let sizeOf:CGSize = labelText.boundingRect(with: CGSize(width: self.view.bounds.size.width - 30, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
    
        let height:CGFloat = sizeOf.height
        
        return height
    }

    //MARK: - scrollview delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            print("reach bottom")
            page = page + 1
            getMessageList()
        }
    }
    
    //MARK: -  Connections
    
    //Get Messages List Connection
    func getMessageList(){
        
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
                                                        "page":page as AnyObject
            ]
            getMessageListWithCallBack(apiName: "contact/getmessagelist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                self.tableArray.append(location as! [String : AnyObject])
                            }
                            ////Test for empty message list
                            // self.tableArray.removeAll()
                            
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                                self.makeUI()
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
