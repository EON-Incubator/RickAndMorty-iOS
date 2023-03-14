//
//  EpisodeRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class EpisodeRowCell: RowCell {
    static let identifier = "EpisodeRowCell"

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
        self.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.66, alpha: 0.1)

        lowerRightLabel.backgroundColor = UIColor(red: 1.00,
                                                  green: 0.92,
                                                  blue: 0.71,
                                                  alpha: 0.4)
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
