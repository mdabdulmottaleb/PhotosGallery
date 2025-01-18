//
//  HomeGalleryViewModel.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb Pro on 18/1/25.
//

import UIKit

class HomeGalleryViewModel: NSObject{
    var photos: [Photo] = []
    
    let dataService: HomeGalleryService
    let pageNumber: Int
    let currentPage: Int
    
    var onPhotosUpdated: (() -> Void)?
    
    init(dataService: HomeGalleryService, pageNumber: Int, currentPage: Int){
        self.dataService = dataService
        self.pageNumber = pageNumber
        self.currentPage = currentPage
        
        super.init()
        loadHomeGalleryData()
    }
    
    private func loadHomeGalleryData() {
        dataService.fetchCuratedPhotos(perPage: pageNumber, page: currentPage) { responseData in
            DispatchQueue.main.async {
                debugPrint("responseData.photos \(responseData.photos)")
                self.photos.append(contentsOf: responseData.photos)
                self.onPhotosUpdated?() 
            }
        }
    }
}
