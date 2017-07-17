//
//  ScreenSize.swift
//  PeikYab
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

let screenSize: CGRect = UIScreen.main.bounds

let screenWidth = screenSize.width

let screenHeight = screenSize.height

let screenMaxLength   = max(screenWidth, screenHeight)
let screenMinLength    = min(screenWidth, screenWidth)

enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && screenMaxLength < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && screenMaxLength == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && screenMaxLength == 667.0
    static  let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && screenMaxLength == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad   && screenMaxLength == 1024.0
}
