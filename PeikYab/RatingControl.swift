//
//  RatingControl.swift
//  PeikYab
//
//  Created by Developer on 9/18/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    var selectedButtonIndex = 0
    
    //MARK: -  Properties
    var rating = 0{
        didSet{
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    
    var spacing = 5
    var stars = 5
    
    //MARK: -  Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        //super.init(frame:CGRect(x: 20,y: 20, width: 200, height: 50))
        //if
        let emoji1On = UIImage(named:"emoji1on")
        
        let emoji1Off = UIImage(named: "emoji1off")
        
        let emoji2On = UIImage(named:"emoji2on")
        
        let emoji2Off = UIImage(named: "emoji2off")
        
        let emoji3On = UIImage(named:"emoji3on")
        
        let emoji3Off = UIImage(named: "emoji3off")
        
        let emoji4On = UIImage(named:"emoji4on")
        
        let emoji4Off = UIImage(named: "emoji4off")
        
        let emoji5On = UIImage(named:"emoji5on")
        
        let emoji5Off = UIImage(named: "emoji5off")
        
        //for _ in 0..<stars
        //  {
        
        let button1 = UIButton()
        button1.setImage(emoji5Off , for: UIControlState() )
        button1.setImage(emoji5On, for: .selected)
        button1.setImage(emoji5On, for:[.highlighted,.selected])
        button1.adjustsImageWhenHighlighted = false
        button1.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)),
                          for: .touchDown)
        button1.tag = 5
        ratingButtons+=[button1]
        addSubview(button1)
        
        let button2 = UIButton()
        button2.setImage(emoji4Off , for: UIControlState() )
        button2.setImage(emoji4On, for: .selected)
        button2.setImage(emoji4On, for:[.highlighted,.selected])
        button2.adjustsImageWhenHighlighted = false
        button2.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)),
                          for: .touchDown)
        button2.tag = 4
        ratingButtons+=[button2]
        addSubview(button2)
        
        let button3 = UIButton()
        button3.setImage(emoji3Off , for: UIControlState() )
        button3.setImage(emoji3On, for: .selected)
        button3.setImage(emoji3On, for:[.highlighted,.selected])
        button3.adjustsImageWhenHighlighted = false
        button3.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)),
                          for: .touchDown)
        button3.tag = 3
        ratingButtons+=[button3]
        addSubview(button3)
        
        let button4 = UIButton()
        button4.setImage(emoji2Off , for: UIControlState() )
        button4.setImage(emoji2On, for: .selected)
        button4.setImage(emoji2On, for:[.highlighted,.selected])
        button4.adjustsImageWhenHighlighted = false
        button4.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)),
                          for: .touchDown)
        button4.tag = 2
        ratingButtons+=[button4]
        addSubview(button4)
        
        let button5 = UIButton()
        button5.setImage(emoji1Off , for: UIControlState() )
        button5.setImage(emoji1On, for: .selected)
        button5.setImage(emoji1On, for:[.highlighted,.selected])
        button5.adjustsImageWhenHighlighted = false
        button5.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)),
                          for: .touchDown)
        button5.tag = 1
        ratingButtons+=[button5]
        addSubview(button5)
        
        
        //}
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: -  Layout SubViews
    override func layoutSubviews() {
        //set the button 's height and width to a square the size of the frame 's height
        let buttonSize = Int(frame.size.height)
        var buttonFrame=CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        //offset each button 's origin by the length of the button plus spacing
        
        var mySpace:CGFloat = (screenWidth)/CGFloat(16.0)
        
        if DeviceType.IS_IPHONE_5{
            mySpace = (screenWidth)/CGFloat(50.0)
        }
        for(index,button) in ratingButtons.enumerated()
        {
            buttonFrame.origin.x=CGFloat(CGFloat(index)*(CGFloat(buttonSize) + mySpace))
            button.frame=buttonFrame
        }
        updateButtonSelectionStates()
    }
    //MARK: -  intrinsicContentSize
    
    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing)*stars
        return CGSize(width: width, height: buttonSize)
    }
    
    //MARK: -  Custom Methods
    
    //Button Action
    
    func ratingButtonTapped(_ button:UIButton){
        
        rating=ratingButtons.index(of: button)!+1
        
        selectedButtonIndex = rating
        
        print("Rating:\(rating)")
        
        switch rating{
        case 1:
            rating = 5
            break
        case 2:
            rating = 4
            break
        case 3:
            rating = 3
            break
        case 4:
            rating = 2
            break
        case 5:
            rating = 1
            break
        default:
            rating = 0
            break
        }
        
        //rating = button.tag
        
        let notificationName = Notification.Name("ratingControlDidChanged")
        NotificationCenter.default.post(name: notificationName, object: rating)
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates(){
        for (index,button) in ratingButtons.enumerated()
        {
            //if index of the button is less than the rating that button should be selected
            button.isSelected = index+1==selectedButtonIndex
        }
    }
    
}
