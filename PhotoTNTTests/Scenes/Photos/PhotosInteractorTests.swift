//
//  PhotosInteractorTests.swift
//  PhotoTNTTests
//
//  Created by Guillermo Diaz on 8/18/22.
//

import XCTest
@testable import PhotoTNT

class SearchInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var presenterSpy: PhotoPresenterSpy!
    var sut: PhotosInteractor!
    var workerSpy: PhotosWorkerSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPhotosInteractor()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    private func setupPhotosInteractor() {
        let photosVC: PhotosDisplayLogic = PhotosViewController()
        presenterSpy = PhotoPresenterSpy(with: photosVC)
        workerSpy = PhotosWorkerSpy(api: PhotoURLSessionAPI(baseURL: ""))
        sut = PhotosInteractor(presenter: presenterSpy, photoWebWorker: workerSpy)
    }
    
    // MARK: Test doubles
    
    final class PhotoPresenterSpy: PhotosPresenter {
        // MARK: Method call expectations
        
        var presentDetailCalled = false
        var presentPhotosCalled = false
        var response: [Photo.FetchPhotos.Response]?
        private (set) var viewModel: Photo.ShowDetail.ViewModel?
        
        // MARK: Spied methods
        
        override func presentDetail(photo viewModel: Photo.ShowDetail.ViewModel) {
            presentDetailCalled = true
            self.viewModel = viewModel
        }
        
        override func presentPhotos(response: [Photo.FetchPhotos.Response]) {
            presentPhotosCalled = true
            self.response = response
        }
    }
    
    final class PhotosWorkerSpy: PhotosWorker {
        // MARK: Method call expectations
        
        var fetchError: APIError?
        var fetchPhotosResponse: [Photo.FetchPhotos.Response]?
        var expectation: XCTestExpectation?
        
        // MARK: Spied methods
        
        override func fetchPhotos(completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
            let oneSecond = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: oneSecond) { [weak self] in
                if let error = self?.fetchError {
                    completionHandler(nil, error)
                } else {
                    completionHandler(self?.fetchPhotosResponse, nil)
                }
                self?.expectation?.fulfill()
            }
        }
        
        override func fetchPhotos(request: Photo.FetchPhotos.RequestPaginated, completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
            let oneSecond = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: oneSecond) { [weak self] in
                if let error = self?.fetchError {
                    completionHandler(nil, error)
                } else {
                    completionHandler(self?.fetchPhotosResponse, nil)
                }
                self?.expectation?.fulfill()
            }
        }
    }
    
    // MARK: Tests
    
    func testLoadPhotosShouldPresentListOfPhotos() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetched photos result")
        let spyResponse = [
            Photo.FetchPhotos.Response(albumId: 2, id: 2, thumbnailUrl: "url2", title: "title 2", url: "full url 2"),
            Photo.FetchPhotos.Response(albumId: 33, id: 33, thumbnailUrl: "url33", title: "title 33", url: "full url 33"),
            Photo.FetchPhotos.Response(albumId: 4, id: 4, thumbnailUrl: "url4", title: "title 4", url: "full url 42"),
        ]
        workerSpy.fetchPhotosResponse = spyResponse
        workerSpy.expectation = expectation
        
        // When
        
        sut.loadPhotos()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssert(presenterSpy.presentPhotosCalled, "Calling loadPhotos() should ask the data for a list of items")
        XCTAssertNotNil(presenterSpy.response, "Loaded items is nil")
        XCTAssertEqual(presenterSpy.response?.count, 3, "Loaded photos hasn't expected total results")
    }
    
    func testLoadPhotosShouldNotPresentPhotosWhenWorkerAPIError() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetched photos result")
        workerSpy.fetchError = APIError.unexpectedResponse
        workerSpy.expectation = expectation
        
        // When
        
        sut.loadPhotos()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(presenterSpy.presentPhotosCalled, "Calling loadPhotos() should not present photos")
        XCTAssertNil(presenterSpy.response, "Already Loaded photos when error")
    }
    
    func testShowDetailShouldPresentPhotoDetail() {
        // Given
        let spyResponse = Photo.ShowDetail.ViewModel(id: 1, thumbnailUrl: "url1", title: "title 1", url: "urlfull1")
        
        // When
        sut.showDetail(photo: spyResponse)
        
        // Then
        XCTAssert(presenterSpy.presentDetailCalled, "Calling showDetail(..) should be called")
        XCTAssertNotNil(presenterSpy.viewModel, "Presenter viewModel is nil")
        XCTAssertEqual(presenterSpy.viewModel?.title, "title 1", "Presented title hasn't expected value")
    }
}
