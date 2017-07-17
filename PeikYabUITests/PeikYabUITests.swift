//
//  PeikYabUITests.swift
//  PeikYabUITests
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import XCTest
class PeikYabUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            
            let exists = NSPredicate(format: "exists == 1")
            /*
             let myString = "شما در حالت آفلاین هستید. ابتدا آیفون را به اینترنت متصل کنید."
             
             let label = app.staticTexts[myString]
             expectationForPredicate(exists, evaluatedWithObject: label, handler: nil)
             waitForExpectationsWithTimeout(5) { error in
             if error != nil {
             assertionFailure("error")
             }
             }
             */
            
            XCUIApplication().buttons["push me"].tap()
            let myString2 = "My name is Arash "
            let label2 = app.staticTexts[myString2]
            expectation(for: exists, evaluatedWith: label2, handler: nil)
            waitForExpectations(timeout: 5) { error in
                if error != nil {
                    assertionFailure("error")
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
        //        XCTAssert(app.staticTexts["Label"].exists)
        //        app.buttons["Button"].tap()
        //        XCTAssert(app.staticTexts["Hello"].exists)
    }
    
}
