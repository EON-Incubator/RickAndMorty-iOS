//
//  CharacterDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit
import Combine
import SDWebImage

class CharacterDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var characterDetailsView = CharacterDetailsView()
    let viewModel = CharacterDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CharacterInfoHasher>
    private var dataSource: DataSource!
    var characterID: String?

    override func loadView() {
        view = characterDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.selectedCharacter = characterID!
        configureDataSource()
        subscribeToViewModel()
    }

    func subscribeToViewModel() {
        viewModel.character.sink(receiveValue: { characterInfo in
            self.title = characterInfo.name

            var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterInfoHasher>()
            snapshot.appendSections([.appearance, .info, .location])
            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .appearance)

            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .info)
            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .info)
            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .info)

            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .location)
            snapshot.appendItems([CharacterInfoHasher.init(item: characterInfo)], toSection: .location)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }
}

// MARK: - CollectionView DataSource
extension CharacterDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: characterDetailsView.collectionView, cellProvider: { (collectionView, indexPath, characterInfo) -> UICollectionViewCell? in

            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailsViewAvatarCell.identifier,
                                                              for: indexPath) as? CharacterDetailsViewAvatarCell
                guard let image = characterInfo.item.image else { fatalError("Image not found") }
                cell?.characterImage.sd_setImage(with: URL(string: image))
                return cell

            } else if indexPath.section == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                switch indexPath.item {
                case 0:
                    cell?.leftLabel.text = "Gender"
                    cell?.rightLabel.text = characterInfo.item.gender
                    cell?.infoImage.image = UIImage(named: "gender")
                case 1:
                    cell?.leftLabel.text = "Species"
                    cell?.rightLabel.text = characterInfo.item.species
                    cell?.infoImage.image = UIImage(named: "dna")
                default:
                    cell?.leftLabel.text = "Status"
                    cell?.rightLabel.text = characterInfo.item.status
                    cell?.infoImage.image = UIImage(named: "heart")
                }
                return cell
            } else if indexPath.section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                switch indexPath.item {
                case 0:
                    cell?.leftLabel.text = "Origin"
                    cell?.rightLabel.text = characterInfo.item.origin?.name
                    cell?.infoImage.image = UIImage(named: "chick")
                default:
                    cell?.leftLabel.text = "Last Seen"
                    cell?.rightLabel.text = characterInfo.item.location?.name
                    cell?.infoImage.image = UIImage(named: "map")
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                cell?.rightLabel.text = characterInfo.item.origin?.name
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
    }
}
