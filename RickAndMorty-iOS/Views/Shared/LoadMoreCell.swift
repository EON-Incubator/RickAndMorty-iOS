//
//  LoadMoreCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-24.
//

import UIKit
import SnapKit

class LoadMoreCell: UICollectionViewListCell {

    static let identifier = K.Identifiers.loadMoreCell

    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "↓    Load More   ↓"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
            super.prepareForReuse()
            contentView.layer.sublayers?.removeAll()
        }

    func setupViews() {
        let myView = UIView(frame: bounds)
        myView.layer.opacity = 0.0
        backgroundView = myView
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        addSubview(centerLabel)
    }

    func setupConstraints() {
        centerLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}
