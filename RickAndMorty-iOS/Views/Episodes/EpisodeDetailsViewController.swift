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
        case emptyInfo
        case emptyCharacters
    }

    let episodeDetailsView = EpisodeDetailsView()
    let viewModel: EpisodeDetailsViewModel

    typealias DataSource = UICollectionViewDiffableDataSource<EpisodeDetailsSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodeDetailsSection, AnyHashable>
    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    init(viewModel: EpisodeDetailsViewModel) {
        self.viewModel = viewModel
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
        showEmptyData()
        subscribeToViewModel()
        viewModel.fetchData()
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.info, .characters, .emptyInfo, .emptyCharacters])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 2), toSection: .emptyInfo)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 4), toSection: .emptyCharacters)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.episode.sink(receiveValue: { [weak self] episode in
            self?.title = episode.name
            if !episode.characters.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.info, .characters])
                    snapshot.appendItems([EpisodeDetails(episode), EpisodeDetails(episode)], toSection: .info)
                    snapshot.appendItems(episode.characters, toSection: .characters)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
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

            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell else { return nil }

            guard let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell else { return nil }

            switch indexPath.section {
            case 0:
                return self?.configInfoCell(cell: infoCell, data: episode, itemIndex: indexPath.item)
            case 1:
                if let character = episode as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode.Character? {
                    let urlString = character?.image ?? ""
                    characterRowCell.characterAvatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
                    characterRowCell.upperLabel.text = character?.name
                    characterRowCell.lowerLeftLabel.text = character?.gender
                    characterRowCell.lowerRightLabel.text = character?.species
                    characterRowCell.characterStatusLabel.text = character?.status
                    characterRowCell.characterStatusLabel.backgroundColor = characterRowCell.statusColor(character?.status ?? "")
                    return characterRowCell
                }
                // empty sections
            case 2:
                showLoadingAnimation(currentCell: infoCell)
                return infoCell
            case 3:
                showLoadingAnimation(currentCell: characterRowCell)
                return characterRowCell
            default:
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })

        // for custom header
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.episodeDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = indexPath.section == 0 || indexPath.section == 2 ? K.Headers.info : K.Headers.characters
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
            viewModel.goCharacterDetails(id: (character?.id) ?? "", navController: self.navigationController ?? UINavigationController())
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
