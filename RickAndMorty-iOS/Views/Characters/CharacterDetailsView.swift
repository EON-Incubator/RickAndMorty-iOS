//
//  CharacterDetailsView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit
import SnapKit

enum Section: Int, CaseIterable {
    case appearance
    case info
    var columnCount: Int {
        switch self {
        case .appearance:
            return 1
        case .info:
            return 3
        }
    }
}

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
        configureDataSource()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
        }
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private var dataSource: DataSource!

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

            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(310) : NSCollectionLayoutDimension.fractionalWidth(0.50)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
        return layout
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, _ item) -> UICollectionViewCell? in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailsViewAvatarCell.identifier, for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath)
                return cell
            }

        })
        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = "\(Section.allCases[indexPath.section])".uppercased()
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.appearance, .info])
        snapshot.appendItems([1], toSection: .appearance)
        snapshot.appendItems(Array(2...4), toSection: .info)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
