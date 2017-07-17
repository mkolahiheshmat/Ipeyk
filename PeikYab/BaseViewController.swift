//
//  BaseViewController.swift
//  PeikYab
//
//  Created by Yarima on 9/3/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    //instance variables
    var menuButton : UIButton!
    var backButton : UIButton!
    var lineView : UIView!
    var topView:UIView!
    //MARK: -  Make Top Bar
    func makeTopbar(_ titleString:String){
        topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        topView.backgroundColor = topViewBlue
        self.view.addSubview(topView)
        
        let titleLabel = UILabel(frame: CGRect(x: screenWidth/2 - 100, y: topView.frame.size.height/2-10, width: 200, height: 40))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = whiteColor
        titleLabel.text = titleString
        titleLabel.font = FONT_MEDIUM(15)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        topView.addSubview(titleLabel)
        
        menuButton = UIButton(frame: CGRect(x: screenWidth-40,y: 17,width: 30,height: 30))
        menuButton.addTarget(self, action: #selector(BaseViewController.menuAction), for: .touchUpInside)
        topView.addSubview(menuButton)
        
        backButton = UIButton(frame: CGRect(x: 5,y: topView.frame.size.height/2-10,width: 40,height: 40))
        let backimg = UIImage(named:"TopViewBack")
        backButton.setBackgroundImage(backimg, for: UIControlState())
        topView.addSubview(backButton)
        
    }
    
    //MARK: -  custom Methods
    
    //dismiss Keyboard in viewcontrollers by when user tapped
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Dismiss Keyboard
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    //Menu Action
    func menuAction(){
        /*
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
         self.navigationController?.pushViewController(nextViewController, animated: true)
         */
    }
    //Add Line View Under UITextFields and etc in Login and sign up VC and other VC
    func addLineView(_ x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat,color:UIColor,superView:UIView){
        lineView = UIView(frame: CGRect(x: x,y: y,width: w,height: h))
        lineView.backgroundColor = color
        superView.addSubview(lineView)  
    }
}
