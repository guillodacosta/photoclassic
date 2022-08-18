//
//  PhotosPresenter.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

protocol PhotosPresentationLogic {
    func presentPhotos(response: [Photo.FetchPhotos.Response])
    func presentDetail(photo: Photo.ShowDetail.ViewModel)
}

class PhotosPresenter: PhotosPresentationLogic {
    private weak var viewController: PhotosDisplayLogic?
    
    init(with viewController: PhotosDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentDetail(photo viewModel: Photo.ShowDetail.ViewModel) {
        viewController?.showDetail(viewModel: viewModel)
    }
    
    func presentPhotos(response: [Photo.FetchPhotos.Response]) {
        let viewModel = response.map {
            Photo.FetchPhotos.ViewModel(id: $0.id,
                                        thumbnailUrl: $0.thumbnailUrl,
                                        title: $0.title,
                                        url: $0.url)
        }
        viewController?.showPhotos(viewModel: viewModel)
    }

}
