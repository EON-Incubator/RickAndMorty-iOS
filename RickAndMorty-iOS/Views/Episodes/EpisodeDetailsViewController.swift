//
//  EpisodeDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine
import YouTubeiOSPlayerHelper

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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        snapshot.appendSections([.carousel, .overview, .info, .characters, .emptyCarousel, .emptyOverview, .emptyInfo])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 1), toSection: .emptyCarousel)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 1), toSection: .emptyOverview)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 3), toSection: .emptyInfo)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.episode.sink(receiveValue: { [weak self] episode in
            if !episode.characters.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.carousel, .overview, .info, .characters])
                    if let episodeImages = episode.episodeDetails?.episodeImages {
                        snapshot.appendItems(Array(episodeImages), toSection: .carousel)
                    }
                    snapshot.appendItems([EpisodeDetails(episode)], toSection: .overview)
                    snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .info)
                    snapshot.appendItems(Array(episode.characters), toSection: .characters)
                    DispatchQueue.main.async {
                        self?.title = episode.name
                        // add play icon to navigation bar
                        self?.setupNavItems()
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
                guard let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier,
                                                                            for: indexPath) as? CarouselCell else { return nil}
                return self?.configCarouselCell(cell: carouselCell, data: episode, itemIndex: indexPath.item)
            case 1:
                let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeOverviewCell.identifier,
                                                                      for: indexPath) as? EpisodeOverviewCell
                if let episodeDetails = episode as? EpisodeDetails {
                    overviewCell?.centerLabel.text = episodeDetails.item.episodeDetails?.overview
                }
                return overviewCell
            case 2:
                guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier,
                                                                        for: indexPath) as? InfoCell else { return nil }
                return self?.configInfoCell(cell: infoCell, data: episode, itemIndex: indexPath.item)
            case 3:
                guard let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier,
                                                                                for: indexPath) as? CharacterRowCell else { return nil }
                return self?.configCharacterRowCell(cell: characterRowCell, data: episode, itemIndex: indexPath.item)

            default:
                // empty sections
                return self?.loadEmptySections(collectionView: collectionView, index: indexPath)
            }
        })
        applyHeaderView()
    }

    func loadEmptySections(collectionView: UICollectionView, index: IndexPath) -> UICollectionViewCell? {
        switch index.section {
        case 4:
            let carouselCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier,
                                                                  for: index) as? CarouselCell
            carouselCell?.backgroundColor = .secondarySystemBackground
            carouselCell?.showLoadingAnimation()
            return carouselCell
        case 5:
            let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeOverviewCell.identifier,
                                                                  for: index) as? EpisodeOverviewCell
            overviewCell?.showLoadingAnimation()
            return overviewCell
        case 6:
            let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier,
                                                              for: index) as? InfoCell
            infoCell?.showLoadingAnimation()
            return infoCell
        default:
            return UICollectionViewCell()
        }
    }

    func applyHeaderView() {
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.episodeDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            switch indexPath.section {
            case 5:
                headerView.textLabel.text = K.Headers.overview
            case 6:
                headerView.textLabel.text = K.Headers.info
            case 7:
                headerView.textLabel.text = K.Headers.characters
            default:
                headerView.textLabel.text = "\(EpisodeDetailsSection.allCases[indexPath.section])".uppercased()
            }
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }

    func configCarouselCell(cell: CarouselCell, data: AnyHashable, itemIndex: Int) -> UICollectionViewCell {
        if let image = data as? TmdbEpisodeImages {
            guard let filePath = image.filePath else { return UICollectionViewCell() }
            let imageUrl = K.Tmdb.imageBaseUrl + filePath
            cell.carouselImage.sd_setImage(with: URL(string: imageUrl))
            return cell
        }
        return UICollectionViewCell()
    }

    func configCharacterRowCell(cell: CharacterRowCell, data: AnyHashable, itemIndex: Int) -> UICollectionViewCell {
        if let character = data as? Characters? {
            let urlString = character?.image ?? ""
            cell.characterAvatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
            cell.upperLabel.text = character?.name
            cell.lowerLeftLabel.text = character?.gender
            cell.lowerRightLabel.text = character?.species
            cell.characterStatusLabel.text = character?.status
            cell.characterStatusLabel.backgroundColor = cell.statusColor(character?.status ?? "")
            return cell
        }
        return UICollectionViewCell()
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
                cell.rightLabel.text = episodeDetails.item.airDate
                cell.infoImage.image = UIImage(named: K.Images.calendar)?.withRenderingMode(.alwaysTemplate)
                cell.infoImage.tintColor = UIColor(named: K.Colors.infoCell)
            case 2:
                cell.rightLabel.text = String(format: "%.1f", episodeDetails.item.episodeDetails?.voteAverage ?? 0)
                cell.leftLabel.text = K.Info.rating
                cell.infoImage.image = UIImage(systemName: K.Images.systemStar)
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
        if let character = dataSource?.itemIdentifier(for: indexPath) as? Characters? {
            viewModel.goCharacterDetails(id: (character?.id) ?? "", navController: navigationController ?? UINavigationController())
        }
    }
}

extension EpisodeDetailsViewController {
    func setupNavItems() {
        var linkMenuItems: [UIAction] {
            return [
                UIAction(title: K.Titles.hulu, image: UIImage(named: K.Images.hulu), handler: { (_) in
                    if let url = URL(string: K.Urls.hulu) {
                        UIApplication.shared.open(url)
                    }
                }),
                UIAction(title: K.Titles.amazon, image: UIImage(named: K.Images.amazon), handler: { (_) in
                    if let url = URL(string: K.Urls.amazon) {
                        UIApplication.shared.open(url)
                    }
                }),
                UIAction(title: K.Titles.adultSwim, image: UIImage(named: K.Images.adultSwim), handler: { (_) in
                    if let url = URL(string: K.Urls.adultSwim) {
                        UIApplication.shared.open(url)
                    }
                }),
                UIAction(title: K.Titles.apple, image: UIImage(systemName: K.Images.systemApple, withConfiguration: UIImage.SymbolConfiguration(scale: .large)), handler: { (_) in
                    if let url = URL(string: K.Urls.apple) {
                        UIApplication.shared.open(url)
                    }
                })
            ]
        }

        var linkMenu: UIMenu {
            return UIMenu(title: "", image: nil, identifier: nil, children: linkMenuItems)
        }

        let playIcon = UIBarButtonItem(image: UIImage(systemName: K.Images.systemplay), style: .plain, target: self, action: #selector(playVideo))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: K.Images.systemlink), menu: linkMenu)
        if viewModel.episodeVideo != nil {
            navigationItem.rightBarButtonItems?.append(playIcon)
        }
    }

    @objc func playVideo(sender: AnyObject) {
        let youtubeViewController = YoutubeViewController(videoId: viewModel.episodeVideo ?? "")
        youtubeViewController.modalPresentationStyle = .popover

        if let popover = youtubeViewController.popoverPresentationController {
            popover.sourceView = sender as? UIView
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [
                .custom(identifier: UISheetPresentationController.Detent.Identifier("small")) { _ in
                    return 300
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        present(youtubeViewController, animated: true, completion: nil)
    }
}

// MARK: Struct for Diffable DataSource
struct EpisodeDetails: Hashable {
    let id: UUID
    let item: Episodes
    init(id: UUID = UUID(), _ item: Episodes) {
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
