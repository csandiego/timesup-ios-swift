//
//  EditPresetTests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/16/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class EditPresetTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.tables.cells.element(boundBy: 0).tap()
        app.navigationBars["TimesUp.TimerView"].buttons["Edit"].tap()
    }

    func testWhenNameEmptyAndDurationEmptyThenDisableSaveButton() {
        app.textFields.element(boundBy: 0).tap()
        app.buttons["Clear text"].tap()
        app.buttons["Done"].tap()
        app.pickerWheels.element(boundBy: 0).swipeDown()
        app.pickerWheels.element(boundBy: 1).swipeDown()
        app.pickerWheels.element(boundBy: 2).swipeDown()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }

    func testWhenNameNotEmptyAndDurationEmptyThenDisableSaveButton() {
        app.pickerWheels.element(boundBy: 0).swipeDown()
        app.pickerWheels.element(boundBy: 1).swipeDown()
        app.pickerWheels.element(boundBy: 2).swipeDown()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameEmptyAndDurationNotEmptyThenDisableSaveButton() {
        app.textFields.element(boundBy: 0).tap()
        app.buttons["Clear text"].tap()
        app.buttons["Done"].tap()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameNotEmptyAndDurationNotEmptyThenEnableSaveButton() {
        XCTAssertTrue(app.buttons["Save"].isEnabled)
    }
    
    func testGivenSaveButtonEnabledWhenClickedThenSave() {
        let value = app.textFields.element(boundBy: 0).value as! String
        app.textFields.element(boundBy: 0).tap()
        app.textFields.element(boundBy: 0).typeText("Test")
        app.buttons["Done"].tap()
        app.buttons["Save"].tap()
        XCTAssertTrue(app.staticTexts[value + "Test"].exists)
    }
}
