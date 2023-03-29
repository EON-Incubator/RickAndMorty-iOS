//
//  RowCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class RowCell: UICollectionViewListCell {

    lazy var characterAvatarImageViews = [UIImageView]()

    override func prepareForReuse() {
        super.prepareForReuse()
        for index in 0...3 {
            self.characterAvatarImageViews[index].image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        }

        self.contentView.layer.sublayers?.removeAll()
    }

    lazy var characterAvatarsView: UIView = {
        let view = UIView()
        return view
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]
        let myView = UIView(frame: self.bounds)
        myView.backgroundColor = UIColor(named: "EpisodeCell")
        myView.layer.cornerRadius = 5
        self.backgroundView = myView
        setupViews()
        setupConstraints()
    }

    lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE Regular", size: 18)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        label.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.66, alpha: 0.4)
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.backgroundColor = UIColor(red: 1.00, green: 0.92, blue: 0.71, alpha: 0.4)
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()

    override func layoutSubviews() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        // setup-shadows
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    func setupViews() {
        for index in 0...3 {
            let imageView = UIImageView(image: UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .systemFill
            imageView.contentMode = .scaleAspectFill
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
            make.width.equalTo(snp.height).multipliedBy(1.0 / 1.0)
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
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }

        lowerLeftLabel.snp.makeConstraints { make in
            make.left.equalTo(upperLabel)
            make.height.equalTo(20)
            make.width.equalTo(upperLabel).dividedBy(2).offset(-30)
            make.bottom.equalToSuperview().offset(-10)
        }

        lowerRightLabel.snp.makeConstraints { make in
            make.top.equalTo(lowerLeftLabel)
            make.left.equalTo(lowerLeftLabel.snp_rightMargin).offset(20)
            make.height.equalTo(lowerLeftLabel)
            make.width.equalTo(upperLabel).dividedBy(2)
        }
    }
}
