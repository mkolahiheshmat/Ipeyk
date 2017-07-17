//
//  RatingCustomCell.swift
//  PeikYab
//
//  Created by Developer on 9/19/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class RatingCustomCell: UITableViewCell{
    
    //MARK: - Variables
    var circleImage = UIImageView()
    var ratingLabel = UILabel()
    var avataImage = UIImageView()
    var lineView : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //ratingLabel = UILabel(frame: CGRectMake(40,20,screenWidth-80,60))
        ratingLabel.backgroundColor = UIColor.white
        ratingLabel.textColor = UIColor.black
        ratingLabel.font = FONT_MEDIUM(13)
        ratingLabel.text = NSLocalizedString("ratingDetailMessage", comment: "")
        ratingLabel.numberOfLines = 2
        ratingLabel.textAlignment = .right
        ratingLabel.adjustsFontSizeToFitWidth = true
        ratingLabel.minimumScaleFactor = 0.3
        
        lineView = UIView(frame: CGRect(x: 60,y: ratingLabel.frame.origin.y+ratingLabel.frame.size.height+65,width: screenWidth-110,height: 2))
        lineView.backgroundColor = grayColor
        contentView.addSubview(lineView)
        
        self.contentView.addSubview(circleImage)
        self.contentView.addSubview(ratingLabel)
        self.contentView.addSubview(avataImage)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - layoutSubViews
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImage.frame = CGRect(x:screenWidth - 40,y: 10,width:30,height:30)
        ratingLabel.frame = CGRect(x: 65, y: 0, width: screenWidth-110, height:60)
        avataImage.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
    }
}
