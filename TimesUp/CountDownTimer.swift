//
//  CountDownTimer.swift
//  TimesUp
//
//  Created by Christopher San Diego on 10/23/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Foundation

class CountDownTimer {
    
    private let from: TimeInterval
    private let callback: (TimeInterval) -> Void
    private var _timeLeft: TimeInterval
    var timeLeft: TimeInterval {
        _timeLeft
    }
    private var timer: Timer?
    
    init(_ from: TimeInterval, callback: @escaping (TimeInterval) -> Void) {
        self.from = from
        self.callback = callback
        _timeLeft = from
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self._timeLeft > 0.0 {
                self._timeLeft -= 1.0
                self.callback(self._timeLeft)
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        _timeLeft = from
    }
    
    func resume(from: TimeInterval) {
        _timeLeft = from
        start()
    }
}
