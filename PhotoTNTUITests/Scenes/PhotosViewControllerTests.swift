//
//  PhotosViewControllerTests.swift
//  PhotoTNTUITests
//
//  Created by Guillermo Diaz on 8/18/22.
//

import XCTest

class PhotosViewControllerTests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override class func setUp() {
        super.setUp()
        let app = XCUIApplication()
        
        app.launch()
    }
    
    func testCellsExists() {
                
    }
    
    func testPhotosAreVisible() {
        let photosRobot = PhotosRobot(app: app)

        photosRobot
            .waitForPhotoTable()
            .checkIfViewHasPhotos()
    }
    
    func testShowPhotoDetail() {
        let photosRobot = PhotosRobot(app: app)
        let photoDetailRobot = PhotoDetailRobot(app: app)

        photosRobot
            .waitForPhotoTable()
            .selectFirstCell()
        photoDetailRobot
            .checkIfViewIsLoaded()
        photosRobot
            .checkIfViewIsNotPresent()
    }
}

