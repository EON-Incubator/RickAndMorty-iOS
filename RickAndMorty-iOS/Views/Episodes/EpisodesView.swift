//
//  EpisodesView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class EpisodesView: UIView {

    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
    }()

    var episodeCell = UICollectionView.CellRegistration<RowCell, AnyHashable> { (_ cell, _ indexPath, _ episode) in
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init() {
        super.init(frame: .zero)
        collectionView.showsVerticalScrollIndicator = false
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.backgroundColor = UIColor(named: "EpisodeView")
        collectionView.backgroundColor = UIColor(named: "EpisodeView")
        self.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaInsets).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
}

// MARK: - CollectionView Layout
extension EpisodesView {
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
