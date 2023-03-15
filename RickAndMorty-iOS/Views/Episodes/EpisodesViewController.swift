//
//  EpisodesViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodesViewController: UIViewController {

    let episodesView = EpisodesView()
    let viewModel = EpisodesViewModel()
    weak var coordinator: MainCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    override func loadView() {
        view = episodesView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Episodes"
        episodesView.collectionView.delegate = self
        episodesView.collectionView.refreshControl = UIRefreshControl()
        episodesView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    func subscribeToViewModel() {
        viewModel.episodes.sink(receiveValue: { episodes in
            var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result>()
            snapshot.appendSections([.appearance])
            snapshot.appendItems(episodes, toSection: .appearance)
            self.dataSource.apply(snapshot, animatingDifferences: true)

            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.episodesView.collectionView.refreshControl?.endRefreshing()
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

// MARK: - CollectionView DataSource
extension EpisodesViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: episodesView.collectionView, cellProvider: { (collectionView, indexPath, episode) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.episodesView.episodeCell,
                                                                for: indexPath,
                                                                item: episode)
        })
    }
}

// MARK: - CollectionView Delegate
extension EpisodesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        coordinator?.goEpisodeDetails(id: viewModel.episodes.value[indexPath.row].id!, navController: self.navigationController!)
    }
}
