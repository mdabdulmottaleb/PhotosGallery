//
//  HomeGalleryViewController.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class HomeGalleryViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
    }
    
    private func viewSetUp(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNibCell(HomeGalleryCell.self)
        
        collectionView.collectionViewLayout = HomeGalleryLayout.shared.createLayout()
        
    }
}
extension HomeGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 51
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as HomeGalleryCell
        return cell
    }
}
