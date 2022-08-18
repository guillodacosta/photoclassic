//
//  PhotosInteractor.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//


protocol PhotosBusinessLogic {
    func loadPhotos()
    func showDetail(photo: Photo.ShowDetail.ViewModel)
}

protocol PhotosDataStore {
    var photos: [Photo.FetchPhotos.Response]? { get set }
    var photo: Photo.ShowDetail.ViewModel? { get set }
}

class PhotosInteractor: PhotosBusinessLogic, PhotosDataStore {
    var photos: [Photo.FetchPhotos.Response]?
    var photo: Photo.ShowDetail.ViewModel?
    private let presenter: PhotosPresentationLogic
    private let photoWebWorker: PhotosWorker
    
    init(presenter: PhotosPresentationLogic, photoWebWorker: PhotosWorker) {
        self.presenter = presenter
        self.photoWebWorker = photoWebWorker
    }
    
    func loadPhotos() {
        photoWebWorker.fetchPhotos { photos, err  in
            self.photos = photos
            if let photos = photos {
                self.presenter.presentPhotos(response: photos)
            }
        }
    }
    
    func showDetail(photo: Photo.ShowDetail.ViewModel) {
        self.photo = photo
        self.presenter.presentDetail(photo: photo)
    }
}
