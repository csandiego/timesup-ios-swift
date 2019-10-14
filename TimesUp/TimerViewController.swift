//
//  TimerViewController.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/14/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
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
    }
}
