//
//  HomeGalleryCell.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class HomeGalleryCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension HomeGalleryCell {
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> HomeGalleryCell {
        return collectionView.dequeueReusableCell(forIndexPath: indexPath)
    }
}
