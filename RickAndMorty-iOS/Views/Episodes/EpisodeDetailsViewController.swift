//
//  EpisodeDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodeDetailsViewController: BaseViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<EpisodeDetailsSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodeDetailsSection, AnyHashable>

    enum EpisodeDetailsSection: Int, CaseIterable {
        case carousel
        case overview
        case info
        case characters
        case emptyCarousel
        case emptyOverview
        case emptyInfo
        case emptyCharacters
    }

    private let episodeDetailsView = EpisodeDetailsView()
    private let viewModel: EpisodeDetailsViewModel

    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()

    init(viewModel: EpisodeDetailsViewModel) {
        self.viewModel = viewModel
        super.init()
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
        showEmptyData()
        subscribeToViewModel()
        viewModel.fetchData()
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.carousel, .overview, .info, .characters, .emptyCarousel, .emptyOverview, .emptyInfo, .emptyCharacters])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 1), toSection: .emptyCarousel)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 1), toSection: .emptyOverview)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 3), toSection: .emptyInfo)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 4), toSection: .emptyCharacters)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.episode.sink(receiveValue: { [weak self] episode in
            if !episode.characters.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.carousel, .overview, .info, .characters])
                    snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode), EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .carousel)
                    snapshot.appendItems([EpisodeDetails(episode)], toSection: .overview)
                    snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .info)
                    snapshot.appendItems(episode.characters, toSection: .characters)
                    DispatchQueue.main.async {
                        self?.title = episode.name
                        self?.dataSource?.apply(snapshot, animatingDifferences: true)
                    }
                }
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self?.episodeDetailsView.collectionView.refreshControl?.endRefreshing()
            }
        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.fetchData()
    }
}

// MARK: - CollectionView DataSource
extension EpisodeDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: episodeDetailsView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, episode) -> UICollectionViewCell? in

            switch indexPath.section {
            case 0:
                let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as? CarouselCell
                carouselCell?.carouselImage.sd_setImage(with: URL(string: "https://picsum.photos/200/300"))
                return carouselCell
            case 1:
                let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeOverviewCell.identifier, for: indexPath) as? EpisodeOverviewCell
                overviewCell?.centerLabel.text = self?.viewModel.episodeDetails?.overview
                return overviewCell
            case 2:
                guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell else { return nil }
                return self?.configInfoCell(cell: infoCell, data: episode, itemIndex: indexPath.item)
            case 3:
                let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell
                if let character = episode as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode.Character? {
                    let urlString = character?.image ?? ""
                    characterRowCell?.characterAvatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
                    characterRowCell?.upperLabel.text = character?.name
                    characterRowCell?.lowerLeftLabel.text = character?.gender
                    characterRowCell?.lowerRightLabel.text = character?.species
                    characterRowCell?.characterStatusLabel.text = character?.status
                    characterRowCell?.characterStatusLabel.backgroundColor = characterRowCell?.statusColor(character?.status ?? "")
                    return characterRowCell
                }

                // empty sections
            case 4:
                let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as? CarouselCell
                carouselCell?.backgroundColor = .secondarySystemBackground
                carouselCell?.showLoadingAnimation()
                return carouselCell
            case 5:
                let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeOverviewCell.identifier, for: indexPath) as? EpisodeOverviewCell
                overviewCell?.showLoadingAnimation()
                return overviewCell
            case 6:
                let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                infoCell?.showLoadingAnimation()
                return infoCell
            case 7:
                let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell
                characterRowCell?.showLoadingAnimation()
                return characterRowCell
            default:
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })
        applyHeaderView()
    }

    func applyHeaderView() {
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.episodeDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = indexPath.section == 2 ? K.Headers.info : K.Headers.characters
            if indexPath.section == 1 {
                headerView.textLabel.text = "OVERVIEW"
            }
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }

    func configInfoCell(cell: InfoCell, data: AnyHashable, itemIndex: Int) -> UICollectionViewCell {
        if let episodeDetails = data as? EpisodeDetails {
            switch itemIndex {
            case 0:
                cell.leftLabel.text = K.Info.episode
                cell.rightLabel.text = episodeDetails.item.episode
                cell.infoImage.image = UIImage(named: K.Images.television)?.withRenderingMode(.alwaysTemplate)
                cell.infoImage.tintColor = UIColor(named: K.Colors.infoCell)
            case 1:
                cell.leftLabel.text = K.Info.airDate
                cell.rightLabel.text = episodeDetails.item.air_date
                cell.infoImage.image = UIImage(named: K.Images.calendar)?.withRenderingMode(.alwaysTemplate)
                cell.infoImage.tintColor = UIColor(named: K.Colors.infoCell)
            case 2:
                cell.rightLabel.text = String(format: "%.1f", self.viewModel.episodeDetails?.voteAverage ?? 0)
                cell.leftLabel.text = "Rating"
                cell.infoImage.image = UIImage(systemName: "star")
                cell.rightLabel.adjustsFontSizeToFitWidth = false
            default:
                cell.rightLabel.text = "-"
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - CollectionView Delegate
extension EpisodeDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let character = dataSource?.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode.Character? {
            viewModel.goCharacterDetails(id: (character?.id) ?? "", navController: navigationController ?? UINavigationController())
        }
    }
}

// MARK: Struct for Diffable DataSource
struct EpisodeDetails: Hashable {
    let id: UUID
    let item: RickAndMortyAPI.GetEpisodeQuery.Data.Episode
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
