//
//  EmptyData.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-21.
//
import Foundation
import UIKit

struct EmptyData: Hashable {
    let id: UUID
}

extension UICollectionViewCell {
    func showLoadingAnimation() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, light, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]

        gradient.frame = CGRect(x: -self.contentView.bounds.width, y: 0, width: self.contentView.bounds.width * 3, height: self.contentView.bounds.height)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]

        animation.repeatCount = .infinity
        animation.duration = 1.1
        animation.isRemovedOnCompletion = false

        gradient.add(animation, forKey: "shimmer")

        self.contentView.layer.addSublayer(gradient)
    }
}
