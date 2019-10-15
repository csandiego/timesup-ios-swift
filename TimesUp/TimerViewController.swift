//
//  TimerViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/14/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer!
    var preset: Preset!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = preset.name
        duration.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editPreset))
        navigationItem.setRightBarButton(editButton, animated: true)
    }
    
    @objc func editPreset() {
        performSegue(withIdentifier: "editPreset", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPreset" {
            let viewController = segue.destination as! EditPresetViewController
            viewController.persistentContainer = persistentContainer
            viewController.preset = preset
        }
    }
}
