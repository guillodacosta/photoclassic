//
//  PhotoDetailRouter.swift
//  PhotoTNT
//
//  Created by Guillermo Diaz on 8/18/22.
//

import Foundation

protocol PhotoDetailRoutingLogic {
    func routeBack()
}

protocol PhotoDetailDataPassing {
    var dataStore: PhotoDetailDataStore { get set }
}

class PhotoDetailRouter: NSObject, PhotoDetailRoutingLogic, PhotoDetailDataPassing {
    
    private weak var viewController: PhotoDetailViewController?
    var dataStore: PhotoDetailDataStore
    
    init(source viewController: PhotoDetailViewController, dataStore: PhotoDetailDataStore) {
        self.dataStore = dataStore
        self.viewController = viewController
    }
    
    func routeBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
