//
//  TimerTests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/17/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class TimerTests: XCTestCase {
    
    var app: XCUIApplication!
    
    let preset = (
        name: "01 minutes",
        hours: 0,
        minutes: 1,
        seconds: 0
    )

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.tables.cells.element(boundBy: 0).tap()
    }

    func testWhenLoadedThenShowDetails() {
        XCTAssertEqual(app.staticTexts["nameLabel"].label, preset.name)
        XCTAssertEqual(app.staticTexts["durationLabel"].label, String(format: "%02d:%02d:%02d", preset.hours, preset.minutes, preset.seconds))
    }
}
