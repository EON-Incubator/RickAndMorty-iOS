//
//  CharactersGridView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit

class CharactersGridView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    private func setupViews() {
        self.backgroundColor = .systemBackground
    }

}
