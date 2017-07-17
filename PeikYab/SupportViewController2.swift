//
//  supportViewController.swift
//  PeikYab
//
//  Created by nooran on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class SupportViewController2:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: -  Variables
    var tableView:UITableView!
    let cellReuseIdendifier = "cellSupport"
    var tableArray = [[String:AnyObject]]()
    var callButton : UIButton!
    var tripsTripID:Int!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTopbar(NSLocalizedString("peykyabSupport", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        self.view.isUserInteractionEnabled = true
        
        //Table View
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        self.view.addSubview(tableView)
        //updateTableArray()
        
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
        let phoneNumber="09121234567"
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
}

