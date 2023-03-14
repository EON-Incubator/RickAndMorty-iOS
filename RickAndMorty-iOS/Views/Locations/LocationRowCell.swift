//
//  LocationRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit

class LocationRowCell: UICollectionViewCell {

    static let identifier = "LocationRowCell"

    lazy var characterAvatarImageViews = [UIImageView]()

    lazy var characterAvatarsView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.text = "Location Name"
        label.font = .boldSystemFont(ofSize: 26)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = UILabel()
        label.text = "Dimension"
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemBrown
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5

        for index in 0...3 {
            let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
            imageView.tintColor = .systemGray3
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .systemGray6
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.width / 2
            characterAvatarImageViews.append(imageView)
            characterAvatarsView.addSubview(characterAvatarImageViews[index])
        }

        self.addSubview(characterAvatarsView)
        self.addSubview(upperLabel)
        self.addSubview(lowerLeftLabel)
        self.addSubview(lowerRightLabel)
    }

    func setupConstraints() {
        characterAvatarsView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(2)
            make.height.equalToSuperview().offset(-8)
            make.width.equalTo(self.snp.height).multipliedBy(1.0 / 1.0)
        }

        characterAvatarImageViews[0].snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(2)
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }

        characterAvatarImageViews[1].snp.makeConstraints { make in
            make.top.right.equalToSuperview().offset(2)
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }

        characterAvatarImageViews[2].snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().offset(2)
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }

        characterAvatarImageViews[3].snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(2)
            make.width.height.equalToSuperview().dividedBy(2).offset(-1)
        }

        upperLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.width.equalToSuperview().offset(-100)
        }

        lowerLeftLabel.snp.makeConstraints { make in
            make.top.equalTo(upperLabel.snp_bottomMargin).offset(30)
            make.left.equalTo(upperLabel)
            make.height.equalTo(20)
            make.width.equalTo(upperLabel).dividedBy(2).offset(-30)
        }

        lowerRightLabel.snp.makeConstraints { make in
            make.top.equalTo(lowerLeftLabel)
            make.left.equalTo(lowerLeftLabel.snp_rightMargin).offset(20)
            make.height.equalTo(lowerLeftLabel)
            make.width.equalTo(upperLabel).dividedBy(2)
        }
    }
}
