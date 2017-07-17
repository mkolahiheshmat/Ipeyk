//
//  NSUserDefaults+isFirstLaunch.swift
//  PeikYab
//
//  Created by Developer on 9/21/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
