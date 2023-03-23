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

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        showEmptyData()
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

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .empty])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 8), toSection: .empty)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.episodes.sink(receiveValue: { [self] episodes in
            if !episodes.isEmpty {
                snapshot.deleteAllItems()
                snapshot.appendSections([.appearance])
                snapshot.appendItems(episodes, toSection: .appearance)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
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
        dataSource = DataSource(collectionView: episodesView.collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in

            // section with empty episode cells
            if indexPath.section == 1 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: self.episodesView.episodeCell, for: indexPath, item: data as? EmptyData )
                showLoadingAnimation(currentCell: cell)
                return cell
            }

            let episode = data as? RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.episodesView.episodeCell,
                                                                    for: indexPath,
                                                                    item: episode)
            cell.upperLabel.text = episode?.name
            cell.lowerLeftLabel.text = episode?.episode
            cell.lowerRightLabel.text = episode?.air_date

            for index in 0...3 {
                let isIndexValid =  episode?.characters.indices.contains(index)
                if isIndexValid! {
                    let urlString = episode?.characters[index]?.image ?? ""
                    cell.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString))
                }
            }
            hideLoadingAnimation(currentCell: cell)
            return cell
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

extension Array {
    init(repeatingExpression expression: @autoclosure (() -> Element), count: Int) {
        var temp = [Element]()
        for _ in 0..<count {
            temp.append(expression())
        }
        self = temp
    }
}
