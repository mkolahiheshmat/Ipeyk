//
//  MenuCustomCell.swift
//  NewPeikyab
//
//  Created by Developer on 9/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
class MenuCustomCell: UITableViewCell {
    
    //MARK: - Variables
    var menuLabel : UILabel!
    //var menuImage : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        menuLabel = UILabel()
        //menuImage = UIImageView()
        
        menuLabel.textAlignment = .right
        menuLabel.font = FONT_MEDIUM(15)
        menuLabel.textColor = UIColor.black
        self.contentView.addSubview(menuLabel)
        //self.contentView.addSubview(menuImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        menuLabel.frame = CGRect(x: 10, y: 10, width: screenWidth-40, height:25)
       // menuImage.frame = CGRect(x:screenWidth - 55,y: 10,width:25,height:25)
    }
}

