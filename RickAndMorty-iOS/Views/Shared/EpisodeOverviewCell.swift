//
//  EpisodeOverview.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-10.
//

import UIKit

class EpisodeOverviewCell: UICollectionViewListCell {

    static let identifier = "EpisodeOverviewCell"

    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: K.Fonts.secondary, size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 0
        return label
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
        let myView = UIView(frame: bounds)
        myView.layer.opacity = 0.0
        backgroundView = myView
        layer.cornerRadius = 5
        addSubview(centerLabel)
    }

    func setupConstraints() {
        centerLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(2)
            make.right.equalTo(self).offset(-2)
            make.top.equalTo(self).offset(-12)
            make.bottom.equalTo(self).offset(-1)
        }
    }
}
