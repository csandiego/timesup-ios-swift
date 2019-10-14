//
//  NewPresetViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/14/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit
import CoreData

class NewPresetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var persistentContainer: NSPersistentContainer!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var duration: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var name = ""
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        duration.dataSource = self
        duration.delegate = self
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            name = text
            validate()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hours = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break
        }
        validate()
    }
    
    func validate() {
        let valid = name.count > 0 && hours + minutes + seconds > 0
        saveButton.isEnabled = valid
    }
    
    @IBAction func save(_ sender: Any) {
        let context = persistentContainer.viewContext
        let preset = Preset(context: context)
        preset.name = name
        preset.hours = Int64(hours)
        preset.minutes = Int64(minutes)
        preset.seconds = Int64(seconds)
        try! context.save()
        navigationController!.popViewController(animated: true)
    }
}
