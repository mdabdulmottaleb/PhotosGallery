//
//  HomeGalleryViewController.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class HomeGalleryViewController: UIViewController {
    
    private var photos: [Photo] = []
    private var currentPage = 1
    private var isFetching = false
    private let itemsPerPage = 20
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        }
    }
    
    private lazy var url: URL = {
        return URL(string: "https://api.pexels.com/v1/curated")!
    }()
    
    private lazy var dataService: HomeGalleryService = {
        return HomeGalleryService(url: url, isFetching: isFetching)
    }()
    
    private lazy var viewModel: HomeGalleryViewModel = {
        return HomeGalleryViewModel(dataService: dataService, pageNumber: itemsPerPage, currentPage: currentPage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetUp()
        bindViewModel()
        viewModel.onPhotosUpdated?()
    }
    
    private func viewSetUp(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNibCell(HomeGalleryCell.self)
        
        collectionView.collectionViewLayout = HomeGalleryLayout.shared.createLayout()
    }
    
    private func bindViewModel() {
        viewModel.onPhotosUpdated = { [weak self] in
            guard let self = self else { return }
            self.photos = self.viewModel.photos
            self.collectionView.reloadData()
            self.isFetching = false // Reset fetching state if used in scroll logic
        }
    }
}

extension HomeGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as HomeGalleryCell
        
        cell.setSDImage(urlString: photos[indexPath.item].src.original, placeholderImageName: "placeHolderImg")
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        
        //if near the bottom of the content
        if position > contentHeight - scrollHeight - 100 {
            if !isFetching {
                currentPage += 1
                
                viewModel.dataService.fetchCuratedPhotos(perPage: itemsPerPage, page: currentPage) { [weak self] responseData in
                    DispatchQueue.main.async {
                        self?.photos.append(contentsOf: responseData.photos)
                        self?.collectionView.reloadData()
                        self?.isFetching = false // Reset fetching state
                    }
                }
                
            }
        }
    }
}
