//
//  PhotoTNTUITestsLaunchTests.swift
//  PhotoTNTUITests
//
//  Created by Guillermo Diaz on 8/17/22.
//

import XCTest

final class PhotoTNTUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
    }
}
