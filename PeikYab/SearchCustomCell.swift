//
//  SearchCustomCell.swift
//  PeikYab
//
//  Created by Developer on 10/26/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
class SearchCustomCell: UITableViewCell {
    
    //MARK: - Variables
    var starImageView:UIImageView!
    var favAddressNameLabel : UILabel!
    var favAddressLabel : UILabel!
    var searchAddressNameLabel : UILabel!
    var searchAddressLabel : UILabel!
    var searchMarkerImageView:UIImageView!
    
    var moreImageView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        starImageView = UIImageView(frame: CGRect(x: screenWidth-50,y: 40, width: 30, height: 30))
        starImageView.image = UIImage(named: "favStarImage")
        starImageView.contentMode = .scaleAspectFit
        contentView.addSubview(starImageView)
        
        //favAddressNameLabel
       favAddressNameLabel = UILabel(frame: CGRect(x: screenWidth-180,y: 20,width: 100,height: 30))
       favAddressNameLabel.backgroundColor = UIColor.white
       favAddressNameLabel.textColor = topViewBlue
       favAddressNameLabel.textAlignment = .right
       favAddressNameLabel.font = FONT_NORMAL(15)
       favAddressNameLabel.adjustsFontSizeToFitWidth = true
       favAddressNameLabel.minimumScaleFactor = 0.5
        contentView.addSubview(favAddressNameLabel)
        
        //favAddressLabel
        favAddressLabel = UILabel(frame: CGRect(x: screenWidth-280,y: favAddressNameLabel.frame.origin.y+favAddressNameLabel.frame.size.height+10,width: 200,height: 30))
        favAddressLabel.backgroundColor = UIColor.white
        favAddressLabel.textColor = UIColor.gray
        favAddressLabel.textAlignment = .right
        favAddressLabel.font = FONT_NORMAL(11)
        favAddressLabel.adjustsFontSizeToFitWidth = true
        favAddressLabel.minimumScaleFactor = 0.5
        contentView.addSubview(favAddressLabel)
        
        //searchAddressNameLabel
        searchAddressNameLabel = UILabel(frame: CGRect(x: 10,y: 20,width: screenWidth - 20,height: 30))
        searchAddressNameLabel.backgroundColor = UIColor.white
        searchAddressNameLabel.textColor = topViewBlue
        searchAddressNameLabel.textAlignment = .right
        searchAddressNameLabel.font = FONT_NORMAL(15)
        searchAddressNameLabel.adjustsFontSizeToFitWidth = true
        searchAddressNameLabel.minimumScaleFactor = 0.5
        contentView.addSubview(searchAddressNameLabel)
        
        //searchAddressLabel
        searchAddressLabel = UILabel(frame: CGRect(x: 10,y: searchAddressNameLabel.frame.origin.y+searchAddressNameLabel.frame.size.height,width: screenWidth - 20,height: 30))
        searchAddressLabel.backgroundColor = UIColor.white
        searchAddressLabel.textColor = UIColor.gray
        searchAddressLabel.textAlignment = .right
        searchAddressLabel.font = FONT_NORMAL(11)
        searchAddressLabel.adjustsFontSizeToFitWidth = true
        searchAddressLabel.minimumScaleFactor = 0.5
        contentView.addSubview(searchAddressLabel)
        
        // more Image View
        searchMarkerImageView = UIImageView(frame: CGRect(x: 20, y: 40, width: 30, height: 30))
        searchMarkerImageView.contentMode = .scaleAspectFit
        searchMarkerImageView.image = UIImage(named: "searchMarker")
        contentView.addSubview(searchMarkerImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

