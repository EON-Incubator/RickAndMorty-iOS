//
//  EpisodeDetails.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import SnapKit

class EpisodeDetailsView: UIView {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderView")
        collectionView.register(InfoCell.self,
                                forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(CharacterRowCell.self,
                                forCellWithReuseIdentifier: CharacterRowCell.identifier)

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
        collectionView.accessibilityIdentifier = "EpisodeDetailsCollectionView"
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
}

// MARK: - CollectionView Layout
extension EpisodeDetailsView {
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

            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.estimated(60) :
                                             NSCollectionLayoutDimension.estimated(100)

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