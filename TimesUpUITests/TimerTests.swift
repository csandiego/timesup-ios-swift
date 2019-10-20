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
    
    func testWhenStartedThenUpdateDuration() {
        app.buttons["startButton"].tap()
        let expectation = self.expectation(description: "Update duration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.app.staticTexts["durationLabel"].label, "00:00:59")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testWhenLoadedThenOnlyEnableStartButton() {
        XCTAssertTrue(app.buttons["startButton"].isEnabled)
        XCTAssertFalse(app.buttons["pauseButton"].isEnabled)
        XCTAssertFalse(app.buttons["resetButton"].isEnabled)
    }
    
    func testWhenStartThenOnlyEnablePauseButton() {
        app.buttons["startButton"].tap()
        XCTAssertFalse(app.buttons["startButton"].isEnabled)
        XCTAssertTrue(app.buttons["pauseButton"].isEnabled)
        XCTAssertFalse(app.buttons["resetButton"].isEnabled)
    }
    
    func testWhenPausedThenOnlyDisablePauseButton() {
        app.buttons["startButton"].tap()
        app.buttons["pauseButton"].tap()
        XCTAssertTrue(app.buttons["startButton"].isEnabled)
        XCTAssertFalse(app.buttons["pauseButton"].isEnabled)
        XCTAssertTrue(app.buttons["resetButton"].isEnabled)
    }
    
    func testWhenResetThenUpdateDuration() {
        app.buttons["startButton"].tap()
        let expectation = self.expectation(description: "Update duration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.app.buttons["pauseButton"].tap()
            self.app.buttons["resetButton"].tap()
            XCTAssertEqual(self.app.staticTexts["durationLabel"].label, "00:01:00")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testWhenResetThenOnlyEnableStartButton() {
        app.buttons["startButton"].tap()
        app.buttons["pauseButton"].tap()
        app.buttons["resetButton"].tap()
        XCTAssertTrue(app.buttons["startButton"].isEnabled)
        XCTAssertFalse(app.buttons["pauseButton"].isEnabled)
        XCTAssertFalse(app.buttons["resetButton"].isEnabled)
    }
}
