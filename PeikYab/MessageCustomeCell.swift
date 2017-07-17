//
//  MessageCustomeCell.swift
//  PeikYab
//
//  Created by Developer on 9/18/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class MessageCustomCell: UITableViewCell{
    
    //MARK: - Variables
    var messageIDLabel : UILabel!
    var pathImage : UIImageView!
    var titleLabel : UILabel!
    var messageTextLabel : UILabel!
    var destinationLabel :UILabel!
    var destinationAddressLabel : UILabel!
    var driverLabel:UILabel!
    var driverNameLabel :UILabel!
    var priceLabel : UILabel!
    var dateTimeLabel :UILabel!
    var lineView:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Message Label
        titleLabel = UILabel(frame: CGRect(x: 20,y: 5,width: screenWidth-40,height: 20))
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textColor = topViewBlue
        titleLabel.font = FONT_NORMAL(13)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .right
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        self.addSubview(titleLabel)
        
        //Message Text  Label
        messageTextLabel = UILabel(frame: CGRect(x: 20,y: titleLabel.frame.origin.y+titleLabel.frame.size.height,width: screenWidth-40,height:0))
        messageTextLabel.backgroundColor = UIColor.white
        messageTextLabel.layer.borderColor = UIColor.white.cgColor
        messageTextLabel.clipsToBounds = true
        messageTextLabel.textColor = UIColor.gray
        messageTextLabel.font = FONT_NORMAL(13)
        messageTextLabel.numberOfLines = 0
        messageTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageTextLabel.textAlignment = .right
        self.addSubview(messageTextLabel)
        
        lineView = UIView(frame: CGRect(x: 20,y: titleLabel.frame.origin.y+titleLabel.frame.size.height,width: screenWidth,height: 1.0))
        lineView.backgroundColor = UIColor.white
        self.addSubview(lineView)
        
        //DateTime Label
        dateTimeLabel = UILabel(frame: CGRect(x: 10,y: messageTextLabel.frame.origin.y+messageTextLabel.frame.size.height,width: screenWidth-20,height: 20))
        dateTimeLabel.backgroundColor = UIColor.white
        dateTimeLabel.textColor = topViewBlue
        dateTimeLabel.font = FONT_NORMAL(13)
        dateTimeLabel.numberOfLines = 1
        dateTimeLabel.textAlignment = .right
        dateTimeLabel.adjustsFontSizeToFitWidth = true
        dateTimeLabel.minimumScaleFactor = 0.5
        self.addSubview(dateTimeLabel)
        
        lineView = UIView(frame: CGRect(x: 0,y: dateTimeLabel.frame.origin.y+dateTimeLabel.frame.size.height+10,width: screenWidth,height: 1.5))
        lineView.backgroundColor = lineViewColor
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

