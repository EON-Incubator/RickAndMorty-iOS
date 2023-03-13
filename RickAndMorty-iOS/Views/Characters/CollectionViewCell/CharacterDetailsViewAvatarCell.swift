//
//  CharacterDetailsViewCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit

class CharacterDetailsViewAvatarCell: UICollectionViewCell {
    static let identifier = "CharacterAvatarCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.addSubview(characterImage)
    }

    lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://picsum.photos/200/300"))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = self.bounds.height / 2
        return imageView
    }()

    func setupConstraints() {
        characterImage.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
