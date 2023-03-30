//
//  LoadMoreCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-24.
//

import UIKit
import SnapKit

class LoadMoreCell: UICollectionViewListCell {

    static let identifier = "LoadMoreCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    override func prepareForReuse() {
            super.prepareForReuse()
            self.contentView.layer.sublayers?.removeAll()
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        let myView = UIView(frame: self.bounds)
        myView.layer.opacity = 0.0
        self.backgroundView = myView
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
        self.addSubview(centerLabel)
    }

    lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "↓    Load More   ↓"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    func setupConstraints() {
        centerLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}
