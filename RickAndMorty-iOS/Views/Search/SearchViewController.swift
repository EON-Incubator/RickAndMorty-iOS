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
    private var searchController = UISearchController(searchResultsController: nil)
    var debounceTimer: Timer?

    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        configureSearchController()
        title = "Search"
    }

    override func loadView() {
        view = searchView
    }

    func subscribeToViewModel() {
        viewModel.searchResults.sink(receiveValue: { result in
            var snapshot = Snapshot()
            snapshot.appendSections([.locationsWithName, .characters, .locationsWithType])
            snapshot.appendItems((result.locationsWithName?.results)!, toSection: .locationsWithName)
            snapshot.appendItems((result.characters?.results)!, toSection: .characters)
            snapshot.appendItems((result.locationsWithType?.results)!, toSection: .locationsWithType)

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
            case 2:
                cell = collectionView.dequeueConfiguredReusableCell(using: self.searchView.testCell, for: indexPath, item: result as? RickAndMortyAPI.SearchForQuery.Data.LocationsWithType.Result)
            default:
                cell = UICollectionViewCell()
            }
            return cell
        })
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {

        if let searchInput = searchController.searchBar.text {
            debounceTimer?.invalidate()
            // debounce search results
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                if !searchInput.isEmpty {
                    self.viewModel.searchInput = searchInput
                } else {
                    self.viewModel.searchInput = "_"
                }
            }
        }
    }
}
