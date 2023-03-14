//
//  CharacterDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit
import Combine
import SDWebImage

struct CharacterInfoHasher: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetCharacterQuery.Data.Character
    init(id: UUID = UUID(), item: RickAndMortyAPI.GetCharacterQuery.Data.Character) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: CharacterInfoHasher, rhs: CharacterInfoHasher) -> Bool {
        lhs.id == rhs.id
    }
}

class CharacterDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var characterDetailsView = CharacterDetailsView()
    let viewModel = CharacterDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CharacterInfoHasher>
    private var dataSource: DataSource!

    var characterID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.selectedCharacter = characterID!
        view = characterDetailsView
        configureDataSource()
        subscribeToViewModel()
    }

    func subscribeToViewModel() {
        viewModel.character.sink(receiveValue: { characterInfo in
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailsViewAvatarCell.identifier, for: indexPath) as? CharacterDetailsViewAvatarCell else { fatalError("Wrong cell class dequeued") }
                guard let image = characterInfo.item.image else { fatalError("Image not found") }
                cell.characterImage.sd_setImage(with: URL(string: image))
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
    }
}
