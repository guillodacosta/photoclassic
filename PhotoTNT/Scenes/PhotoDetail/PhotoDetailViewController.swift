//
//  PhotoViewController.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

protocol PhotoDisplayLogic: AnyObject {
    func displayDetailView(viewModel: Photo.ShowDetail.ViewModel)
}

// TODO move to router
protocol PhotoDetailRoutingLogic {
    func routeToSearch()
}

// TODO move to router
protocol PhotoDetailDataPassing {
    var dataStore: PhotoDetailDataStore { get set }
}

class PhotoDetailViewController: UIViewController, PhotoDisplayLogic {
    private var interactor: PhotoDetailBusinessLogic?
    var router: (NSObjectProtocol & PhotoDetailRoutingLogic & PhotoDetailDataPassing)?
    
    private var photos: [Photo.FetchPhotos.ViewModel] = []
    private let headerView = UIView()
    private let tableView = PhotosTableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInjection()
        setUpConstraints()
        setUpView()
        loadDetails()
    }
    
    func initializeComponents() {
        setUpInjection()
    }
    
    func displayDetailView(viewModel: Photo.ShowDetail.ViewModel) {
        // TODO
    }
}

private extension PhotoDetailViewController {
    
    func setUpInjection() {
        let presenter = ItemDetailPresenter(with: self)
        let interactor = ItemDetailInteractor(presenter: presenter)
        let router = ItemDetailRouter(source: self, dataStore: interactor)

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
        headerView.accessibilityIdentifier = "PhotoDetailHeader"
    }
    
    func loadDetails() {
        interactor?.loadDetails()
    }
    
}
