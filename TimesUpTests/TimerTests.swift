//
//  TimerTests.swift
//  TimesUpTests
//
//  Created by Christopher San Diego on 10/21/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest
@testable import TimesUp
import CoreData

class TimerTests: XCTestCase {
    
    var controller: TimerViewController!

    override func setUp() {
        let model = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
        let container = NSPersistentContainer(name: "TimesUp", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        let preset = Preset(context: container.viewContext)
        preset.name = "1 minute"
        preset.hours = 0
        preset.minutes = 1
        preset.seconds = 0
        try! container.viewContext.save()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = (storyboard.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController)
        controller.preset = preset
        _ = controller.view
    }
    
    func testWhenStartedThenAddNotification() {
        controller.start(self)
        let expectation = self.expectation(description: "Add notification")
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { _ in
            userNotificationCenter.getPendingNotificationRequests { requests in
                let found = requests.first { r in
                    return r.identifier == "TimesUp.TimerViewController"
                }
                XCTAssertNotNil(found)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGivenStartedWhenPausedThenRemoveNotification() {
        controller.start(self)
        let expectation = self.expectation(description: "Remove notification")
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { _ in
            userNotificationCenter.getPendingNotificationRequests { r in
                DispatchQueue.main.async {
                    self.controller.pause(self)
                    userNotificationCenter.getPendingNotificationRequests { requests in
                        let found = requests.first { r in
                            return r.identifier == "TimesUp.TimerViewController"
                        }
                        XCTAssertNil(found)
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testWhenDidEnterBackgroundThenTimerIsNil() {
        controller.didEnterBackground()
        XCTAssertNil(controller.timer)
    }
    
    func testGivenStartedWhenDidEnterBackgroundThenSuspendAtSet() {
        controller.start(self)
        controller.didEnterBackground()
        XCTAssertLessThanOrEqual(controller.suspendedAt, Date())
    }
    
    func testGivenDidEnterBackgroundWhenDidBecomeActiveThenCreateTimer() {
        controller.start(self)
        controller.didEnterBackground()
        controller.didBecomeActive()
        XCTAssertNotNil(controller.timer)
    }
    
    func testGivenStartedWhenDidMoveThenRemoveNotification() {
        controller.start(self)
        controller.didMove(toParent: nil)
        let expectation = self.expectation(description: "Remove notification")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let found = requests.first { r in
                return r.identifier == "TimesUp.TimerViewController"
            }
            XCTAssertNil(found)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGivenStartedWhenDidMoveThenTimerNil() {
        controller.start(self)
        controller.didMove(toParent: nil)
        XCTAssertNil(controller.timer)
    }
}
