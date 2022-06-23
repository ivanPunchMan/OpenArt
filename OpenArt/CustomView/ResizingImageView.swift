//
//  ExtensionUIImage.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 15.06.2022.
//

import UIKit


class ResizingImageView: UIImageView {
    var aspectRatio: NSLayoutConstraint?

    func setImageAndUpdateAspectRatio(image: UIImage) {
        self.image = image

        self.aspectRatio?.isActive = false
        if image.size.width > 0 {
            self.aspectRatio = self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: image.size.height / image.size.width)
            self.aspectRatio?.priority = UILayoutPriority(998)
        }
        self.aspectRatio?.isActive = true
    }
}
