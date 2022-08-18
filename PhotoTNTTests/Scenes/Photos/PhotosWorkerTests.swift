//
//  PhotosWorkerTests.swift
//  PhotoTNTTests
//
//  Created by Guillermo Diaz on 8/17/22.
//

import XCTest
@testable import PhotoTNT

class SearchWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: PhotosWorker!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPhotosWorker()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    private func setupPhotosWorker() {
        let apiWebRepositorySpy = PhotoURLSessionAPISpy(baseURL: "https://jsonplaceholder.typicode.com")
        sut = PhotosWorker(api: apiWebRepositorySpy)
    }
    
    // MARK: Test doubles
    
    private class PhotoURLSessionAPISpy: PhotoURLSessionAPI {
        // MARK: Method call expectations
        
        var fetchedPhotosCalled = false
        var fetchError: APIError?
        var fetchPhotosResponse: [Photo.FetchPhotos.Response]?
        
        // MARK: Spied methods
        
        override func fetchPhotos(completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
            fetchedPhotosCalled = true
            let oneSecond = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: oneSecond) {
                if let error = self.fetchError {
                    completionHandler(nil, error)
                } else {
                    completionHandler(self.fetchPhotosResponse, nil)
                }
            }
        }
        
        override func fetchPhotos(request: Photo.FetchPhotos.RequestPaginated, completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
            fetchedPhotosCalled = true
            let oneSecond = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: oneSecond) {
                if let error = self.fetchError {
                    completionHandler(nil, error)
                } else {
                    completionHandler(self.fetchPhotosResponse, nil)
                }
            }
        }
    }
    
    // MARK: Tests
    
    func testFetchPhotosShouldReturnListOfPhotos() {
        // Given
        guard let webApiSpy = sut.api as? PhotoURLSessionAPISpy else {
            XCTAssert(false)
            return
        }
        let spyResponse = [
            Photo.FetchPhotos.Response(albumId: 2, id: 2, thumbnailUrl: "url2", title: "title 2", url: "full url 2"),
            Photo.FetchPhotos.Response(albumId: 33, id: 33, thumbnailUrl: "url33", title: "title 33", url: "full url 33"),
            Photo.FetchPhotos.Response(albumId: 4, id: 4, thumbnailUrl: "url4", title: "title 4", url: "full url 42"),
        ]
        var responseSUT: [Photo.FetchPhotos.Response]?
        
        webApiSpy.fetchPhotosResponse = spyResponse
        
        // When
        let expectation = XCTestExpectation(description: "Wait for fetched photos result")
        sut.fetchPhotos() { (response, error) -> Void in
            responseSUT = response
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(webApiSpy.fetchedPhotosCalled, "Calling fetchPhotos() should ask the data for a list of items")
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(responseSUT, "Fetched items is nil")
        XCTAssertEqual(responseSUT?.count, 3, "Fetched photos hasn't expected total results")
    }
    
    func testFetchItemsShouldReturnListOfPhotosPaginated() {
        // Given
        guard let webApiSpy = sut.api as? PhotoURLSessionAPISpy else {
            XCTAssert(false)
            return
        }
        let spyResponse = [
            Photo.FetchPhotos.Response(albumId: 2, id: 2, thumbnailUrl: "url2", title: "title 2", url: "full url 2"),
            Photo.FetchPhotos.Response(albumId: 33, id: 33, thumbnailUrl: "url33", title: "title 33", url: "full url 33"),
            Photo.FetchPhotos.Response(albumId: 4, id: 4, thumbnailUrl: "url4", title: "title 4", url: "full url 42"),
        ]
        var responseSUT: [Photo.FetchPhotos.Response]?
        let request = Photo.FetchPhotos.RequestPaginated(limit: 3, start: 1)
        
        webApiSpy.fetchPhotosResponse = spyResponse
        
        // When
        let expectation = XCTestExpectation(description: "Wait for fetched photos result")
        sut.fetchPhotos(request: request) { (response, error) -> Void in
            responseSUT = response
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(webApiSpy.fetchedPhotosCalled, "Calling fetchPhotos() should ask the data for a list of items")
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(responseSUT, "Fetched photos is nil")
        XCTAssertEqual(responseSUT?.count, 3, "Fetched photos hasn't expected total results")
    }
    
    func testFetchItemsShouldReturnError() {
        // Given
        guard let webApiSpy = sut.api as? PhotoURLSessionAPISpy else {
            XCTAssert(false)
            return
        }
        var responseSUT: [Photo.FetchPhotos.Response]?
        webApiSpy.fetchError = .cannotFetch("is empty")
        var errorResponseSUT: APIError?
        
        // When
        let expectation = XCTestExpectation(description: "Wait for fetched items result")
        sut.fetchPhotos() { (response, error) -> Void in
            responseSUT = response
            errorResponseSUT = error
            expectation.fulfill()
        }
        
        // Then
        XCTAssert(webApiSpy.fetchedPhotosCalled, "Calling fetchPhotos() should ask the data for a list of items")
        wait(for: [expectation], timeout: 2)
        XCTAssertNil(responseSUT, "Fetched photos is not nil")
        XCTAssertEqual(errorResponseSUT?.errorDescription, "is empty", "Fetched error response is not cannot fetch")
    }
}

