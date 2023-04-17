//
//  SearchView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import UIKit

class SearchView: BaseView {

    let loadingView = LoadingView()

    let episodeCell = UICollectionView.CellRegistration<RowCell, AnyHashable> { (_ cell, _ indexPath, _ episode) in }
    
    let locationCell = UICollectionView.CellRegistration<LocationRowCell, RickAndMortyAPI.LocationDetails> { (cell, _ indexPath, location) in
        cell.lowerRightLabel.isHidden = false
        cell.upperLabel.text = location.name
        cell.lowerLeftLabel.text = location.type
        cell.lowerRightLabel.text = location.dimension

        if location.dimension == "" {
            cell.lowerRightLabel.isHidden = true
        }

        for index in 0...3 {
            let isIndexValid = location.residents.indices.contains(index)
            if isIndexValid {
                let urlString = location.residents[index]?.image ?? ""
                cell.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
            }
        }
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.register(CharacterRowCell.self,
                                forCellWithReuseIdentifier: CharacterRowCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: K.Headers.identifier)
        collectionView.register(LoadMoreCell.self,
                                forCellWithReuseIdentifier: LoadMoreCell.identifier)
        return collectionView
    }()

    lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: K.Fonts.primary, size: 30)
        label.text = "Search for something ..."
        label.textAlignment = .center
        return label
    }()

    override init() {
        super.init()
        collectionView.showsVerticalScrollIndicator = false
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor(named: K.Colors.episodeView)
        collectionView.backgroundColor = UIColor(named: K.Colors.episodeView)
        addSubview(collectionView)
        addSubview(middleLabel)
        addSubview(loadingView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        middleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(safeAreaLayoutGuide).inset(10)
            make.right.equalTo(safeAreaLayoutGuide).inset(10)
        }
        loadingView.setupConstraints(view: self)
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }

            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width

            let columns = sectionType.columnCount

            var itemWidth = effectiveWidth > 500 ? 0.5 : 1.0

            // width of load more btn
            if sectionType == Section.episodes || sectionType == Section.info {
                itemWidth = 1.0
            }

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth), heightDimension: .fractionalHeight(1.0))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupHeight = sectionType == Section.episodes || sectionType == Section.info ?  NSCollectionLayoutDimension.estimated(50) : NSCollectionLayoutDimension.estimated(100)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)

            var group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: columns)

            if effectiveWidth > 500 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            }

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

            if self?.collectionView.numberOfItems(inSection: sectionIndex) ?? 0 > 0 && sectionType != Section.episodes && sectionType != Section.info {
                section.boundarySupplementaryItems = [header]
            }
            return section
        }
        return layout
    }
}
