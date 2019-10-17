//
//  PresetsTests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/17/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class PresetsTests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
    }

    func testWhenNewBarButtonItemTappedThenNavigateToNewPreset() {
        app.navigationBars["Presets"].buttons["newBarButtonItem"].tap()
        XCTAssertTrue(app.navigationBars["TimesUp.NewPresetView"].exists)
    }
    
    func testWhenPresetTappedThenNavigationToTimer() {
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars["TimesUp.TimerView"].exists)
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
        for i in 0..<10 {
            let cell = app.tables.cells.element(boundBy: i)
            XCTAssertEqual(cell.staticTexts["nameLabel"].label, String(format: "%02d minutes", i + 1))
            XCTAssertEqual(cell.staticTexts["durationLabel"].label, String(format: "00:%02d:00", i + 1))
        }
    }
}
