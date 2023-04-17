//
//  EpisodeDetails.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import SnapKit

class EpisodeDetailsView: BaseView {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: K.Headers.identifier)
        collectionView.register(InfoCell.self,
                                forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(CharacterRowCell.self,
                                forCellWithReuseIdentifier: CharacterRowCell.identifier)
        collectionView.register(EpisodeOverviewCell.self,
                                forCellWithReuseIdentifier: EpisodeOverviewCell.identifier)
        collectionView.register(CarouselCell.self,
                                forCellWithReuseIdentifier: CarouselCell.identifier)

        return collectionView
    }()

    override init() {
        super.init()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = UIColor(named: K.Colors.episodeView)
        collectionView.backgroundColor = UIColor(named: K.Colors.episodeView)
        addSubview(collectionView)
        collectionView.accessibilityIdentifier = K.Identifiers.episodeDetails
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
}

// MARK: - CollectionView Layout
extension EpisodeDetailsView {

    private func getGroupHeight(sectionIndex: Int) -> NSCollectionLayoutDimension {
        var groupHeight: NSCollectionLayoutDimension

        switch sectionIndex {
        case 0:
            groupHeight = NSCollectionLayoutDimension.estimated(200)
        case 2:
            groupHeight = NSCollectionLayoutDimension.estimated(60)
        case 4:
            groupHeight = NSCollectionLayoutDimension.estimated(200)
        case 6:
            groupHeight = NSCollectionLayoutDimension.estimated(60)
        default:
            groupHeight = NSCollectionLayoutDimension.estimated(100)
        }

        // hide empty sections (for loading skeleton)
        if self.collectionView.numberOfItems(inSection: sectionIndex) < 1 {
            groupHeight = NSCollectionLayoutDimension.absolute(0.1)
        }

        return groupHeight
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width

            let screenOrientation = effectiveWidth > 500 ? "landscape" : "potrait"

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            if sectionIndex == 0 {
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            }

            var groupWidth: NSCollectionLayoutDimension

            if sectionIndex == 0 {
                groupWidth = screenOrientation == "potrait" ? .fractionalWidth(0.95) : .fractionalWidth(0.7)
            } else if sectionIndex == 3 {
                groupWidth = screenOrientation == "potrait" ? .fractionalWidth(1.0) : .fractionalWidth(0.5)
            } else {
                groupWidth = .fractionalWidth(1.0)
            }

            guard let groupHeight = self?.getGroupHeight(sectionIndex: sectionIndex) else { return nil}

            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
            var group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)

            if screenOrientation == "landscape" && sectionIndex == 3 {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            }

            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)

            if (self?.collectionView.numberOfItems(inSection: sectionIndex) ?? 0) > 0 {
                section.boundarySupplementaryItems = [header]
            }

            if sectionIndex == 0 || sectionIndex == 4 {
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = []
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            }
            return section
        }
        return layout
    }
}
