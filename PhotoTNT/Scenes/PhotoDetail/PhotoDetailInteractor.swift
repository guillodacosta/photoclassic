//
//  PhotoDetailInteractor.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

protocol PhotoDetailBusinessLogic {
    func loadDetails()
}

protocol PhotoDetailDataStore {
    var photo: Photo.ShowDetail.ViewModel? { get set }
}

class PhotoDetailInteractor: PhotoDetailBusinessLogic, PhotoDetailDataStore {
    var photo: Photo.ShowDetail.ViewModel?
//    var presenter: GroupDetailPresentationLogic?
//    var worker: GroupDetailWorker?
    // TODO
    func loadDetails() {
//        guard let photo = self.photo else {
//            print("Error")
//        }
//            presenter?.presentGroupDetail(detail: groupDetail)
    }
}
