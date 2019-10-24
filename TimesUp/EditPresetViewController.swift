//
//  EditPresetViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/15/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit
import CoreData

class EditPresetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var persistentContainer: NSPersistentContainer!
    var preset: Preset!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var duration: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        duration.dataSource = self
        duration.delegate = self
        name.text = preset.name
        let hours = Int(preset.duration) / (60 * 60)
        let rem = Int(preset.duration) % (60 * 60)
        let minutes = rem / 60
        let seconds = rem % 60
        duration.selectRow(hours, inComponent: 0, animated: false)
        duration.selectRow(minutes, inComponent: 1, animated: false)
        duration.selectRow(seconds, inComponent: 2, animated: false)
        saveButton.isEnabled = isValid()
    }
    
    func isValid() -> Bool {
        return name.text?.count ?? 0 > 0 && duration.selectedRow(inComponent: 0) + duration.selectedRow(inComponent: 1) + duration.selectedRow(inComponent: 2) > 0
    }
    
    @IBAction func save(_ sender: Any) {
        preset.name = name.text
        preset.duration = Double(duration.selectedRow(inComponent: 0) * 60 * 60) +
            Double(duration.selectedRow(inComponent: 1) * 60) +
            Double(duration.selectedRow(inComponent: 2))
        try! persistentContainer.viewContext.save()
        presentingViewController?.dismiss(animated: true, completion: nil)
//        navigationController!.popViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = isValid()
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
        saveButton.isEnabled = isValid()
    }
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
