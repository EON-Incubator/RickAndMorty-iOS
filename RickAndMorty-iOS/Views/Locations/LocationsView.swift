//
//  LocationsView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit
import SnapKit

class LocationsView: UIView {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private var dataSource: DataSource!

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(LocationRowCell.self,
                                forCellWithReuseIdentifier: LocationRowCell.identifier)

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
        self.backgroundColor = .systemBackground
        self.addSubview(collectionView)
        configureDataSource()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }

}

// MARK: - CollectionView Layout
extension LocationsView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in

            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }

            let columns = sectionType.columnCount

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupHeight = NSCollectionLayoutDimension.estimated(100)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)

            return section
        }
        return layout
    }
}

// MARK: - CollectionView DataSource
extension LocationsView {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _ item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationRowCell.identifier, for: indexPath)
            return cell
        })

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.appearance])
        snapshot.appendItems([1, 2], toSection: .appearance)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
