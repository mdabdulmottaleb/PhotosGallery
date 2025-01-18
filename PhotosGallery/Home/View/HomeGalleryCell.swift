//
//  HomeGalleryCell.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit
import SDWebImage

class HomeGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImage: UIImageView!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        
        //Centering the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setSDImage(urlString: String, placeholderImageName: String) {
        //Start the activity indicator
        activityIndicator.startAnimating()
        
        if let imageUrl = URL(string: urlString) {
            //to load the image asynchronously
            galleryImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: placeholderImageName)) { [weak self] _, _, _, _ in
                //Stop the activity indicator
                self?.activityIndicator.stopAnimating()
            }
        } else {
            //stop the activity indicator
            activityIndicator.stopAnimating()
        }
    }
    
}
extension HomeGalleryCell {
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> HomeGalleryCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath)
    }
}
