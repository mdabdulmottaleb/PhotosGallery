//
//  ReusableView.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseID: String { get }
}
extension ReusableView {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}
extension UICollectionViewCell: ReusableView {}
