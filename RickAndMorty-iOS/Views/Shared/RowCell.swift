//
//  RowCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class RowCell: UICollectionViewListCell {

    lazy var characterAvatarImageViews = [UIImageView]()

    lazy var characterAvatarsView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: K.Fonts.secondary, size: 18)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()

    lazy var lowerLeftLabel: UILabel = {
        let label = PaddingLabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        label.backgroundColor = K.Colors.episodeNumber
        return label
    }()

    lazy var lowerRightLabel: UILabel = {
        let label = PaddingLabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.backgroundColor = K.Colors.episodeDate
        label.layer.borderWidth = 0.3
        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]
        let myView = UIView(frame: bounds)
        myView.backgroundColor = UIColor(named: K.Colors.episodeCell)
        myView.layer.cornerRadius = 5
        backgroundView = myView
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for index in 0...3 {
            characterAvatarImageViews[index].image = UIImage(systemName: K.Images.systemPerson)?.withRenderingMode(.alwaysTemplate)
        }

        contentView.layer.sublayers?.removeAll()
    }

    override func layoutSubviews() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        // setup-shadows
        layer.shadowRadius = 2
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    func setupViews() {
        for index in 0...3 {
            let imageView = UIImageView(image: UIImage(systemName: K.Images.systemPerson)?.withRenderingMode(.alwaysTemplate))
            imageView.tintColor = .systemFill
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.width / 2
            characterAvatarImageViews.append(imageView)
            characterAvatarsView.addSubview(characterAvatarImageViews[index])
        }

        addSubview(characterAvatarsView)
        addSubview(upperLabel)
        addSubview(lowerLeftLabel)
        addSubview(lowerRightLabel)
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
            make.height.equalTo(25)
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

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 1
    @IBInspectable var bottomInset: CGFloat = 1
    @IBInspectable var leftInset: CGFloat = 3
    @IBInspectable var rightInset: CGFloat = 3

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
