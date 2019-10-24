//
//  NewPresetUITests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/15/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class NewPresetUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let preset = (
        name: "01 second",
        hours: 0,
        minutes: 0,
        seconds: 1
    )

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.toolbars["Toolbar"].buttons["newBarButtonItem"].tap()
    }

    func testWhenNameEmptyAndDurationEmptyThenDisableSaveButton() {
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }

    func testWhenNameNotEmptyAndDurationEmptyThenDisableSaveButton() {
        let nameTextField = app.textFields["nameTextField"]
        nameTextField.tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }
    
    func testWhenNameEmptyAndDurationNotEmptyThenDisableSaveButton() {
        let durationPicker = app.pickers["durationPicker"]
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }
    
    func testWhenNameNotEmptyAndDurationNotEmptyThenEnableSaveButton() {
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        nameTextField.tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        XCTAssertTrue(app.buttons["saveButton"].isEnabled)
    }
    
    func testGivenSaveButtonEnabledWhenClickedThenSave() {
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        let cell = app.tables.cells.element(boundBy: 1)
        nameTextField.tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        app.buttons["saveButton"].tap()
        XCTAssertEqual(app.tables.cells.count, 11)
        XCTAssertEqual(cell.staticTexts["nameLabel"].label, preset.name)
        XCTAssertEqual(cell.staticTexts["durationLabel"].label, String(format: "%02d:%02d:%02d", preset.hours, preset.minutes, preset.seconds))
    }
    
    func testWhenCancelledThenNavigateToPresets() {
        app.navigationBars["TimesUp.NewPresetView"].buttons["cancelBarButtonItem"].tap()
        XCTAssertTrue(app.navigationBars["Presets"].exists)
    }
}
