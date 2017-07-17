//
//  UIView+Extension.swift
//  Elbbbird
//
//  Created by Arash Z. Jahangiri on 19/03/2016.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setCircular() {
        setCornerRadius(cornerRadius: frame.size.width / 2)
    }
    
    func setCornerRadius(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
    
