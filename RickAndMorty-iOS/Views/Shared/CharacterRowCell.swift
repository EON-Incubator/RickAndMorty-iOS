//
//  CharacterRowCell.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit

class CharacterRowCell: UICollectionViewListCell {

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

    lazy var characterStatusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .semibold)
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
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBackground
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.40, green: 0.20, blue: 0.50, alpha: 0.9)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBackground
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.87, green: 0.47, blue: 0.34, alpha: 0.9)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        let myView = UIView(frame: self.bounds)
        myView.backgroundColor = UIColor(named: "characterRowBackgroundColor")
        self.backgroundView = myView
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.addSubview(characterAvatarImageView)
        self.addSubview(characterStatusLabel)
        self.addSubview(upperLabel)
        self.addSubview(lowerLeftLabel)
        self.addSubview(lowerRightLabel)
    }

    enum CharacterStatus: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
        var description: String {
            return self.rawValue
        }
    }

    func statusColor(_ color: String) -> UIColor {
        switch color {
        case CharacterStatus.alive.description:
            return .systemGreen
        case CharacterStatus.dead.description:
            return .systemRed
        case CharacterStatus.unknown.description:
            return .systemYellow
        default:
            return .systemGray
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
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.width.equalToSuperview().offset(-110)
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
