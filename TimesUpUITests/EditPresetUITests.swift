//
//  EditPresetUITests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/16/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class EditPresetUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let preset = (
        name: "01 hour",
        hours: 1,
        minutes: 0,
        seconds: 0
    )

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["--test-mode"]
        app.launch()
        app.navigationBars["Presets"].buttons["Edit"].tap()
        app.tables.cells.element(boundBy: 0).tap()
    }

    func testWhenNameEmptyAndDurationEmptyThenDisableSaveButton() {
        let durationPicker = app.pickers["durationPicker"]
        app.textFields["nameTextField"].tap()
        app.buttons["Clear text"].tap()
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "00")
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "00")
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }

    func testWhenNameNotEmptyAndDurationEmptyThenDisableSaveButton() {
        let durationPicker = app.pickers["durationPicker"]
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "00")
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "00")
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }
    
    func testWhenNameEmptyAndDurationNotEmptyThenDisableSaveButton() {
        app.textFields["nameTextField"].tap()
        app.buttons["Clear text"].tap()
        app.buttons["Done"].tap()
        XCTAssertFalse(app.buttons["saveButton"].isEnabled)
    }
    
    func testWhenNameNotEmptyAndDurationNotEmptyThenEnableSaveButton() {
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        nameTextField.tap()
        app.buttons["Clear text"].tap()
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
        let cell = app.tables.cells.element(boundBy: 0)
        nameTextField.tap()
        app.buttons["Clear text"].tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        app.buttons["saveButton"].tap()
        XCTAssertEqual(cell.staticTexts["nameLabel"].label, preset.name)
        XCTAssertEqual(cell.staticTexts["durationLabel"].label, String(format: "%02d:%02d:%02d", preset.hours, preset.minutes, preset.seconds))
    }
    
    func testWhenLoadedThenDisplayDetails() {
        let durationPicker = app.pickers["durationPicker"]
        XCTAssertEqual(app.textFields["nameTextField"].value as! String?, "01 minutes")
        XCTAssertEqual(durationPicker.pickerWheels.element(boundBy: 0).value as! String?, "00")
        XCTAssertEqual(durationPicker.pickerWheels.element(boundBy: 1).value as! String?, "01")
        XCTAssertEqual(durationPicker.pickerWheels.element(boundBy: 2).value as! String?, "00")
    }
    
    func testGivenNameWithDifferentSortingPlacementWhenSaveThenMoveCell() {
        let name = "1 hours"
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        let cell = app.tables.cells.element(boundBy: 9)
        nameTextField.tap()
        app.buttons["Clear text"].tap()
        nameTextField.typeText(name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        app.buttons["saveButton"].tap()
        XCTAssertEqual(cell.staticTexts["nameLabel"].label, name)
        XCTAssertEqual(cell.staticTexts["durationLabel"].label, String(format: "%02d:%02d:%02d", preset.hours, preset.minutes, preset.seconds))
    }
    
    func testWhenCancelledThenNavigateToPresets() {
        app.navigationBars["TimesUp.EditPresetView"].buttons["cancelBarButtonItem"].tap()
        XCTAssertTrue(app.navigationBars["Presets"].exists)
    }
}
