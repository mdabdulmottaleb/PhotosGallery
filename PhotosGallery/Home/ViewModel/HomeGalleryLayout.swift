//
//  HomeGalleryLayout.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import Foundation
import UIKit

class HomeGalleryLayout {
    static let shared = HomeGalleryLayout()
    private init() { }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
 
        let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 2)
        let fullItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 2)
        // verticalGroup
        let verticalGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: fullItem, count: 2)
        // group
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), items: [item, verticalGroup])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

enum CompositionalGroupAlighment {
    case vertical
    case horizontal
}
//custom CompositionalLayout
struct CompositionalLayout{
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, spacing: CGFloat) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
    }
    static func createGroup(alignment: CompositionalGroupAlighment, width: NSCollectionLayoutDimension,height: NSCollectionLayoutDimension, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        
        switch alignment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: items)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: items)
        }
    }
    static func createGroup(alignment: CompositionalGroupAlighment, width: NSCollectionLayoutDimension,height: NSCollectionLayoutDimension, item: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        
        switch alignment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: item, count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitem: item, count: count)
        }
    }
}

