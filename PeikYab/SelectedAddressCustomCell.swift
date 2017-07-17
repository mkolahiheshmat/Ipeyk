//
//  SelectedAddressCustomCell.swift
//  PeikYab
//
//  Created by Developer on 9/24/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class SelectedAddressCustomCell: UITableViewCell,UITextFieldDelegate {
    
    //MARK: - Variables
    var popupView:UIView!
    var popupButton :UIButton!
    var nameLabel : UILabel!
    var addressLabel : UILabel!
    var neighborhoodLabel : UILabel!
    var selectAsDesButton:UIButton!
    var lineView:UIView!
    var markerImageView:UIImageView!
    
    var tapGesture:UITapGestureRecognizer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        popupView = UIView(frame: CGRect(x: 5,y: 5,width: screenWidth-10,height: 163))
        popupView.backgroundColor = whiteColor
        //popupView.layer.cornerRadius = 20
        popupView.layer.shadowColor = UIColor.lightGray.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popupView.layer.shadowRadius = 0
        contentView.addSubview(popupView)
        
        popupButton = makeButton(frame: CGRect(x: popupView.frame.size.width-40, y: 0, width: 40, height: 40), backImageName: "threeDot", backColor:tripIDLabelColor, title: nil, titleColor: whiteColor, isRounded: false)
        popupView.addSubview(popupButton)
        
        //name Label
        nameLabel = UILabel(frame: CGRect(x: 0,y: 0,width: popupButton.frame.origin.x,height: 40))
        nameLabel.backgroundColor = tripIDLabelColor
        //nameLabel.layer.cornerRadius = 20
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .right
        nameLabel.font = FONT_NORMAL(13)
        popupView.addSubview(nameLabel)
        
        //neighborhood Label
        neighborhoodLabel = UILabel(frame: CGRect(x: 0,y: nameLabel.frame.origin.y+40,width: popupView.frame.size.width-35,height: 40))
        neighborhoodLabel.backgroundColor = UIColor.white
        neighborhoodLabel.textColor = UIColor.black
        neighborhoodLabel.font = FONT_NORMAL(13)
        neighborhoodLabel.numberOfLines = 1
        neighborhoodLabel.textAlignment = .right
        neighborhoodLabel.adjustsFontSizeToFitWidth = true
        neighborhoodLabel.minimumScaleFactor = 0.5
        popupView.addSubview(neighborhoodLabel)
        
        lineView = UIView(frame: CGRect(x: neighborhoodLabel.frame.origin.x+5,y: neighborhoodLabel.frame.origin.y+42,width: neighborhoodLabel.frame.size.width-10,height: 1))
        lineView.backgroundColor = lineViewColor
        popupView.addSubview(lineView)
        
        //Driver Image
        markerImageView = UIImageView(frame: CGRect(x: popupView.frame.size.width-25,y: neighborhoodLabel.frame.origin.y+58, width: 15, height: 15))
        markerImageView.image = UIImage(named: "favouriteMarker")
        markerImageView.contentMode = .scaleAspectFit
        popupView.addSubview(markerImageView)
        
        //address Label
        addressLabel = UILabel(frame: CGRect(x: 5,y: neighborhoodLabel.frame.origin.y+43,width: popupView.frame.size.width-35,height: 40))
        addressLabel.backgroundColor = UIColor.white
        addressLabel.textColor = UIColor.black
        addressLabel.font = FONT_NORMAL(13)
        addressLabel.numberOfLines = 1
        addressLabel.textAlignment = .right
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.minimumScaleFactor = 0.5
        popupView.addSubview(addressLabel)
        
        //Select as Dest OR Origin Button
        selectAsDesButton = makeButton(frame: CGRect(x: 0, y: addressLabel.frame.origin.y+addressLabel.frame.size.height, width: popupView.frame.size.width, height: 40), backImageName: nil, backColor: greenColor, title: NSLocalizedString("selectAsDest", comment: ""), titleColor: whiteColor, isRounded: false)
        //selectAsDesButton.layer.cornerRadius = 20
        
        popupView.addSubview(selectAsDesButton)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
