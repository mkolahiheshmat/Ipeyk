//
//  String+EmailValidation.swift
//  PeikYab
//
//  Created by Developer on 9/13/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
//    var isPhoneNumber: Bool {
//        
//        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
//        var filtered:NSString!
//        let inputString = self.components(separatedBy: charcter)
//        filtered = inputString.componentsJoined(by: "") as NSString!
//        return (self == filtered as String)
//        
//    }
}
