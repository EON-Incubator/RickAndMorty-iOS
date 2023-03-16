//
//  CharactersViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit
import Combine
import SDWebImage

class CharactersViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var charactersGridView = CharactersView()
    let viewModel = CharactersViewModel()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyAPI.CharacterBasics>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    override func loadView() {
        view = charactersGridView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        navigationItem.rightBarButtonItem = charactersGridView.filterButton(self, action: #selector(filterButtonPressed))
        navigationItem.leftBarButtonItem = charactersGridView.logoView()

        charactersGridView.collectionView.delegate = self
        charactersGridView.collectionView.refreshControl = UIRefreshControl()
        charactersGridView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    @objc func filterButtonPressed() {
        print("filterButtonPressed")
    }

    func subscribeToViewModel() {
        viewModel.characters.sink(receiveValue: { characters in
            var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyAPI.CharacterBasics>()
            snapshot.appendSections([.appearance])
            snapshot.appendItems(characters, toSection: .appearance)
            self.dataSource.apply(snapshot, animatingDifferences: true)

            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.charactersGridView.collectionView.refreshControl?.endRefreshing()
            }
        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.currentPage = 1
    }

    func loadMore() {
        viewModel.currentPage += 1
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: charactersGridView.collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.charactersGridView.characterCell, for: indexPath, item: character)
        })
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            // show lazy-loading indicator
            charactersGridView.loadingIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadMore()
                self.charactersGridView.loadingIndicator.stopAnimating()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goCharacterDetails(id: viewModel.characters.value[indexPath.row].id!, navController: self.navigationController!)
    }
}
