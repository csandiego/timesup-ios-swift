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
    lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    lazy var timer: CountDownTimer = {
        CountDownTimer(preset.duration) { timeLeft in
            self.duration.text = self.formatter.string(from: timeLeft)
            if timeLeft == 0.0 {
                self.startButton.isEnabled = false
                self.pauseButton.isEnabled = false
                self.resetButton.isEnabled = true
            }
        }
    }()
    var didEnterBackgroundOn: Date?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = preset.name
        duration.text = formatter.string(from: timer.timeLeft)
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _,_ in
        }
    }
    
    @objc func didEnterBackground() {
        if timer.isRunning {
            timer.pause()
            didEnterBackgroundOn = Date()
        }
    }
    
    @objc func didBecomeActive() {
        if let didEnterBackgroundOn = didEnterBackgroundOn {
            let from = timer.timeLeft + didEnterBackgroundOn.timeIntervalSinceNow.rounded()
            if from > 0.0 {
                timer.resume(from: from)
                duration.text = formatter.string(from: timer.timeLeft)
            } else {
                duration.text = formatter.string(from: 0.0)
                startButton.isEnabled = false
                pauseButton.isEnabled = false
                resetButton.isEnabled = true
            }
            self.didEnterBackgroundOn = nil
        }
    }
    
    @IBAction func start(_ sender: Any) {
        timer.start()
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        resetButton.isEnabled = false
        let content = UNMutableNotificationContent()
        content.body = preset.name!
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer.timeLeft, repeats: false)
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
        timer.pause()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = true
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimesUp.TimerViewController"])
    }
    
    @IBAction func reset(_ sender: Any) {
        timer.reset()
        duration.text = formatter.string(from: timer.timeLeft)
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            timer.pause()
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TimesUp.TimerViewController"])
        }
    }
}
