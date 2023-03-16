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
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
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

    var episodeCell = UICollectionView.CellRegistration<RowCell, RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode> { (cell, _ indexPath, episode) in
        cell.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.66, alpha: 0.1)

        cell.lowerRightLabel.backgroundColor = UIColor(red: 1.00,
                                                  green: 0.92,
                                                  blue: 0.71,
                                                  alpha: 0.4)
        cell.lowerRightLabel.layer.borderWidth = 0.3
        cell.lowerRightLabel.layer.borderColor = UIColor.gray.cgColor

        cell.lowerLeftLabel.layer.borderWidth = 0.3
        cell.lowerLeftLabel.layer.borderColor = UIColor.gray.cgColor
        cell.lowerLeftLabel.backgroundColor = UIColor(red: 1.00,
                                                 green: 0.75,
                                                 blue: 0.66,
                                                 alpha: 0.4)
        cell.upperLabel.text = episode.name
        cell.lowerLeftLabel.text = episode.episode
        cell.lowerRightLabel.text = episode.air_date

        for index in 0...3 {
            let isIndexValid =  episode.characters.indices.contains(index)
            if isIndexValid {
                let urlString = episode.characters[index]?.image ?? ""
                cell.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString))
            }
        }
    }
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

            func getGroupHeight() -> NSCollectionLayoutDimension {
                switch sectionType {
                case .appearance:
                    return NSCollectionLayoutDimension.estimated(280)
                case .info, .location:
                    return NSCollectionLayoutDimension.estimated(60)
                default:
                    return NSCollectionLayoutDimension.estimated(100)
                }
            }

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: getGroupHeight())
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
