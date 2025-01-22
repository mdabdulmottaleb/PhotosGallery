//
//  HomeGalleryDetailsViewController.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//
// Almost Done!
import UIKit

class HomeGalleryDetailsViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var textForServerImg: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showDownloadedImage: UIImageView!
    @IBOutlet weak var localImageGettingTxt: UILabel!
    @IBOutlet weak var downloadImgBtn: UIButton!
    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var shareImgBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        setUpNavBar()
        downloadImgBtn.isHidden = true
        shareImgBtn.isHidden = true
        deleteImgBtn.isHidden = true
        if let photo = photo {
            let imageName = "photo_\(photo.id)"
            updateDownloadedImageDisplay(for: imageName)
        }
        localImageTapGesture()
    }
    
    private func loadImage() {
        guard let photo = photo else { return }
        if let url = URL(string: photo.src.large) {
            imageView.load(url: url)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.textForServerImg.text = "Photo from Array"
                self.downloadImgBtn.isHidden = false
            }
            
            
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
        if let imageURL = URL(string: photo.src.small) {
            fetchImageData(from: imageURL) { [weak self] dataSize in
                guard let self = self else { return }
                
                // Once the data size is available, updating the UI on the main thread
                DispatchQueue.main.async {
                    InfoViewPresenter.presentInfoView(
                        from: self,
                        image: self.imageView.image,
                        photographer: "Photographer: \(photo.photographer)",
                        dimensions: "Dimensions: \(photo.width)x\(photo.height)",
                        originalURL: "small URL: \(photo.src.original)",
                        size: "Size: \(dataSize)"
                    )
                }
            }
        }
    }
    //Local Image tapped
    private func localImageTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImageFullScreen))
        showDownloadedImage.isUserInteractionEnabled = true
        showDownloadedImage.addGestureRecognizer(tapGesture)
    }
    // full scren and dismis
    @objc private func showImageFullScreen() {
        guard let image = showDownloadedImage.image else { return }
        
        let fullScreenVC = UIViewController()
        fullScreenVC.view.backgroundColor = .black
        fullScreenVC.modalPresentationStyle = .fullScreen
        
        let fullScreenImageView = UIImageView(image: image)
        fullScreenImageView.contentMode = .scaleAspectFit
        fullScreenImageView.frame = fullScreenVC.view.frame
        fullScreenImageView.isUserInteractionEnabled = true
   
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        fullScreenImageView.addGestureRecognizer(dismissGesture)
        
        fullScreenVC.view.addSubview(fullScreenImageView)
        self.present(fullScreenVC, animated: true, completion: nil)
    }

    @objc private func dismissFullScreenImage(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func shareImgBtn(_ sender: Any) {
        
        guard let photo = photo else { return }
        let activityVC = UIActivityViewController(activityItems: [photo.src.original], applicationActivities: nil)
        self.present(activityVC, animated: true)
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
            shareImgBtn.isHidden = false
            deleteImgBtn.isHidden = false
            
            debugPrint("Loaded image: \(imageName)")
        } else {
            showDownloadedImage.image = nil // Clear the UIImageView if no image exists
            localImageGettingTxt.text = ""
            shareImgBtn.isHidden = true
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
