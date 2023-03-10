//
//  CharacterDetailsViewCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit

class CharacterDetailsViewAvatarCell: UICollectionViewCell {
    static let identifier = "CharacterDetailsCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.backgroundColor = .gray
    }
}
