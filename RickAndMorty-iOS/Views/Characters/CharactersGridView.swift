//
//  CharactersGridView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit
import SnapKit

class CharactersGridView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(collectionView)
    }

    lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.register(CharactersGridCell.self, forCellWithReuseIdentifier: CharactersGridCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersGridCell.identifier, for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharactersGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10, height: 150)
    }
}
