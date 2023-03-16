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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    private var dataSource: DataSource!
    var characterID: String?

    let locationsViewModel = LocationsViewModel()

    override func loadView() {
        view = characterDetailsView
        characterDetailsView.collectionView.delegate = self
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

            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections([.appearance, .info, .location, .episodes])
            snapshot.appendItems([CharacterDetails(characterInfo)], toSection: .appearance)
            snapshot.appendItems([CharacterDetails(characterInfo), CharacterDetails(characterInfo), CharacterDetails(characterInfo)], toSection: .info)
            snapshot.appendItems([CharacterDetails(characterInfo), CharacterDetails(characterInfo)], toSection: .location)
            snapshot.appendItems(characterInfo.episode, toSection: .episodes)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }
}

// MARK: - CollectionView DataSource
extension CharacterDetailsViewController {
    // swiftlint:disable cyclomatic_complexity
    private func configureDataSource() {
        dataSource = DataSource(collectionView: characterDetailsView.collectionView, cellProvider: { (collectionView, indexPath, characterInfo) -> UICollectionViewCell? in

            var cell = UICollectionViewCell()

            switch indexPath.section {
            case 0:
                if let character = characterInfo as? CharacterDetails {
                    let avatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier, for: indexPath) as? AvatarCell
                    guard let image = character.item.image else { fatalError("Image not found") }
                    avatarCell?.characterImage.sd_setImage(with: URL(string: image))
                    cell = avatarCell!
                }
            case 1:
                if let character = characterInfo as? CharacterDetails {
                    let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                    switch indexPath.item {
                    case 0:
                        infoCell?.leftLabel.text = "Gender"
                        infoCell?.rightLabel.text = character.item.gender
                        infoCell?.infoImage.image = UIImage(named: "gender")
                    case 1:
                        infoCell?.leftLabel.text = "Species"
                        infoCell?.rightLabel.text = character.item.species
                        infoCell?.infoImage.image = UIImage(named: "dna")
                    default:
                        infoCell?.leftLabel.text = "Status"
                        infoCell?.rightLabel.text = character.item.status
                        infoCell?.infoImage.image = UIImage(named: "heart")
                    }
                    cell = infoCell!
                }
            case 2:
                if let character = characterInfo as? CharacterDetails {
                    let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                    infoCell?.accessories = [.disclosureIndicator(options: .init(reservedLayoutWidth: .actual, tintColor: .systemGray))]

                    switch indexPath.item {
                    case 0:
                        infoCell?.leftLabel.text = "Origin"
                        infoCell?.rightLabel.text = character.item.origin?.name
                        infoCell?.infoImage.image = UIImage(named: "chick")
                    default:
                        infoCell?.leftLabel.text = "Last Seen"
                        infoCell?.rightLabel.text = character.item.location?.name
                        infoCell?.infoImage.image = UIImage(named: "map")
                    }
                    cell = infoCell!
                }
            case 3:
                if let episode = characterInfo as?
                    RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode {
                    cell = collectionView.dequeueConfiguredReusableCell(using: self.characterDetailsView.episodeCell, for: indexPath, item: episode)
                }
            default:
                cell = UICollectionViewCell()
            }
            return cell
        })

        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.characterDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = "\(Section.allCases[indexPath.section])".uppercased()
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: - CollectionView Delegate
extension CharacterDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section > 1 {
            if let episode = dataSource.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode? {
                coordinator?.goEpisodeDetails(id: (episode?.id)!, navController: self.navigationController!)
            }
            if let character = dataSource.itemIdentifier(for: indexPath) as? CharacterDetails {
                switch indexPath.row {
                case 0:
                    if let originID = character.item.origin?.id {
                        coordinator?.goLocationDetails(id: originID, navController: self.navigationController!)
                    }
                default:
                    coordinator?.goLocationDetails(id: (character.item.location?.id)!, navController: self.navigationController!)
                }
            }
        }
    }
}

// MARK: Struct for Diffable DataSource
struct CharacterDetails: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetCharacterQuery.Data.Character
    init(id: UUID = UUID(), _ item: RickAndMortyAPI.GetCharacterQuery.Data.Character) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: CharacterDetails, rhs: CharacterDetails) -> Bool {
        lhs.id == rhs.id
    }
}
