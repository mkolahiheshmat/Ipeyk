//
//  TurnoverCustomCell.swift
//  PeikYab
//
//  Created by Developer on 9/17/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class TurnoverCustomCell: UITableViewCell {
    
    //MARK: - Variables
    var creditConditionLabel : UILabel!
    var creditPriceLabel : UILabel!
    var priceLabel:UILabel!
    var priceAmountLabel:UILabel!
    var descriptionLabel :UILabel!
    var descriptionTextLabel : UILabel!
    var driverLabel:UILabel!
    var driverNameLabel :UILabel!
    var dateTimeLabel :UILabel!
    var lineView : UIView!
    var turnoverCellImage:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        turnoverCellImage = UIImageView(frame: CGRect(x: screenWidth-38,y: 35, width: 30, height: 30))
        turnoverCellImage.image = UIImage(named: "turnoverCellImage")
        turnoverCellImage.contentMode = .scaleAspectFit
        contentView.addSubview(turnoverCellImage)
        
        //creditConditionLabel
        creditConditionLabel = UILabel(frame: CGRect(x: screenWidth-160,y: 5,width: 100,height: 30))
        creditConditionLabel.backgroundColor = UIColor.white
        creditConditionLabel.textColor = UIColor.gray
        creditConditionLabel.font = FONT_MEDIUM(13)
        creditConditionLabel.numberOfLines = 1
        creditConditionLabel.textAlignment = .right
        creditConditionLabel.adjustsFontSizeToFitWidth = true
        creditConditionLabel.minimumScaleFactor = 0.5
        contentView.addSubview(creditConditionLabel)
        
        //price Amount Label
        priceAmountLabel = UILabel(frame: CGRect(x: creditConditionLabel.frame.origin.x,y: creditConditionLabel.frame.origin.y+creditConditionLabel.frame.size.height,width: 100,height: 30))
        priceAmountLabel.backgroundColor = UIColor.white
        //priceAmountLabel.textColor = topViewBlue
        priceAmountLabel.font = FONT_MEDIUM(13)
        priceAmountLabel.numberOfLines = 1
        priceAmountLabel.textAlignment = .right
        priceAmountLabel.adjustsFontSizeToFitWidth = true
        priceAmountLabel.minimumScaleFactor = 0.5
        contentView.addSubview(priceAmountLabel)
        
        //Date & Time Label
        dateTimeLabel = UILabel(frame: CGRect(x: 20,y: priceAmountLabel.frame.origin.y,width: creditConditionLabel.frame.origin.x-20,height: 30))
        dateTimeLabel.backgroundColor = UIColor.white
        dateTimeLabel.textColor = UIColor.gray
        dateTimeLabel.font = FONT_MEDIUM(13)
        dateTimeLabel.numberOfLines = 1
        dateTimeLabel.textAlignment = .center
        dateTimeLabel.adjustsFontSizeToFitWidth = true
        dateTimeLabel.minimumScaleFactor = 0.5
        contentView.addSubview(dateTimeLabel)
        
        //Description Text Label
        descriptionTextLabel = UILabel(frame: CGRect(x: 0,y: priceAmountLabel.frame.origin.y+priceAmountLabel.frame.size.height,width: screenWidth-60,height: 30))
        descriptionTextLabel.backgroundColor = UIColor.white
        descriptionTextLabel.textColor = UIColor.gray
        descriptionTextLabel.font = FONT_MEDIUM(13)
        descriptionTextLabel.numberOfLines = 1
        descriptionTextLabel.textAlignment = .right
        descriptionTextLabel.adjustsFontSizeToFitWidth = true
        descriptionTextLabel.minimumScaleFactor = 0.5
        contentView.addSubview( descriptionTextLabel)
        
        //Line View
        lineView = UIView(frame: CGRect(x: 0,y: descriptionTextLabel.frame.origin.y+descriptionTextLabel.frame.size.height+5,width: screenWidth,height: 1))
        lineView.backgroundColor = UIColor.gray
        contentView.addSubview(lineView)

       /*
        //creditPriceLabel
        creditPriceLabel = UILabel(frame: CGRect(x: 0,y: creditConditionLabel.frame.origin.y,width: screenWidth-120,height: 40))
        creditPriceLabel.backgroundColor = UIColor.white
        creditPriceLabel.textColor = labelTextColor
        creditPriceLabel.font = FONT_NORMAL(20)
        creditPriceLabel.numberOfLines = 1
        creditPriceLabel.textAlignment = .center
        creditPriceLabel.adjustsFontSizeToFitWidth = true
        creditPriceLabel.minimumScaleFactor = 0.5
        contentView.addSubview(creditPriceLabel)

        //Price Label
        priceLabel = UILabel(frame: CGRect(x: screenWidth-70,y: priceAmountLabel.frame.origin.y,width: 50,height: 40))
        priceLabel.backgroundColor = UIColor.white
        priceLabel.textColor = topViewBlue
        priceLabel.font = FONT_NORMAL(20)
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        contentView.addSubview(priceLabel)
       
        //Description Label
        descriptionLabel = UILabel(frame: CGRect(x: screenWidth-70,y: priceLabel.frame.origin.y+priceLabel.frame.size.height,width: 50,height: 40))
        descriptionLabel.backgroundColor = UIColor.white
        descriptionLabel.textColor = grayColor
        descriptionLabel.font = FONT_NORMAL(20)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textAlignment = .right
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        contentView.addSubview(descriptionLabel)
 */
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
