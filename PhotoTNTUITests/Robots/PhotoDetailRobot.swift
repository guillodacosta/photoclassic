//
//  PhotoDetailRobot.swift
//  PhotoTNTUITests
//
//  Created by Guillermo Diaz on 8/18/22.
//

import XCTest

public class PhotoDetailRobot {
    
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
}

// MARK: Select Photo validations
extension PhotoDetailRobot {
    
    @discardableResult
    func checkIfViewIsLoaded() -> PhotoDetailRobot {
        let photoDetailHeader = app
            .descendants(matching: .any)
            .matching(identifier: "PhotoDetailHeader").firstMatch
        
        XCTAssert(photoDetailHeader.exists, "Photo detail header is not present")
        return self
    }
}

