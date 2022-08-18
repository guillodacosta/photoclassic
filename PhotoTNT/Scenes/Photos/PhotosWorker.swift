//
//  PhotosWorker.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

protocol PhotosProtocol {
    func fetchPhotos(completionHandler: @escaping (_ photos: [Photo.FetchPhotos.Response]?, APIError?) -> Void)
    func fetchPhotos(request: Photo.FetchPhotos.RequestPaginated, completionHandler: @escaping(_ photo: [Photo.FetchPhotos.Response]?, APIError?) -> Void)
}

class PhotosWorker {
    let api: PhotosProtocol
    
    init(api: PhotosProtocol) {
        self.api = api
    }
    
    func fetchPhotos(completionHandler: @escaping (_ photos: [Photo.FetchPhotos.Response]?, APIError?) -> Void) {
        api.fetchPhotos { photos, err in
            completionHandler(photos, err)
        }
    }
    
    func fetchPhotos(request: Photo.FetchPhotos.RequestPaginated, completionHandler: @escaping(_ photo: [Photo.FetchPhotos.Response]?, APIError?) -> Void) {
        api.fetchPhotos(request: request) { photo, err in
            completionHandler(photo, err)
        }
    }
}
