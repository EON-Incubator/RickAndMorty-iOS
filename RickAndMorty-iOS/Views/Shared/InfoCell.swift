//
//  InfoCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-12.
//

import UIKit
import SnapKit

class InfoCell: UICollectionViewListCell {
    static let identifier = K.Info.identifier

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        self.isUserInteractionEnabled = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.layer.sublayers?.removeAll()
    }

    static func configCell(cell: InfoCell, leftLabel: String, rightLabel: String, infoImage: UIImage) -> InfoCell {
        cell.leftLabel.text = leftLabel
        cell.rightLabel.text = rightLabel
        cell.infoImage.image = infoImage.withRenderingMode(.alwaysTemplate)
        cell.infoImage.tintColor = UIColor(named: K.Colors.infoCell)
        if (leftLabel == "Origin" || leftLabel == "Last Seen") && (rightLabel != "unknown") {
            cell.accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]
            cell.isUserInteractionEnabled = true
        }
        return cell
    }

    func setupViews() {
        let myView = UIView(frame: self.bounds)
        myView.backgroundColor = .secondarySystemBackground
        self.backgroundView = myView
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(infoImage)
    }

    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: K.Colors.infoCell)
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()

    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: K.Colors.infoCell)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()

    lazy var infoImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    func setupConstraints() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-20).multipliedBy(0.5)
        }
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-20).multipliedBy(0.5)
        }
        infoImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
