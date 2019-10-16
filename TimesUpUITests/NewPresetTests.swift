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
        app.textFields["nameTextField"].tap()
        app.textFields["nameTextField"].typeText("Test")
        app.buttons["Done"].tap()
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameEmptyAndDurationNotEmptyThenDisableSaveButton() {
        app.pickers["durationPicker"].pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "01")
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }
    
    func testWhenNameNotEmptyAndDurationNotEmptyThenEnableSaveButton() {
        app.textFields["nameTextField"].tap()
        app.textFields["nameTextField"].typeText("Test")
        app.buttons["Done"].tap()
        app.pickers["durationPicker"].pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "01")
        XCTAssertTrue(app.buttons["Save"].isEnabled)
    }
    
    func testGivenSaveButtonEnabledWhenClickedThenSave() {
        app.textFields["nameTextField"].tap()
        app.textFields["nameTextField"].typeText("Test")
        app.buttons["Done"].tap()
        app.pickers["durationPicker"].pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "01")
        app.buttons["Save"].tap()
        XCTAssertTrue(app.tables.cells.staticTexts["Test"].exists)
    }
}
