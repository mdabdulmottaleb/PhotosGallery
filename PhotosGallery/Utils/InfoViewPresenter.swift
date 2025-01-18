//
//  InfoViewPresenter.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb Pro on 18/1/25.
//

import UIKit

class InfoViewPresenter {
    static func presentInfoView(from viewController: UIViewController, image: UIImage?, photographer: String?, dimensions: String?, originalURL: String?, size: String?) {
        let infoView = UIViewController()
        infoView.modalPresentationStyle = .pageSheet
        infoView.view.backgroundColor = .white

        if #available(iOS 15.0, *) {
            if let sheet = infoView.sheetPresentationController {
                // Allow full-screen presentation
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = 20
                sheet.largestUndimmedDetentIdentifier = .large // Keeps background dimmed only on full screen
            }
        } else {
            print("Sheet presentation is not supported on iOS versions below 15.0")
        }
        // Create and layout the content for the bottom view
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        // Image view
        let detailImageView = UIImageView()
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        detailImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        detailImageView.image = image

        // Labels
        let photographerLabel = UILabel()
        photographerLabel.text = photographer ?? "Photographer: Unknown"
        photographerLabel.numberOfLines = 0
        photographerLabel.textAlignment = .center
        photographerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let dimensionsLabel = UILabel()
        dimensionsLabel.text = dimensions ?? "Dimensions: Unknown"
        dimensionsLabel.numberOfLines = 0
        dimensionsLabel.textAlignment = .center
        dimensionsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let originalImageURLLabel = UILabel()
        originalImageURLLabel.text = originalURL ?? "Original URL: Unknown"
        originalImageURLLabel.numberOfLines = 0
        originalImageURLLabel.textAlignment = .center
        originalImageURLLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let sizeLabel = UILabel()
        sizeLabel.text = size ?? "Size: Unknown"
        sizeLabel.numberOfLines = 0
        sizeLabel.textAlignment = .center
        sizeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        // Add subviews to stack
        contentStack.addArrangedSubview(detailImageView)
        contentStack.addArrangedSubview(photographerLabel)
        contentStack.addArrangedSubview(dimensionsLabel)
        contentStack.addArrangedSubview(originalImageURLLabel)
        contentStack.addArrangedSubview(sizeLabel)
        // Add stack to view
        infoView.view.addSubview(contentStack)
        // Constrain stack to view
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: infoView.view.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: infoView.view.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: infoView.view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: infoView.view.trailingAnchor, constant: -16)
        ])

        viewController.present(infoView, animated: true)
    }
}
