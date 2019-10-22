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
    var timer: Timer?
    var suspendedAt: Date!
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
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _,_ in
        }
    }
    
    @objc func didEnterBackground() {
        if let timer = timer {
            suspendedAt = Date()
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc func didBecomeActive() {
        counter += Int(suspendedAt.timeIntervalSinceNow)
        if counter > 0 {
            timer = createTimer()
        } else {
            duration.text = "00:00:00"
            startButton.isEnabled = false
            pauseButton.isEnabled = false
            resetButton.isEnabled = true
        }
    }
    
    func createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.counter -= 1
            let hours = self.counter / (60 * 60)
            let rem = self.counter % (60 * 60)
            let minutes = rem / 60
            let seconds = rem % 60
            self.duration.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            if self.counter == 0 {
                self.startButton.isEnabled = false
                self.pauseButton.isEnabled = false
                self.resetButton.isEnabled = true
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    @IBAction func start(_ sender: Any) {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        resetButton.isEnabled = false
        timer = createTimer()
        let content = UNMutableNotificationContent()
        content.title = preset.name!
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(counter), repeats: false)
        let request = UNNotificationRequest(identifier: "TimesUp.TimerViewController", content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                notificationCenter.add(request) { _ in
                }
            }
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = true
        timer?.invalidate()
        timer = nil
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimesUp.TimerViewController"])
    }
    
    @IBAction func reset(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        duration.text = String(
            format: "%02d:%02d:%02d",
            preset.hours,
            preset.minutes,
            preset.seconds
        )
        counter = Int(preset.hours) * 60 * 60 + Int(preset.minutes) * 60 + Int(preset.seconds)
    }
}
