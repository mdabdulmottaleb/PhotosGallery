//
//  HomeGalleryService.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb Pro on 18/1/25.
//

import UIKit

class HomeGalleryService: NSObject{
    
    let url: URL
    var isFetching: Bool
    
    init(url: URL, isFetching: Bool) {
        self.url = url
        self.isFetching = isFetching
    }
    
    func fetchCuratedPhotos(perPage: Int = 20, page: Int = 1, completion: @escaping (PhotoResponse) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        
        
        let parameters: [String: Any] = [
            "per_page": perPage,
            "page": page
        ]
        let headers: HTTPHeaders = [
            "Authorization": "2a8PbTSmCXFWj9am67vIh3NqbQdYBg2iiCqLa24MEG6ygNsUj9TSSsQE"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: PhotoResponse.self) { [weak self] response in
                guard let self = self else { return }
                self.isFetching = false
                switch response.result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            }
    }
}
