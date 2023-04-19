//
//  CarouselCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-11.
//

import UIKit

class CarouselCell: UICollectionViewListCell {

    static let identifier = K.Identifiers.carouselCell

    lazy var carouselImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.sublayers?.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(carouselImage)
    }

    func setupConstraints() {
        carouselImage.snp.makeConstraints { make in
            make.left.equalTo(self).offset(2)
            make.right.equalTo(self).offset(-2)
            make.top.equalTo(self).offset(-2)
            make.bottom.equalTo(self)
        }
    }

}
