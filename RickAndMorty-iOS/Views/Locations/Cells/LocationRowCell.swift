//
//  LocationRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit

class LocationRowCell: RowCell {

    static let identifier = K.Identifiers.locationRowCell

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addStyles()
    }

    func addStyles() {
        let myView = UIView(frame: bounds)
        myView.backgroundColor = UIColor(named: K.Colors.locationCell)
        backgroundView = myView
        lowerRightLabel.backgroundColor = K.Colors.dimension
        lowerRightLabel.layer.borderWidth = 0.3
        lowerRightLabel.layer.borderColor = UIColor.gray.cgColor
        lowerRightLabel.textColor = .black

        lowerLeftLabel.textColor = .black
        lowerLeftLabel.layer.borderWidth = 0.3
        lowerLeftLabel.layer.borderColor = UIColor.gray.cgColor
        lowerLeftLabel.backgroundColor = K.Colors.type

    }
}
