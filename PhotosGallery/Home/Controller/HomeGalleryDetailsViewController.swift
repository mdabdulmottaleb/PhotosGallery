//
//  HomeGalleryDetailsViewController.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class HomeGalleryDetailsViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showDownloadedImage: UIImageView!
    @IBOutlet weak var localImageGettingTxt: UILabel!
    @IBOutlet weak var deleteImgBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        setUpNavBar()
        if let photo = photo {
            let imageName = "photo_\(photo.id)"
            updateDownloadedImageDisplay(for: imageName)
        }
        deleteImgBtn.isHidden = true
    }
    
    private func loadImage() {
        guard let photo = photo else { return }
        if let url = URL(string: photo.src.original) {
            imageView.load(url: url)
        }
    }
    
    private func setUpNavBar() {
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(handleInfoButtonTapped)
        )
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func handleInfoButtonTapped() {
        guard let photo = photo else { return }
        
        // Fetch image data size asynchronously
        if let imageURL = URL(string: photo.src.original) {
            fetchImageData(from: imageURL) { [weak self] dataSize in
                guard let self = self else { return }
                
                // Once the data size is available, updating the UI on the main thread
                DispatchQueue.main.async {
                    InfoViewPresenter.presentInfoView(
                        from: self,
                        image: self.imageView.image,
                        photographer: "Photographer: \(photo.photographer)",
                        dimensions: "Dimensions: \(photo.width)x\(photo.height)",
                        originalURL: "Original URL: \(photo.src.original)",
                        size: "Size: \(dataSize)"
                    )
                }
            }
        }
    }
    
    
    @IBAction func downloadImage(_ sender: Any) {
        guard let image = imageView.image, let photo = photo else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Toast.shared.show(message: "Photo dosen't exist", in: self, backgroundColor: .red)
            }
            return
        }
        let imageName = "photo_\(photo.id)"
        LocalFileManager.instance.saveImage(image: image, name: imageName)
        updateDownloadedImageDisplay(for: imageName)
        Toast.shared.show(message: "Photo Downloade successfully", in: self, backgroundColor: .green)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        guard let photo = photo else {
            return
        }
        
        let imageName = "photo_\(photo.id)"
        if LocalFileManager.instance.fetchImageFromDirectory(imageName: imageName) == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Toast.shared.show(message: "Photo doesn't exist", in: self, backgroundColor: .red)
            }
            return
        }
        
        LocalFileManager.instance.deleteImage(imageName: imageName)
        updateDownloadedImageDisplay(for: imageName) // Update display after deletion
        Toast.shared.show(message: "Photo Deleted successfully", in: self, backgroundColor: .red)
    }
    
    private func fetchImageData(from url: URL, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let byteCount = data.count
                let size = self.formatSize(byteCount)
                completion(size)
            } catch {
                print("Failed to fetch image data: \(error.localizedDescription)")
                completion("Unknown")
            }
        }
    }
    
    private func updateDownloadedImageDisplay(for imageName: String) {
        if let savedImage = LocalFileManager.instance.fetchImageFromDirectory(imageName: imageName) {
            showDownloadedImage.image = savedImage
            localImageGettingTxt.text = "Photo from locally"
            deleteImgBtn.isHidden = false
            debugPrint("Loaded image: \(imageName)")
        } else {
            showDownloadedImage.image = nil // Clear the UIImageView if no image exists
            localImageGettingTxt.text = ""
            debugPrint("No image found for name: \(imageName)")
        }
    }
    
    private func formatSize(_ byteCount: Int) -> String {
        if byteCount >= 1_048_576 {
            let sizeMB = Double(byteCount) / 1_048_576
            return String(format: "%.2f MB", sizeMB)
        } else if byteCount >= 1_024 {
            let sizeKB = Double(byteCount) / 1_024
            return String(format: "%.2f KB", sizeKB)
        } else {
            return "\(byteCount) bytes"
        }
    }
    
}
