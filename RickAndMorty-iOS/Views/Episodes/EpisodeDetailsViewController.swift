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

    typealias DataSource = UICollectionViewDiffableDataSource<EpisodeDetailsSection, AnyHashable>
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

            var snapshot = NSDiffableDataSourceSnapshot<EpisodeDetailsSection, AnyHashable>()
            snapshot.appendSections([.info, .characters])
            snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .info)
            snapshot.appendItems(episode.characters, toSection: .characters)
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

            var cell = UICollectionViewCell()

            switch indexPath.section {
            case 0:
                if let episodeDetails = episode as? EpisodeDetails {
                    let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                    switch indexPath.item {
                    case 0:
                        infoCell?.leftLabel.text = "Episode"
                        infoCell?.rightLabel.text = episodeDetails.item.episode
                        infoCell?.infoImage.image = UIImage(named: "tv")
                    case 1:
                        infoCell?.leftLabel.text = "Air Date"
                        infoCell?.rightLabel.text = episodeDetails.item.air_date
                        infoCell?.infoImage.image = UIImage(named: "calendar")
                    default:
                        infoCell?.rightLabel.text = "-"
                    }
                    cell = infoCell!
                }
            case 1:
                if let character = episode as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode.Character? {
                    let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell
                    let urlString = character?.image ?? ""
                    characterRowCell?.characterAvatarImageView.sd_setImage(with: URL(string: urlString))
                    characterRowCell?.upperLabel.text = character?.name
                    characterRowCell?.lowerLeftLabel.text = character?.gender
                    characterRowCell?.lowerRightLabel.text = character?.species
                    characterRowCell?.characterStatusLabel.text = character?.status
                    characterRowCell?.characterStatusLabel.backgroundColor = characterRowCell?.statusColor(character?.status ?? "")

                    cell = characterRowCell!
                }

            default:
                cell = UICollectionViewCell()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let character = dataSource.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode.Character? {
            coordinator?.goCharacterDetails(id: (character?.id)!, navController: self.navigationController!)
        }
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
