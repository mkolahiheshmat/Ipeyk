//
//  CustomeTableViewCell.swift
//  NewPeikyab
//
//  Created by Developer on 9/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class TripsCustomCell: UITableViewCell{
    
    //MARK: - Variables
    var tripIDLabel : UILabel!
    var pathImage : UIImageView!
    var sourceLabel : UILabel!
    var sourceAddressLabel : UILabel!
    var destinationLabel :UILabel!
    var destinationAddressLabel : UILabel!
    var tripStatus:UILabel!
    var tripStatusDescLabel :UILabel!
    var priceLabel : UILabel!
    var dateTimeLabel :UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //TripIDLabel
        tripIDLabel = UILabel(frame: CGRect(x: 0,y: 0,width: screenWidth,height: 30))
        tripIDLabel.backgroundColor = tripIDLabelColor
        tripIDLabel.textColor = UIColor.white
        tripIDLabel.textAlignment = .center
        tripIDLabel.font = FONT_MEDIUM(13)
        contentView.addSubview(tripIDLabel)
        
        //Path Image
        pathImage = UIImageView(frame: CGRect(x: 0,y: 40, width: screenWidth, height: 80))
        // pathImage.backgroundColor = UIColor.greenColor()
        pathImage.image = UIImage(named: "Path1.png")
        pathImage.contentMode = .scaleAspectFit
        contentView.addSubview(pathImage)
        
        //Source Label
        sourceLabel = UILabel(frame: CGRect(x: screenWidth-70,y: pathImage.frame.origin.y+pathImage.frame.size.height,width: 50,height: 30))
        sourceLabel.backgroundColor = UIColor.white
        sourceLabel.textColor = topViewBlue
        sourceLabel.font = FONT_MEDIUM(13)
        sourceLabel.numberOfLines = 1
        sourceLabel.textAlignment = .right
        sourceLabel.adjustsFontSizeToFitWidth = false
        sourceLabel.minimumScaleFactor = 0.5
        contentView.addSubview(sourceLabel)
        
        //Source Address Label
        sourceAddressLabel = UILabel(frame: CGRect(x:0,y: pathImage.frame.origin.y+pathImage.frame.size.height,width: screenWidth-70,height: 30))
        sourceAddressLabel.backgroundColor = UIColor.white
        sourceAddressLabel.textColor = UIColor.gray
        sourceAddressLabel.font = FONT_MEDIUM(13)
        sourceAddressLabel.numberOfLines = 1
        sourceAddressLabel.textAlignment = .right
        sourceAddressLabel.adjustsFontSizeToFitWidth = true
        sourceAddressLabel.minimumScaleFactor = 0.5
        contentView.addSubview(sourceAddressLabel)
        
        //destination Label
        destinationLabel = UILabel(frame: CGRect(x: screenWidth-70,y: sourceLabel.frame.origin.y+sourceLabel.frame.size.height,width: 50,height: 30))
        destinationLabel.backgroundColor = UIColor.white
        destinationLabel.textColor = topViewBlue
        destinationLabel.font = FONT_MEDIUM(13)
        destinationLabel.numberOfLines = 1
        destinationLabel.textAlignment = .right
        destinationLabel.adjustsFontSizeToFitWidth = true
        destinationLabel.minimumScaleFactor = 0.5
        contentView.addSubview(destinationLabel)
        
        //Destination Address Label
        destinationAddressLabel = UILabel(frame: CGRect(x: 0,y: sourceLabel.frame.origin.y+sourceLabel.frame.size.height,width: screenWidth-70,height: 30))
        destinationAddressLabel.backgroundColor = UIColor.white
        destinationAddressLabel.textColor = UIColor.gray
        destinationAddressLabel.font = FONT_MEDIUM(13)
        destinationAddressLabel.numberOfLines = 1
        destinationAddressLabel.textAlignment = .right
        destinationAddressLabel.adjustsFontSizeToFitWidth = true
        destinationAddressLabel.minimumScaleFactor = 0.5
        contentView.addSubview(destinationAddressLabel)
        
        //Driver Label
        tripStatus = UILabel(frame: CGRect(x: screenWidth-100,y: destinationLabel.frame.origin.y+destinationLabel.frame.size.height,width: 80,height: 30))
        tripStatus.backgroundColor = UIColor.white
        tripStatus.textColor = topViewBlue
        tripStatus.font = FONT_MEDIUM(13)
        tripStatus.numberOfLines = 1
        tripStatus.textAlignment = .right
        tripStatus.adjustsFontSizeToFitWidth = true
        tripStatus.minimumScaleFactor = 0.5
        contentView.addSubview(tripStatus)
        
        //Driver Name Label
        tripStatusDescLabel = UILabel(frame: CGRect(x: 0,y: destinationLabel.frame.origin.y+destinationLabel.frame.size.height,width: screenWidth-100,height: 30))
        tripStatusDescLabel.backgroundColor = UIColor.white
        tripStatusDescLabel.textColor = UIColor.gray
        tripStatusDescLabel.font = FONT_MEDIUM(13)
        tripStatusDescLabel.numberOfLines = 1
        tripStatusDescLabel.textAlignment = .right
        tripStatusDescLabel.adjustsFontSizeToFitWidth = true
        tripStatusDescLabel.minimumScaleFactor = 0.5
        contentView.addSubview(tripStatusDescLabel)
        
        //Price Label
        priceLabel = UILabel(frame: CGRect(x:screenWidth-120,y: tripStatus.frame.origin.y+tripStatus.frame.size.height,width: 100,height: 30))
        priceLabel.backgroundColor = UIColor.white
        priceLabel.textColor = UIColor.gray
        priceLabel.font = FONT_MEDIUM(13)
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        contentView.addSubview(priceLabel)
        
        //Date & Time of Trip
        dateTimeLabel = UILabel(frame: CGRect(x: 20,y: tripStatusDescLabel.frame.origin.y+tripStatusDescLabel.frame.size.height,width: screenWidth-120,height: 30))
        dateTimeLabel.backgroundColor = UIColor.white
        dateTimeLabel.textColor = UIColor.gray
        dateTimeLabel.font = FONT_MEDIUM(13)
        dateTimeLabel.numberOfLines = 1
        dateTimeLabel.textAlignment = .left
        dateTimeLabel.adjustsFontSizeToFitWidth = true
        dateTimeLabel.minimumScaleFactor = 0.5
        contentView.addSubview(dateTimeLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
