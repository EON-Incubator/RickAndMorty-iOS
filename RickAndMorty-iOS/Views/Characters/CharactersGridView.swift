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
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(CharactersGridCell.self, forCellWithReuseIdentifier: CharactersGridCell.identifier)
        return collectionView
    }()

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)

        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
}

extension CharactersGridView {
    func filterButton(_ target: Any?, action: Selector) -> UIBarButtonItem {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        filterButton.layer.cornerRadius = 15
        filterButton.tintColor = .black
        filterButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.81, alpha: 1.00)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.white, for: .highlighted)
        filterButton.titleLabel?.font = .systemFont(ofSize: 12)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: filterButton)
    }

    func logoView() -> UIBarButtonItem {
        let imageView = UIImageView(image: UIImage(named: "RickAndMorty"))
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return UIBarButtonItem(customView: imageView)
    }
}
