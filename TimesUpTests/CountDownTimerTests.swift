//
//  CountDownTimerTests.swift
//  TimesUpTests
//
//  Created by Christopher San Diego on 10/23/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest
@testable import TimesUp

class CountDownTimerTests: XCTestCase {
    
    func testWhenInitializedThenTimeLeftEqualToStart() {
        let start = 2.0
        let timer = CountDownTimer(start) { _ in
        }
        XCTAssertEqual(timer.timeLeft, start)
    }
    
    func testWhenStartedThenUpdateStatus() {
        let timer = CountDownTimer(1.0) { _ in
        }
        timer.start()
        XCTAssertTrue(timer.isRunning)
    }
    
    func testWhenStartedThenDecrementTimeLeft() {
        let timer = CountDownTimer(2.0) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Decrement")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(timer.timeLeft, 1.0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testWhenStartedThenCallCallback() {
        var result = 0.0
        let timer = CountDownTimer(2.0) { timeLeft in
            result = timeLeft
        }
        timer.start()
        let expectation = self.expectation(description: "Callback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(result, 1.0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testGivenStartedWhenExpiredThenTimeLeftStaysAtZero() {
        let timer = CountDownTimer(1.0) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Expire")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(timer.timeLeft, 0.0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
    }
    
    func testGivenStartedWhenPausedThenUpdateStatus() {
        let timer = CountDownTimer(2.0) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer.pause()
            XCTAssertFalse(timer.isRunning)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testGivenStartedWhenPausedThenFreezeTimeLeft() {
        let timer = CountDownTimer(2.0) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertEqual(timer.timeLeft, 1.0)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.5)
    }
    
    func testGivenPausedWhenStartedThenDecrementTimeLeft() {
        let timer = CountDownTimer(3.0) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                timer.start()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    XCTAssertEqual(timer.timeLeft, 1.0)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 3.5)
    }
    
    func testGivenPausedWhenResetThenUpdateTimeLeft() {
        let start = 2.0
        let timer = CountDownTimer(start) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer.pause()
            timer.reset()
            XCTAssertEqual(timer.timeLeft, start)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testGivenPausedWhenResumeFromThenContinue() {
        let start = 3.0
        let timer = CountDownTimer(start) { _ in
        }
        timer.start()
        let expectation = self.expectation(description: "Wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            timer.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                timer.resume(from: start - 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    XCTAssertEqual(timer.timeLeft, 0.0)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 3.5)
    }
}
