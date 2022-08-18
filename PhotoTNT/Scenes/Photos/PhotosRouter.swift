//
//  PhotosRouter.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import Foundation

@objc protocol PhotosRoutingLogic {
    func routeToPhotoDetails()
}

protocol PhotosDataPassing {
    var dataStore: PhotosDataStore { get set }
}

class PhotosRouter: NSObject, PhotosRoutingLogic, PhotosDataPassing {
    weak var viewController: PhotosViewController?
    var dataStore: PhotosDataStore
    
    init(source viewController: PhotosViewController, dataStore: PhotosDataStore) {
        self.dataStore = dataStore
        self.viewController = viewController
    }
    
    func routeToPhotoDetails() {
        let destinationVC = PhotoDetailViewController()
            
        destinationVC.initializeComponents()
        if let destinationDataStore = pushDestinationData(source: dataStore, destination: destinationVC.router?.dataStore) {
            destinationVC.router?.dataStore = destinationDataStore
            navigateToPhotoDetail(destination: destinationVC)
        }
    }
    
    func navigateToPhotoDetail(destination: PhotoDetailViewController) {
        viewController?.navigationController?.navigationBar.isHidden = false
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
    
    private func pushDestinationData(source: PhotosDataStore, destination dest: PhotoDetailDataStore?) -> PhotoDetailDataStore? {
        var destination = dest
        
        destination?.photo = source.photo
        
        return destination
    }
}
