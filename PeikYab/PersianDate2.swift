//
//  Calendar.swift
//  PeikYab
//
//  Created by Yarima on 10/3/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation


func convertToPersianDate2(gregorianDate:Date) -> String {
    let gregorian = Calendar(identifier: .gregorian)
    let persian = Calendar(identifier: .persian)
    
    let gregorianComponents = gregorian.dateComponents([.year, .month, .day], from: gregorianDate)
    let persianDate:Date = persian.date(from: gregorianComponents)!
    let persianComponents = gregorian.dateComponents([.year, .month, .day], from: persianDate)
    return "\(persianComponents.year)" + " " + "\(persianComponents.month)" + " " + "\(persianComponents.day)"
}
