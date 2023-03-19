//
//  SearchViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    enum SearchSection: Int, CaseIterable {
        case characters
        case locationsWithName
        case locationsWithType
    }

    let searchView = SearchView()
    let viewModel = SearchViewModel()
    weak var coordinator: MainCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        viewModel.searchInput = "planet"
    }

    override func loadView() {
        view = searchView
    }

    func subscribeToViewModel() {
        viewModel.searchResults.sink(receiveValue: { result in
            var snapshot = NSDiffableDataSourceSnapshot<SearchSection, AnyHashable>()
            snapshot.appendSections([.locationsWithName, .characters])
            snapshot.appendItems((result.locationsWithName?.results)!, toSection: .locationsWithName)
            snapshot.appendItems((result.characters?.results)!, toSection: .characters)

            self.dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: searchView.collectionView, cellProvider: { (collectionView, indexPath, result) -> UICollectionViewCell? in

            var cell = UICollectionViewCell()

            switch indexPath.section {
            case 0:
                cell = collectionView.dequeueConfiguredReusableCell(using: self.searchView.locationCell, for: indexPath, item: result as? RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result)

            case 1:
                if let character = result as? RickAndMortyAPI.SearchForQuery.Data.Characters.Result {

                    let characterRowCell = (collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell)!

                    let urlString = character.image ?? ""
                    characterRowCell.characterAvatarImageView.sd_setImage(with: URL(string: urlString))
                    characterRowCell.upperLabel.text = character.name
                    characterRowCell.lowerLeftLabel.text = character.gender
                    characterRowCell.lowerRightLabel.text = character.species
                    characterRowCell.characterStatusLabel.text = character.status
                    characterRowCell.characterStatusLabel.backgroundColor = characterRowCell.statusColor(character.status ?? "")

                    cell = characterRowCell
                }
            default:
                cell = UICollectionViewCell()
            }
            return cell
        })
    }

}
