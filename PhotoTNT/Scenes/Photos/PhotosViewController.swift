//
//  PhotosViewController.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

protocol PhotosDisplayLogic: AnyObject {
    func showDetail(viewModel: Photo.ShowDetail.ViewModel)
    func showPhotos(viewModel: [Photo.FetchPhotos.ViewModel])
}

class PhotosViewController: UIViewController, PhotosDisplayLogic {
    private var interactor: PhotosBusinessLogic?
    private var router: (NSObjectProtocol & PhotosRoutingLogic & PhotosDataPassing)?
    
    private var photos: [Photo.FetchPhotos.ViewModel] = []
    private let headerView = UIView()
    private let tableView = PhotosTableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInjection()
        setUpConstraints()
        setUpView()
        loadPhotos()
    }
    
    func showDetail(viewModel: Photo.ShowDetail.ViewModel) {
        router?.routeToPhotoDetails()
    }
    
    func showPhotos(viewModel: [Photo.FetchPhotos.ViewModel]) {
        photos = viewModel
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
        }
    }
}

extension PhotosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photos[indexPath.row]
        let photoCell: PhotoViewCell = tableView.dequeueTypedCell(forIndexPath: indexPath)
        
        photoCell.initWith(viewModel: photo)
        photoCell.accessibilityIdentifier = "PhotoTableViewCell"
        photoCell.preservesSuperviewLayoutMargins = false
        photoCell.separatorInset = .zero
        photoCell.layoutMargins = .zero

        return photoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = Photo.ShowDetail.ViewModel(id: photos[indexPath.row].id,
                                                 thumbnailUrl: photos[indexPath.row].thumbnailUrl,
                                                 title: photos[indexPath.row].title,
                                                 url: photos[indexPath.row].url
        )
        
        selectPhoto(photo)
    }
}

private extension PhotosViewController {
    
    func selectPhoto(_ photo: Photo.ShowDetail.ViewModel) {
        interactor?.showDetail(photo: photo)
    }
    
    func setUpInjection() {
        let presenter = PhotosPresenter(with: self)
        let webRepository = PhotoURLSessionAPI(baseURL: "https://jsonplaceholder.typicode.com")
        let photoWorker = PhotosWorker(api: webRepository)
        let interactor = PhotosInteractor(presenter: presenter, photoWebWorker: photoWorker)
        let router = PhotosRouter(source: self, dataStore: interactor)
        
        self.interactor = interactor
        self.router = router
    }
    
    func setUpConstraints() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let centerXHeaderView = NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let heightHeaderView = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.1, constant: 0)
        heightHeaderView.priority = .required
        let topHeaderView = NSLayoutConstraint(item: headerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let widthHeaderView = NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        
        let bottomTableView = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let centerXTableView = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let topTableView = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1, constant: 0)
        let widthTableView = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([centerXHeaderView, topHeaderView, heightHeaderView, widthHeaderView])
        NSLayoutConstraint.activate([centerXTableView, topTableView, bottomTableView, widthTableView])
    }
    
    func setUpView() {
        headerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoViewCell.self)
        tableView.accessibilityIdentifier = "PhotosTable"
    }
    
    func loadPhotos() {
        interactor?.loadPhotos()
    }
    
}
