//
//  EpisodeDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodeDetailsViewController: UIViewController {

    enum EpisodeDetailsSection: Int, CaseIterable {
        case info
        case characters
    }

    weak var coordinator: MainCoordinator?
    var episodeDetailsView = EpisodeDetailsView()
    let viewModel = EpisodeDetailsViewModel()
    var episodeId: String

    typealias DataSource = UICollectionViewDiffableDataSource<EpisodeDetailsSection, EpisodeDetails>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    init(episodeId: String) {
        self.episodeId = episodeId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = episodeDetailsView
        episodeDetailsView.collectionView.delegate = self
        episodeDetailsView.collectionView.refreshControl = UIRefreshControl()
        episodeDetailsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        viewModel.episodeID = episodeId
    }

    func subscribeToViewModel() {
        viewModel.episode.sink(receiveValue: { episode in

            self.title = episode.name

            var snapshot = NSDiffableDataSourceSnapshot<EpisodeDetailsSection, EpisodeDetails>()
            snapshot.appendSections([.info])
            snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .info)
            self.dataSource.apply(snapshot, animatingDifferences: true)

            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.episodeDetailsView.collectionView.refreshControl?.endRefreshing()
            }

        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.episodeID = self.episodeId
    }
}

// MARK: - CollectionView DataSource
extension EpisodeDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: episodeDetailsView.collectionView, cellProvider: { (collectionView, indexPath, episode) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell

            switch indexPath.item {
            case 0:
                cell?.leftLabel.text = "Episode"
                cell?.rightLabel.text = episode.item.episode
                cell?.infoImage.image = UIImage(named: "tv")
            case 1:
                cell?.leftLabel.text = "Air Date"
                cell?.rightLabel.text = episode.item.air_date
                cell?.infoImage.image = UIImage(named: "calendar")
            default:
                cell?.rightLabel.text = "-"
            }

            return cell
        })

        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.episodeDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = "\(EpisodeDetailsSection.allCases[indexPath.section])".uppercased()
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
}

// MARK: - CollectionView Delegate
extension EpisodeDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: Struct for Diffable DataSource
struct EpisodeDetails: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetEpisodeQuery.Data.Episode
    init(id: UUID = UUID(), _ item: RickAndMortyAPI.GetEpisodeQuery.Data.Episode) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: EpisodeDetails, rhs: EpisodeDetails) -> Bool {
        lhs.id == rhs.id
    }
}
