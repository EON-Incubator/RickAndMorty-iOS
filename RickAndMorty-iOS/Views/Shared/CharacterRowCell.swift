//
//  CharacterRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit

class CharacterRowCell: UICollectionViewListCell {

    enum CharacterStatus: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
        var description: String {
            return rawValue
        }
    }

    static let identifier = K.Identifiers.characterRowCell

    lazy var characterAvatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: K.Images.systemPerson))
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var characterStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: K.Fonts.secondary, size: 13)

        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .systemGray
        label.transform = CGAffineTransform(rotationAngle: -0.70)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 1

        return label
    }()

    lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: K.Fonts.secondary, size: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = K.Colors.gender
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = K.Colors.species
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.sublayers?.removeAll()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    func setupViews() {
        let myView = UIView(frame: bounds)
        myView.backgroundColor = UIColor(named: K.Colors.characterRow)?.withAlphaComponent(0.7)
        backgroundView = myView

        addSubview(characterAvatarImageView)
        addSubview(characterStatusLabel)
        addSubview(upperLabel)
        addSubview(lowerLeftLabel)
        addSubview(lowerRightLabel)
    }

    func statusColor(_ color: String) -> UIColor {
        switch color {
        case CharacterStatus.alive.description:
            return .systemGreen.withAlphaComponent(0.8)
        case CharacterStatus.dead.description:
            characterStatusLabel.textColor = .white
            return .systemRed.withAlphaComponent(0.8)
        case CharacterStatus.unknown.description:
            return .systemYellow.withAlphaComponent(0.8)
        default:
            return .systemGray.withAlphaComponent(0.8)
        }
    }

    func setupConstraints() {
        characterAvatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
            make.width.equalTo(snp.height).offset(-20).multipliedBy(1.0 / 1.0)
        }

        upperLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
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

        characterStatusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
    }
}
