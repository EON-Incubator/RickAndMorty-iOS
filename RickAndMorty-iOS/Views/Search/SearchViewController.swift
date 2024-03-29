//
//  SearchViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import UIKit
import Combine

class SearchViewController: BaseViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<SearchSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchSection, AnyHashable>

    enum SearchSection: Int, CaseIterable {
        case characters
        case locations
        case loadMoreCharacters
        case loadMoreLocations
        case episodes
    }

    private let searchView = SearchView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel: SearchViewModel
    private let charactersSearchViewModel = CharactersViewModel()
    private let locationNameViewModel = LocationsViewModel()
    private let locationTypeViewModel = LocationsViewModel()

    private var searchSuggestions: [UISearchSuggestionItem] = []
    private var dataSource: DataSource?
    private var snapshot = Snapshot()
    private var cancellables = Set<AnyCancellable>()
    private var currentCharactersPage = 1
    private var currentLocationsPage = 1
    private var totalCharactersPage: Int = 0
    private var totalLocationsPage: Int = 0
    private var uniqueLocations: [Locations] = []

    private weak var debounceTimer: Timer?

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
    }

    override func loadView() {
        configureSearchController()
        view = searchView
        searchView.collectionView.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func subscribeToViewModel() {

        viewModel.searchResults.sink(receiveValue: { [weak self] result in
            self?.snapshot.deleteAllItems()

            self?.snapshot.appendSections([.characters, .loadMoreCharacters, .locations, .loadMoreLocations, .episodes])

            let locationsWithName = result.locationsWithName
            let locationsWithType = result.locationsWithType

            let locations: [Locations] = locationsWithName + locationsWithType
            self?.uniqueLocations = Array(Set(locations))

            let characters = result.characters

            self?.totalCharactersPage = result.charactersTotalPages
            self?.totalLocationsPage = result.locationsWithNameTotalPages + result.locationsWithTypeTotalPages

            switch self?.searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                self?.snapshot.appendItems(characters, toSection: .characters)
                if self?.totalCharactersPage ?? 0 > 1 {
                    self?.snapshot.appendItems([EmptyData(id: UUID())], toSection: .loadMoreCharacters)
                }
                self?.snapshot.appendItems(self?.uniqueLocations ?? [], toSection: .locations)
                if self?.totalLocationsPage ?? 0 > 2 {
                    self?.snapshot.appendItems([EmptyData(id: UUID())], toSection: .loadMoreLocations)
                }
                self?.snapshot.appendItems(result.episodes, toSection: .episodes)
            case 1:
                self?.currentCharactersPage = 1
                self?.snapshot.appendItems(characters, toSection: .characters)
                if self?.totalCharactersPage ?? 0 > 1 {
                    self?.snapshot.appendItems([EmptyData(id: UUID())], toSection: .loadMoreCharacters)
                }
            case 2:
                self?.currentLocationsPage = 1
                self?.snapshot.appendItems(self?.uniqueLocations ?? [], toSection: .locations)
                if self?.totalLocationsPage ?? 0 > 2 {
                    self?.snapshot.appendItems([EmptyData(id: UUID())], toSection: .loadMoreLocations)
                }
            default:
                self?.snapshot.appendItems(result.episodes, toSection: .episodes)
            }
            if let snapshot = self?.snapshot {
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }

            // show message if collection view is empty
            self?.searchView.collectionView.noDataFound(self?.snapshot.numberOfItems ?? 0, query: self?.viewModel.searchInput ?? "")
        }).store(in: &cancellables)
    }

    // swiftlint:disable cyclomatic_complexity
    private func configureDataSource() {
        dataSource = DataSource(collectionView: searchView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, result) -> UICollectionViewCell? in

            var cell = UICollectionViewCell()

            guard let locationCell = self?.searchView.locationCell else { return nil }

            switch indexPath.section {
            case 0:
                if let character = result as? Characters {

                    weak var characterRowCell = (collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell)

                    let urlString = character.image
                    characterRowCell?.characterAvatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
                    characterRowCell?.upperLabel.text = character.name
                    characterRowCell?.lowerLeftLabel.text = character.gender
                    characterRowCell?.lowerRightLabel.text = character.species
                    characterRowCell?.characterStatusLabel.text = character.status
                    characterRowCell?.characterStatusLabel.backgroundColor = characterRowCell?.statusColor(character.status)

                    cell = characterRowCell ?? CharacterRowCell()
                }
            case 2:
                cell = collectionView.dequeueConfiguredReusableCell(using: locationCell, for: indexPath, item: result as? Locations)
            case 4:
                guard let episodeCell = self?.searchView.episodeCell else { return nil }
                let episode = result as? Episodes
                let cell = collectionView.dequeueConfiguredReusableCell(using: episodeCell, for: indexPath, item: episode)
                cell.upperLabel.text = episode?.name
                cell.lowerLeftLabel.text = episode?.episode
                cell.lowerRightLabel.text = episode?.airDate
                for index in 0...3 {
                    let isIndexValid =  episode?.characters.indices.contains(index)
                    if isIndexValid ?? false {
                        let urlString = episode?.characters[index].image ?? ""
                        cell.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 50, height: 50)])
                    }
                }
                return cell
            default:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.identifier, for: indexPath) as? LoadMoreCell ?? cell
            }
            return cell
        })
        // for custom header
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.searchView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            var sectionText = ""

            switch indexPath.section {
            case 0:
                sectionText = K.Headers.characters
            case 2:
                sectionText = K.Headers.locations
            default:
                sectionText = K.Headers.episodes
            }
            headerView.textLabel.text = sectionText
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let location = dataSource?.itemIdentifier(for: indexPath) as? Locations? {
            viewModel.goLocationDetails(id: (location?.id) ?? "", navController: navigationController ?? UINavigationController(), residentCount: location?.residents.count ?? 0)
        }

        if let character = dataSource?.itemIdentifier(for: indexPath) as? Characters? {
            viewModel.goCharacterDetails(id: (character?.id) ?? "", navController: navigationController ?? UINavigationController())
        }

        if let episode = dataSource?.itemIdentifier(for: indexPath) as? Episodes {
            viewModel.goEpisodeDetails(id: episode.id, navController: navigationController ?? UIVideoEditorController())
        }

        // load-more section
        if dataSource?.itemIdentifier(for: indexPath) is EmptyData {
            let cell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
            cell.showLoadingAnimation()
            if indexPath.section == 1 {
                loadMoreCharacters()
            } else {
                loadMoreLocations()
            }
        }
    }

    func loadMoreCharacters() {
        currentCharactersPage += 1
        // remove load-more section
        if currentCharactersPage == totalCharactersPage {
            let ids = snapshot.itemIdentifiers(inSection: .loadMoreCharacters)
            snapshot.deleteItems(ids)
        }
        charactersSearchViewModel.fetchData(page: currentCharactersPage, name: viewModel.searchInput)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let newCharacters = self?.charactersSearchViewModel.charactersForSearch.value
            self?.snapshot.appendItems(newCharacters ?? [], toSection: .characters)
            if let snapshot = self?.snapshot {
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
        }
    }

    func loadMoreLocations() {
        currentLocationsPage += 1
        if currentLocationsPage == totalLocationsPage {
            let ids = snapshot.itemIdentifiers(inSection: .loadMoreLocations)
            snapshot.deleteItems(ids)
        }
        locationNameViewModel.fetchData(page: currentLocationsPage, name: viewModel.searchInput)
        locationTypeViewModel.fetchData(page: currentLocationsPage, type: viewModel.searchInput)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.uniqueLocations += ((self?.locationNameViewModel.locationsNameSearch.value ?? []) + (self?.locationTypeViewModel.locationsTypeSearch.value ?? []))
            let newUniqueLocations = Array(Set((self?.uniqueLocations) ?? []))
            let locationsIDs = self?.snapshot.itemIdentifiers(inSection: .locations)
            self?.snapshot.deleteItems(locationsIDs ?? [])
            self?.snapshot.appendItems(newUniqueLocations, toSection: .locations)
            if let snapshot = self?.snapshot {
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

        searchView.loadingView.spinner.stopAnimating()
        viewModel.refresh(input: searchBar.text ?? "")

        // change background colors
        switch selectedScope {
        case 1:
            searchView.collectionView.backgroundColor = UIColor(named: K.Colors.characterView)
            searchView.backgroundColor = UIColor(named: K.Colors.characterView)
        case 2:
            searchView.collectionView.backgroundColor = UIColor(named: K.Colors.locationsView)
            searchView.backgroundColor = UIColor(named: K.Colors.locationsView)
        default:
            searchView.collectionView.backgroundColor = UIColor(named: K.Colors.episodeView)
            searchView.backgroundColor = UIColor(named: K.Colors.episodeView)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            snapshot.deleteAllItems()
            dataSource?.apply(snapshot)
        }
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {

    func configureSearchController() {
        searchController.searchBar.searchTextField.accessibilityIdentifier = K.Identifiers.search
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ["All", K.Titles.characters, K.Titles.locations, K.Titles.episodes]
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        searchView.collectionView.noDataFound(5, query: viewModel.searchInput)
    }

    func showSuggestions(suggestion: String) {
        var searchInputs: [String] = []
        for search in searchSuggestions {
            searchInputs.append(search.localizedSuggestion ?? "")
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
        searchController.searchBar.text = searchSuggestion.localizedSuggestion
        self.viewModel.refresh(input: searchSuggestion.localizedSuggestion ?? "")
        searchController.searchBar.endEditing(true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchInput = searchController.searchBar.text {
            searchView.loadingView.spinner.startAnimating()
            debounceTimer?.invalidate()
            self.searchView.middleLabel.removeFromSuperview()
            // debounce search results
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.searchView.loadingView.spinner.stopAnimating()
                if searchInput.count >= 2 {
                    // remove search-for-something label
                    if searchInput != self.viewModel.searchInput {
                        self.viewModel.refresh(input: searchInput)
                        searchController.searchSuggestions = []
                    }
                } else {
                    self.showSuggestions(suggestion: self.viewModel.searchInput)
                }
            }
        }
    }
}

extension UICollectionView {
    func noDataFound(_ dataCount: Int, query: String) {
        if dataCount <=  0 {
            let label = UILabel()
            label.frame = frame
            label.frame.origin.x = 0
            label.frame.origin.y = 0
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 20)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 3
            label.text = "No results found for '\(query)'"
            backgroundView = label
        } else {
            backgroundView = nil
        }
    }
}
