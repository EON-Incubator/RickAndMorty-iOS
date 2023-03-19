//
//  SearchView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import UIKit

class SearchView: UIView {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.register(CharacterRowCell.self,
                                forCellWithReuseIdentifier: CharacterRowCell.identifier)
        return collectionView
    }()

    var locationCell = UICollectionView.CellRegistration<RowCell, RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result> { (cell, _ indexPath, location) in
        cell.contentView.backgroundColor = UIColor(red: 0.93, green: 0.95, blue: 1.00, alpha: 0.5)

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
        cell.upperLabel.text = location.name
        cell.lowerLeftLabel.text = location.type
        cell.lowerRightLabel.text = location.dimension

        for index in 0...3 {
            let isIndexValid = location.residents.indices.contains(index)
            if isIndexValid {
                let urlString = location.residents[index]?.image ?? ""
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
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }

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
