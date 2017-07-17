//
//  SupportCustomCell.swift
//  NewPeikyab
//
//  Created by Developer on 9/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit
class SupportCustomCell: UITableViewCell {
    
    //MARK: - Variables
    var supportOptionLabel : UILabel!
    var moreImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //supportOptionLabel
        supportOptionLabel = UILabel(frame: CGRect(x: 0,y: 0,width: screenWidth-30,height: 60))
        supportOptionLabel.backgroundColor = UIColor.white
        supportOptionLabel.textColor = UIColor.black
        supportOptionLabel.textAlignment = .right
        supportOptionLabel.font = FONT_NORMAL(13)
        supportOptionLabel.adjustsFontSizeToFitWidth = true
        supportOptionLabel.minimumScaleFactor = 0.5
        contentView.addSubview(supportOptionLabel)
        
        //more Image View
        moreImageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 30, height: 30))
        moreImageView.contentMode = .scaleAspectFit
        moreImageView.image = UIImage(named: "ratingBack")
        contentView.addSubview(moreImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


