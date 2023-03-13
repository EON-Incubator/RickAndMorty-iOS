//
//  CharacterDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit

class CharacterDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var characterDetailsView = CharacterDetailsView()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        view = characterDetailsView
        configureDataSource()
    }
}

// MARK: - CollectionView DataSource
extension CharacterDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: characterDetailsView.collectionView, cellProvider: { (collectionView, indexPath, _ item) -> UICollectionViewCell? in
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
            guard let headerView = self.characterDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = "\(Section.allCases[indexPath.section])".uppercased()
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.appearance, .info, .location])
        snapshot.appendItems([1], toSection: .appearance)
        snapshot.appendItems(Array(2...4), toSection: .info)
        snapshot.appendItems(Array(5...6), toSection: .location)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
