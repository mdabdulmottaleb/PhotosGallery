//
//  HomeGalleryModel.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import Foundation

struct PhotoResponse: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let src: PhotoSource
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case src
    }
}

struct PhotoSource: Codable {
    let original: String
    let large: String
    let medium: String
    let small: String
}
