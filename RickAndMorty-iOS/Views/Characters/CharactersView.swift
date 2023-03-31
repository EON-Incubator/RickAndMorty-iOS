//
//  CharactersGridView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit
import SnapKit

class CharactersView: UIView {

    let loadingView = LoadingView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(collectionView)
        addSubview(loadingView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.accessibilityIdentifier = K.Identifiers.characters
        collectionView.register(CharacterGridCell.self, forCellWithReuseIdentifier: CharacterGridCell.identifier)
        return collectionView
    }()

    func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(effectiveWidth > 500 ? 0.33 : 0.5),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(170))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: effectiveWidth > 500 ? 3 : 2)

            let spacing = CGFloat(10)
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing

            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaInsets).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        loadingView.setupConstraints(view: self)
    }
}

extension CharactersView {
    func filterButton(_ target: Any?, action: Selector) -> UIBarButtonItem {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        filterButton.layer.cornerRadius = 15
        filterButton.tintColor = .black
        filterButton.backgroundColor = K.Colors.filterButton
        filterButton.setTitle(K.Titles.filter, for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.white, for: .highlighted)
        filterButton.titleLabel?.font = .systemFont(ofSize: 12)
        filterButton.setImage(UIImage(named: K.Images.filter), for: .normal)
        filterButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: filterButton)
    }

    func logoView() -> UIBarButtonItem {
        let imageView = UIImageView(image: UIImage(named: K.Images.logo))
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return UIBarButtonItem(customView: imageView)
    }
}
