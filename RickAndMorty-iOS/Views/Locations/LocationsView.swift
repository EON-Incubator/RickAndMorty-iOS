//
//  LocationsView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit
import SnapKit

class LocationsView: UIView {

    let loadingView = LoadingView()

    lazy var collectionView: UICollectionView = { [weak self] in
        let collectionView = UICollectionView(frame: self?.bounds ?? CGRect.zero, collectionViewLayout: createLayout())
        collectionView.register(LocationRowCell.self,
                                forCellWithReuseIdentifier: LocationRowCell.identifier)

        collectionView.accessibilityIdentifier = K.Identifiers.locations
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: K.Colors.locationsView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
        return collectionView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor(named: K.Colors.locationsView)
        addSubview(collectionView)
        addSubview(loadingView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaInsets).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        loadingView.setupConstraints(view: self)
    }
}

// MARK: - CollectionView Layout
extension LocationsView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }

            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width

            let columns = sectionType.columnCount

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(effectiveWidth > 500 ? 0.5 : 1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))

            var group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: columns)

            if effectiveWidth > 500 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            }

            let section = NSCollectionLayoutSection(group: group)

            return section
        }
        return layout
    }
}
