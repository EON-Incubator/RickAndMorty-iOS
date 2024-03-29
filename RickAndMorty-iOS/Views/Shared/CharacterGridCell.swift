//
//  CharactersGridCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-09.
//

import UIKit
import SnapKit

class CharacterGridCell: UICollectionViewCell {

    static let identifier = K.Identifiers.characterCell

    lazy var characterNameLabel: UILabel = { [weak self] in
        let label = PaddingLabel()
        label.textAlignment = .center
        label.backgroundColor = K.Colors.characterNameLabel
        label.textColor = .black
        label.font = UIFont(name: K.Fonts.secondary, size: 18)
        label.layer.cornerRadius = self?.layer.cornerRadius ?? 0
        label.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        label.clipsToBounds = true
        return label
    }()

    lazy var characterImage: UIImageView = { [weak self] in
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = self?.layer.cornerRadius ?? 0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.sublayers?.removeAll()
    }

    func setupViews() {
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        addSubview(characterImage)
        addSubview(characterNameLabel)
    }

    func setupConstraints() {
        characterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        characterNameLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
