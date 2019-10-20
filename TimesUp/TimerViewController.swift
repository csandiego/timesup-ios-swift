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
    
    var preset: Preset!
    var counter = 0
    var timer: Timer!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = preset.name
        duration.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
        counter = Int(preset.hours) * 60 * 60 + Int(preset.minutes) * 60 + Int(preset.seconds)
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        print("Loaded")
    }
    
    @IBAction func start(_ sender: Any) {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        resetButton.isEnabled = false
        print("Started")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.counter == 0 {
                self.pause(sender)
                return
            }
            self.counter -= 1
            let hours = self.counter / (60 * 60)
            let rem = self.counter % (60 * 60)
            let minutes = rem / 60
            let seconds = rem % 60
            self.duration.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = true
        print("Paused")
        timer.invalidate()
    }
    
    @IBAction func reset(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        print("Reset")
        duration.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
        counter = Int(preset.hours) * 60 * 60 + Int(preset.minutes) * 60 + Int(preset.seconds)
    }
}
