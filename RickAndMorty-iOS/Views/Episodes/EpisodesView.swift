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

    var episodeCell = UICollectionView.CellRegistration<RowCell, RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result> { (cell, _ indexPath, episode) in
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
        self.backgroundColor = .systemBackground
        self.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
}

// MARK: - CollectionView Layout
extension EpisodesView {
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
