//
//  InfoCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-12.
//

import UIKit
import SnapKit

class InfoCell: UICollectionViewListCell {
    static let identifier = "InfoCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(infoImage)
    }

    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "Male"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()

    lazy var infoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .label
        return image
    }()

    func setupConstraints() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(50)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-20).multipliedBy(0.5)
        }
        rightLabel.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-25)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-20).multipliedBy(0.5)
        }
        infoImage.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(self).offset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
