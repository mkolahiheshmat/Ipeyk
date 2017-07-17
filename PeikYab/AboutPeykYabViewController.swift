//
//  AboutPeykYab.swift
//  NewPeikyab
//
//  Created by Developer on 9/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class AboutPeykYabViewController: BaseViewController{
    //MARK: - Variables
    
    var aboutUsLabel:UILabel!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTopbar(NSLocalizedString("aboutPeykYab", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        aboutUsLabel = UILabel(frame: CGRect(x: 20, y: 70, width: screenWidth-40, height: 30))
        aboutUsLabel.backgroundColor = UIColor.white
        aboutUsLabel.textColor = UIColor.black
        aboutUsLabel.font = FONT_NORMAL(20)
        aboutUsLabel.numberOfLines = 100
        aboutUsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutUsLabel.textAlignment = .center
        aboutUsLabel.text = "(ipeyk)درباره آی پیک"
        aboutUsLabel.adjustsFontSizeToFitWidth = true
        aboutUsLabel.minimumScaleFactor = 0.5
        self.view.addSubview(aboutUsLabel)
        
        
    }
    
    //MARK: -  custom Methods
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
