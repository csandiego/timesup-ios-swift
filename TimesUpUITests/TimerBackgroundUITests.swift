//
//  TimerBackgroundUITests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/23/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class TimerBackgroundUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.tables.cells.element(boundBy: 0).tap()
    }
    
    func testGivenStartedWhenDidEnterBackgroundAndDidBecomeActiveThenResume() {
        app.buttons["startButton"].tap()
        let expectation = self.expectation(description: "Activate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCUIDevice.shared.press(.home)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.app.activate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    XCTAssertEqual(self.app.staticTexts["durationLabel"].label, "00:00:58")
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
