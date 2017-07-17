//
//  ButtonMaker.swift
//  PeikYab
//
//  Created by Yarima on 9/7/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

func makeButton(frame:CGRect, backImageName:String?, backColor:UIColor?, title:String?, titleColor:UIColor?, isRounded:Bool) -> UIButton{
    
    let button = UIButton(frame: frame)
    if backImageName != nil {
        let image = UIImage(named: backImageName!)
        button.setBackgroundImage(image, for: UIControlState())
    }
    button.setTitle(title, for: UIControlState())
    button.titleLabel?.font = FONT_MEDIUM(15)
    if isRounded {
        button.layer.cornerRadius = frame.size.height/2
        button.clipsToBounds = true
    }
    button.setTitleColor(titleColor, for: UIControlState())
    button.backgroundColor = backColor
    
    return button
}

func makeButton2(frame:CGRect, backColor:UIColor?, title:String?, titleColor:UIColor?, isRounded:Bool) -> UIButton{
    
    let button = UIButton(frame: frame)
    button.setTitle(title, for: UIControlState())
    button.titleLabel?.font = FONT_MEDIUM(15)
    if isRounded {
        button.layer.cornerRadius = frame.size.height/2
        button.clipsToBounds = true
    }
    button.setTitleColor(titleColor, for: UIControlState())
    button.backgroundColor = backColor
    //button.contentHorizontalAlignment = .right
    return button
}
