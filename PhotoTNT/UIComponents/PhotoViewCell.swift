//
//  PhotoViewCell.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

class PhotoViewCell: UITableViewCell {

    private let nameLabel: PhotoLabel = PhotoLabel(frame: .zero)
    private var photo: Photo.FetchPhotos.ViewModel? {
        didSet {
            updateUI()
        }
    }
    private let photoImageView: UIImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWith(viewModel: Photo.FetchPhotos.ViewModel) {
        photo = viewModel
    }
}

private extension PhotoViewCell {
    
    func setUpConstraints() {
        addSubview(nameLabel)
        addSubview(photoImageView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerYPhotoLabel = NSLayoutConstraint(item: photoImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let heightPhotoLabel = NSLayoutConstraint(item: photoImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let leadingPhotoLabel = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20)
        let widthPhotoLabel = NSLayoutConstraint(item: photoImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        
        let centerYNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let heightNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        let leadingNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: photoImageView, attribute: .trailing, multiplier: 1, constant: 20)
        let trailingNameLabel = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 20)
        
        NSLayoutConstraint.activate([leadingNameLabel, centerYNameLabel, trailingNameLabel, heightNameLabel])
        NSLayoutConstraint.activate([leadingPhotoLabel, centerYPhotoLabel, widthPhotoLabel, heightPhotoLabel])
    }
    
    func setUpView() {
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
    }
    
    func updateUI() {
        if let photo = self.photo {
            nameLabel.text = photo.title
            photoImageView.imageFromServerURL(urlString: photo.thumbnailUrl)
        }
    }
    
}

