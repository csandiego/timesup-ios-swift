//
//  PresetsUITests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/17/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class PresetsUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
    }

    func testWhenNewBarButtonItemTappedThenNavigateToNewPreset() {
        app.toolbars["Toolbar"].buttons["newBarButtonItem"].tap()
        XCTAssertTrue(app.navigationBars["TimesUp.NewPresetView"].exists)
    }
    
    func testGivenNotInEditModeWhenPresetTappedThenNavigateToTimer() {
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["TimesUp.TimerView"].exists)
    }
    
    func testGivenInEditModeWhenPresetTappedThenNavigateToEditPreset() {
        app.navigationBars["Presets"].buttons["Edit"].tap()
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["TimesUp.EditPresetView"].exists)
    }
    
    func testWhenPresetSwipeLeftThenShowSwipeActions() {
        let cell = app.tables.cells.element(boundBy: 0)
        cell.swipeLeft()
        XCTAssertTrue(cell.buttons["Delete"].isEnabled)
    }
    
    func testWhenPresetDeletedThenRemoveFromList() {
        let cell = app.tables.cells.element(boundBy: 0)
        cell.swipeLeft()
        cell.buttons["Delete"].tap()
        XCTAssertEqual(app.tables.cells.count, 9)
    }
    
    func testWhenLoadedThenDisplayByNameAscending() {
        var data: [(name: String, hours: Int, minutes: Int, seconds: Int)] = []
        for i in 1...9 {
            data += [(name: String(format: "%02d minutes", i), hours: 0, minutes: i, seconds: 0)]
        }
        data.insert((name: "02 seconds", hours: 0, minutes: 0, seconds: 2), at: 2)
        for (i, preset) in data.enumerated() {
            let cell = app.tables.cells.element(boundBy: i)
            XCTAssertEqual(cell.staticTexts["nameLabel"].label, preset.name)
            XCTAssertEqual(cell.staticTexts["durationLabel"].label, String(format: "%02d:%02d:%02d", preset.hours, preset.minutes, preset.seconds))
        }
    }
}
