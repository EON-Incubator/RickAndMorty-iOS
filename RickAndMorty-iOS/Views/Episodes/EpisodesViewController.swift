//
//  EpisodesViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine
import RealmSwift

class EpisodesViewController: BaseViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>

    private let episodesView = EpisodesView()
    private let viewModel: EpisodesViewModel

    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()

    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        viewModel.refresh()
    }

    override func loadView() {
        view = episodesView
        navigationController?.navigationBar.prefersLargeTitles = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = K.Titles.episodes
        episodesView.collectionView.delegate = self
        episodesView.collectionView.refreshControl = UIRefreshControl()
        episodesView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .empty])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 8), toSection: .empty)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.episodes.sink(receiveValue: { [weak self] episodes in
            if !episodes.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.appearance])
                    snapshot.appendItems(episodes, toSection: .appearance)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                }
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self?.episodesView.collectionView.refreshControl?.endRefreshing()
                self?.episodesView.loadingView.spinner.stopAnimating()
            }
        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.refresh()
    }
}

// MARK: - CollectionView DataSource
extension EpisodesViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: episodesView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, data) -> UICollectionViewCell? in

            guard let episodeCell = self?.episodesView.episodeCell else { return nil }

            // section with empty episode cells
            if indexPath.section == 1 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: episodeCell, for: indexPath, item: data as? EmptyData )
                cell.showLoadingAnimation()
                return cell
            }

            let episode = data as? Episodes
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
        })
    }
}

// MARK: - CollectionView Delegate
extension EpisodesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {

            episodesView.loadingView.spinner.startAnimating()
            viewModel.loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let episode = dataSource?.itemIdentifier(for: indexPath) as? Episodes {
            viewModel.goEpisodeDetails(id: episode.id, navController: navigationController ?? UIVideoEditorController())
        }
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
