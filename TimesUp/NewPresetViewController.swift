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

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var duration: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        duration.dataSource = self
        duration.delegate = self
        
        saveButton.isEnabled = isValid()
    }
    
    func isValid() -> Bool {
        return name.text?.count ?? 0 > 0 && duration.selectedRow(inComponent: 0) + duration.selectedRow(inComponent: 1) + duration.selectedRow(inComponent: 2) > 0
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
    
    @IBAction func save(_ sender: Any) {
        let preset = Preset(context: persistentContainer.viewContext)
        preset.name = name.text
        preset.hours = Int64(duration.selectedRow(inComponent: 0))
        preset.minutes = Int64(duration.selectedRow(inComponent: 1))
        preset.seconds = Int64(duration.selectedRow(inComponent: 2))
        try! persistentContainer.viewContext.save()
        navigationController!.popViewController(animated: true)
    }
}
