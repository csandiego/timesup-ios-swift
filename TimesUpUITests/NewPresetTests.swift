//
//  NewPresetTests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/15/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class NewPresetTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.navigationBars["Presets"].buttons["New"].tap()
    }

    func testWhenNameEmptyAndDurationEmptyThenDisableSaveButton() {
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }

    func testWhenNameNotEmptyAndDurationEmptyThenDisableSaveButton() {
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test")
        app.buttons["Done"].tap()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameEmptyAndDurationNotEmptyThenDisableSaveButton() {
        app.pickers.children(matching: .pickerWheel).matching(identifier: "00").element(boundBy: 1).swipeUp()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameNotEmptyAndDurationNotEmptyThenEnableSaveButton() {
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test")
        app.buttons["Done"].tap()
        app.pickers.children(matching: .pickerWheel).matching(identifier: "00").element(boundBy: 1).swipeUp()
        XCTAssertTrue(app.buttons["Save"].isEnabled)
    }
    
    func testGivenSaveButtonEnabledWhenClickedThenSave() {
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test")
        app.buttons["Done"].tap()
        app.pickers.children(matching: .pickerWheel).matching(identifier: "00").element(boundBy: 1).swipeUp()
        app.buttons["Save"].tap()
        XCTAssertTrue(app.tables.cells.staticTexts["Test"].exists)
    }
}
