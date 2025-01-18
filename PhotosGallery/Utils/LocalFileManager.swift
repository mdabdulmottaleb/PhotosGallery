//
//  LocalFileManager.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    func saveImage(image: UIImage, name: String) {
        
        guard let data = image.jpegData(compressionQuality: 1.0), let directoryPath = getImagePath(imageName: name) else {
            print("Error getting data..")
            return
        }
        
        do{
            try data.write(to: directoryPath)
            debugPrint("Successed saving image")
        }catch let savingError {
            debugPrint("Error saving \(savingError)")
        }
    }
    
    func fetchImageFromDirectory(imageName: String) -> UIImage?{
        
        guard let directoryPath = getImagePath(imageName: imageName)?.path, FileManager.default.fileExists(atPath: directoryPath) else {
            debugPrint("Error getting on path to fetch")
            return nil
        }
        return UIImage(contentsOfFile: directoryPath)
    }
    
    func getImagePath(imageName: String) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(imageName).jpg") else {
            debugPrint("Error getting on path")
            return nil
        }
        return path
    }
    
    func deleteImage(imageName: String){
        guard let directoryPath = getImagePath(imageName: imageName), FileManager.default.fileExists(atPath: directoryPath.path) else {
            debugPrint("Error getting on path to fetch")
            return
        }
        do {
            try FileManager.default.removeItem(at: directoryPath)
            debugPrint("SuccessFully Deleted")
        } catch let filePathError {
            debugPrint("filePathError \(filePathError)")
        }
    }
}
