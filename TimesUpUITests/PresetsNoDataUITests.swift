//
//  PresetsNoDataUITests.swift
//  TimesUpUITests
//
//  Created by Christopher San Diego on 10/24/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest

class PresetsNoDataUITests: XCTestCase {
    
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
        app.launchArguments = ["--test-mode", "--no-data"]
        app.launch()
    }
    
    func testGivenNoDataWhenLoadedThenDisplayEmptyView() {
        XCTAssertTrue(app.staticTexts["emptyViewLabel"].exists)
    }
    
    func testGivenNoDataWhenPresetAddedThenHideEmptyView() {
        app.toolbars["Toolbar"].buttons["newBarButtonItem"].tap()
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        nameTextField.tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        app.buttons["saveButton"].tap()
        XCTAssertFalse(app.staticTexts["emptyViewLabel"].exists)
    }
    
    func testGivenDataWhenPresetDeletedThenDisplayEmptyView() {
        app.toolbars["Toolbar"].buttons["newBarButtonItem"].tap()
        let nameTextField = app.textFields["nameTextField"]
        let durationPicker = app.pickers["durationPicker"]
        nameTextField.tap()
        nameTextField.typeText(preset.name)
        app.buttons["Done"].tap()
        durationPicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(format: "%02d", preset.hours))
        durationPicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(format: "%02d", preset.minutes))
        durationPicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(format: "%02d", preset.seconds))
        app.buttons["saveButton"].tap()
        let cell = app.tables.cells.element(boundBy: 0)
        cell.swipeLeft()
        cell.buttons["Delete"].tap()
        XCTAssertTrue(app.staticTexts["emptyViewLabel"].exists)
    }
}
