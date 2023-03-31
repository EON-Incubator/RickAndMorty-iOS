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
        backgroundColor = .systemBackground
        addSubview(collectionView)
        collectionView.accessibilityIdentifier = K.Identifiers.characterDetails
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.register(AvatarCell.self,
                                forCellWithReuseIdentifier: AvatarCell.identifier)
        collectionView.register(InfoCell.self,
                                forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: K.Headers.identifier)
        return collectionView
    }()

    let episodeCell = UICollectionView.CellRegistration<RowCell, RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode> { (cell, _ indexPath, episode) in
        cell.upperLabel.text = episode.name
        cell.lowerLeftLabel.text = episode.episode
        cell.lowerRightLabel.text = episode.air_date

        for index in 0...3 {
            let isIndexValid =  episode.characters.indices.contains(index)
            if isIndexValid {
                let urlString = episode.characters[index]?.image ?? ""
                cell.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 50, height: 50)])
            }
        }
    }
}

// MARK: - CollectionView Layout
extension CharacterDetailsView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }

            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width

            let columns = sectionType.columnCount

            var itemWidth = effectiveWidth > 500 ? 0.5 : 1.0

            if sectionType == .appearance || sectionType == .info || sectionType == .empty {
                itemWidth = 1.0
            }
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidth), heightDimension: .fractionalHeight(1.0))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            func getGroupHeight() -> NSCollectionLayoutDimension {
                switch sectionType {
                case .appearance, .empty:
                    return NSCollectionLayoutDimension.estimated(280)
                case .info, .location, .emptyInfo, .emptyLocation:
                    return NSCollectionLayoutDimension.estimated(60)
                default:
                    return NSCollectionLayoutDimension.estimated(100)
                }
            }

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: getGroupHeight())
            var group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: columns)

            if effectiveWidth > 500 && sectionType != .info {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            }

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            if (self?.collectionView.numberOfItems(inSection: sectionIndex) ?? 0) > 0 {
                section.boundarySupplementaryItems = [header]
            }
            return section
        }
        return layout
    }
}

extension CharacterDetailsView {
    func titleView(image: String?, title: String!) -> UIView {
        let titleWithImage = UIView()

        if let imageUrl = image {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 50, height: 50)])
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            titleWithImage.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(-10)
                make.bottom.leading.equalToSuperview()
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
        }

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: K.Fonts.primary, size: 27)
        titleLabel.textColor = .systemCyan
        titleLabel.shadowOffset = CGSize(width: 0.5, height: 1.5)
        titleLabel.shadowColor = UIColor(white: 0.2, alpha: 0.2)
        titleWithImage.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
        }

        return titleWithImage
    }
}
