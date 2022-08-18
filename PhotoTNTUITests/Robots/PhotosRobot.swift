//
//  PhotosRobot.swift
//  PhotoTNTUITests
//
//  Created by Guillermo Diaz on 8/18/22.
//

import XCTest

public class PhotosRobot {
    
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    @discardableResult
    func selectFirstCell() -> PhotosRobot {
        app.descendants(matching: .cell).matching(identifier: "PhotoTableViewCell").firstMatch.tap()
        return self
    }
    
    @discardableResult
    func reloadPosts() -> PhotosRobot {
        app.tables["PhotosTable"].firstMatch.swipeDown()
        return self
    }
    
    /// - Parameter seconds: Seconds to wait, default 5
    @discardableResult
    func waitForPhotoTable(seconds: Double = 5) -> PhotosRobot {
        let _ = app.tables["PhotosTable"].waitForExistence(timeout: seconds)
        return self
    }
}

// MARK: Photos view validations
extension PhotosRobot {
    
    @discardableResult
    func checkIfViewHasPhotos() -> PhotosRobot {
        let photoTable = app.descendants(matching: .table).matching(identifier: "PhotosTable")
        let photoCells = app.descendants(matching: .cell).matching(identifier: "PhotoTableViewCell")
        
        XCTAssert(photoTable.firstMatch.exists, "Doesn't exists tableView")
        XCTAssert(photoCells.firstMatch.exists, "Doesn't showing at least one row")
        return self
    }
    
    @discardableResult
    func checkIfViewIsNotPresent() -> PhotosRobot {
        let tableView = app.tables["PhotosTable"]
        XCTAssertFalse(tableView.firstMatch.exists, "View still is presented")
        return self
    }
}

