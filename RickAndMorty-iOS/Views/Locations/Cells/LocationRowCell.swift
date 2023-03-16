//
//  LocationRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit

class LocationRowCell: RowCell {

    static let identifier = "LocationRowCell"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addStyles()
        setupConstraints()
    }

    func addStyles() {
        self.contentView.backgroundColor = UIColor(red: 0.99, green: 0.89, blue: 0.54, alpha: 0.1)

        lowerRightLabel.backgroundColor = UIColor(red: 0.87, green: 0.99, blue: 0.98, alpha: 0.4)
        lowerRightLabel.layer.borderWidth = 0.3
        lowerRightLabel.layer.borderColor = UIColor.gray.cgColor

        lowerLeftLabel.layer.borderWidth = 0.3
        lowerLeftLabel.layer.borderColor = UIColor.gray.cgColor
        lowerLeftLabel.backgroundColor = UIColor(red: 1.00,
                                                 green: 0.75,
                                                 blue: 0.66,
                                                 alpha: 0.4)

    }
}
