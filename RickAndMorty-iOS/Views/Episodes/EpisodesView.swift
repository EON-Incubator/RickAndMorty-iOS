//
//  EpisodesView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class EpisodesView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
//        setupConstraints()
    }

    private func setupViews() {
        self.backgroundColor = .systemBackground
//        self.addSubview(collectionView)
    }
}
