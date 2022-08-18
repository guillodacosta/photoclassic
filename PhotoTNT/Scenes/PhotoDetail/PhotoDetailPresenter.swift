//
//  PhotoDetailPresenter.swift
//  PhotoTNT
//
//  Created by Guillermo Diaz on 8/18/22.
//

protocol PhotoDetailPresentationLogic {
    func presentDetail(viewModel: Photo.ShowDetail.ViewModel)
}

class PhotoDetailPresenter: PhotoDetailPresentationLogic {
    private weak var viewController: PhotoDisplayLogic?
    
    init(with viewController: PhotoDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentDetail(viewModel: Photo.ShowDetail.ViewModel) {
        viewController?.displayDetails(viewModel: viewModel)
    }
}
