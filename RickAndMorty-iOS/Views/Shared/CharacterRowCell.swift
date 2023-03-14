//
//  CharacterRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit

class CharacterRowCell: UICollectionViewCell {

    static let identifier = "CharacterRowCell"

    lazy var characterAvatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var characterStatusView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.text = "Character Name"
        label.font = .boldSystemFont(ofSize: 26)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = UILabel()
        label.text = "Species"
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemYellow
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

        self.addSubview(characterAvatarImageView)
        self.addSubview(characterStatusView)
        self.addSubview(upperLabel)
        self.addSubview(lowerLeftLabel)
        self.addSubview(lowerRightLabel)

    }

    func setupConstraints() {
        characterAvatarImageView.snp.makeConstraints { make in
            // make.top.left.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
            make.width.equalTo(self.snp.height).offset(-20).multipliedBy(1.0 / 1.0)
        }

        upperLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.width.equalToSuperview().offset(-100)
        }

        lowerLeftLabel.snp.makeConstraints { make in
            make.top.equalTo(upperLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(upperLabel)
            make.height.equalTo(30)
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
