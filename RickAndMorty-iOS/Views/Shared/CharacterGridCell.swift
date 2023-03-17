//
//  CharactersGridCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-09.
//

import UIKit
import SnapKit

class CharacterGridCell: UICollectionViewCell {

    static let identifier = "CharacterCell"

    lazy var characterNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 0.7)
        label.textColor = .black
        return label
    }()

    lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = self.layer.cornerRadius
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10
        self.addSubview(characterImage)
        self.addSubview(characterNameLabel)
    }

    func setupConstraints() {
        characterImage.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        characterNameLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
