//
//  CharacterDetailsView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit
import SnapKit

class CharacterDetailsView: UIView {

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
        collectionView.accessibilityIdentifier = "CharacterDetailsView"
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
        }
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(CharacterDetailsViewAvatarCell.self,
                                forCellWithReuseIdentifier: CharacterDetailsViewAvatarCell.identifier)
        collectionView.register(InfoCell.self,
                                forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderView")

        return collectionView
    }()
}

// MARK: - CollectionView Layout
extension CharacterDetailsView {
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

            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(310) : NSCollectionLayoutDimension.estimated(60)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
        return layout
    }
}
