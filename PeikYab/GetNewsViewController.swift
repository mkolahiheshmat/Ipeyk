//
//  GetNewsViewController.swift
//  NewPeikyab
//
//  Created by Developer on 9/7/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class GetNewsViewController:BaseViewController{
    //MARK: - Variables
    
    
    //MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTopbar(NSLocalizedString("getNews", comment: ""))
        backButton.addTarget(self, action: #selector(GetNewsViewController.backAction), for: .touchUpInside)
    }
    
    //MARK: -  custome Methods
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}
