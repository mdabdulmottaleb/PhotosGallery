//
//  ToastShowing.swift
//  PhotosGallery
//
//  Created by Md Abdul Mottaleb on 18/1/25.
//

import UIKit

class Toast {
    static let shared = Toast() // Singleton instance

    private init() {}

    /// Show a toast message
    func show(message: String, in viewController: UIViewController, duration: Double = 2.0, backgroundColor: UIColor = .black, textColor: UIColor = .white) {
        // Create the label for the toast
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = textColor
        toastLabel.backgroundColor = backgroundColor.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        // Calculate size and position
        let maxSize = CGSize(width: viewController.view.frame.size.width - 40, height: viewController.view.frame.size.height - 40)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width += 20
        expectedSize.height += 10

        toastLabel.frame = CGRect(
            x: (viewController.view.frame.size.width - expectedSize.width) / 2,
            y: viewController.view.frame.size.height - expectedSize.height - 60,
            width: expectedSize.width,
            height: expectedSize.height
        )

        // Add to the view
        viewController.view.addSubview(toastLabel)

        // Show animation
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
