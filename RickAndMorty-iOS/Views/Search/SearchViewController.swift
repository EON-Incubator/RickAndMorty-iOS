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
        case locations
    }

    let searchView = SearchView()
    let viewModel = SearchViewModel()
    weak var coordinator: MainCoordinator?

    private var searchController = UISearchController(searchResultsController: nil)
    var debounceTimer: Timer?
    var searchSuggestions: [UISearchSuggestionItem] = []

    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, AnyHashable>
    private var dataSource: DataSource!
    var snapshot = Snapshot()
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
        searchView.collectionView.delegate = self
    }

    func subscribeToViewModel() {
        viewModel.searchResults.sink(receiveValue: { [self] result in

            snapshot.deleteAllItems()

            snapshot.appendSections([.characters, .locations])

            let locationsWithName: [RickAndMortyAPI.LocationDetails] = result.locationsWithName?.results?.compactMap { $0?.fragments.locationDetails } as? [RickAndMortyAPI.LocationDetails] ?? []

            let locationsWithType: [RickAndMortyAPI.LocationDetails] = result.locationsWithType?.results?.compactMap { $0?.fragments.locationDetails } as? [RickAndMortyAPI.LocationDetails] ?? []

            let locations: [RickAndMortyAPI.LocationDetails] = locationsWithName + locationsWithType
            let uniqueLocations = Array(Set(locations))

            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                snapshot.appendItems((result.characters?.results)!, toSection: .characters)
                snapshot.appendItems(uniqueLocations, toSection: .locations)
            case 1:
                snapshot.appendItems((result.characters?.results)!, toSection: .characters)
                snapshot.appendItems([], toSection: .locations)
            case 2:
                snapshot.appendItems([], toSection: .characters)
                snapshot.appendItems(uniqueLocations, toSection: .locations)
            default:
                print("error")
            }

            dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: searchView.collectionView, cellProvider: { (collectionView, indexPath, result) -> UICollectionViewCell? in

            var cell = UICollectionViewCell()

            switch indexPath.section {
            case 0:
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
            case 1:
                cell = collectionView.dequeueConfiguredReusableCell(using: self.searchView.locationCell, for: indexPath, item: result as? RickAndMortyAPI.LocationDetails)
            default:
                cell = UICollectionViewCell()
            }
            return cell
        })
        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.searchView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            let sectionText = indexPath.section == 0 ? "CHARACTERS" : "LOCATIONS"

            headerView.textLabel.text = sectionText
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let location = dataSource.itemIdentifier(for: indexPath) as? RickAndMortyAPI.LocationDetails? {
            coordinator?.goLocationDetails(id: (location?.id)!, navController: self.navigationController!)
        }

        if let character = dataSource.itemIdentifier(for: indexPath) as? RickAndMortyAPI.SearchForQuery.Data.Characters.Result? {
            coordinator?.goCharacterDetails(id: (character?.id)!, navController: self.navigationController!)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.searchInput = searchBar.text!
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {

    func configureSearchController() {
        searchController.searchBar.searchTextField.accessibilityIdentifier = "SearchTextField"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ["All", "Characters", "Locations"]
    }

    func showSuggestions(suggestion: String) {
        var searchInputs: [String] = []
        for search in searchSuggestions {
            searchInputs.append(search.localizedSuggestion!)
            if searchInputs.contains(suggestion) {
                searchController.searchSuggestions = searchSuggestions
                return
            }
        }
        if !suggestion.isEmpty {
            searchSuggestions.append(UISearchSuggestionItem(localizedSuggestion: suggestion))
        }
        searchController.searchSuggestions = searchSuggestions
    }

    func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion) {
        searchController.searchBar.text = searchSuggestion.localizedSuggestion!
        searchController.searchBar.endEditing(true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchInput = searchController.searchBar.text {
            debounceTimer?.invalidate()
            // debounce search results
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                if !searchInput.isEmpty {
                    if searchInput != self.viewModel.searchInput {
                        self.viewModel.searchInput = searchInput
                        searchController.searchSuggestions = []
                    }
                } else {
                    self.showSuggestions(suggestion: self.viewModel.searchInput)
                }
            }
        }
    }
}
