//
//  CharacterDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-10.
//

import UIKit
import Combine
import SDWebImage

class CharacterDetailsViewController: UIViewController {

    let viewModel: CharacterDetailsViewModel
    let locationsViewModel = LocationsViewModel()
    var characterDetailsView = CharacterDetailsView()
    var characterID: String?
    var avatarImageUrl: String?
    var titleViewState: TitleViewState = .noTitle

    private var dataSource: DataSource?
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    enum TitleViewState {
        case noTitle, title, titleWithImage
    }

    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = characterDetailsView
        characterDetailsView.collectionView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        updateTitleView()
        viewModel.fetchData()
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .info, .location, .episodes, .empty, .emptyInfo, .emptyLocation])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 1), toSection: .empty)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 3), toSection: .emptyInfo)
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 2), toSection: .emptyLocation)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.character.sink(receiveValue: { [weak self] characterInfo in
            self?.title = characterInfo.name
            if !characterInfo.episode.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.appearance, .info, .location, .episodes])
                    snapshot.appendItems([CharacterDetails(characterInfo)], toSection: .appearance)
                    snapshot.appendItems([CharacterDetails(characterInfo), CharacterDetails(characterInfo), CharacterDetails(characterInfo)], toSection: .info)
                    snapshot.appendItems([CharacterDetails(characterInfo), CharacterDetails(characterInfo)], toSection: .location)
                    snapshot.appendItems(characterInfo.episode, toSection: .episodes)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                }
            }
        }).store(in: &cancellables)
    }
}

// MARK: - CollectionView DataSource
extension CharacterDetailsViewController {
    // swiftlint:disable cyclomatic_complexity
    private func configureDataSource() {
        dataSource = DataSource(collectionView: characterDetailsView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, characterInfo) -> UICollectionViewCell? in

            guard let avatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier, for: indexPath) as? AvatarCell else { return nil}
            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell else { return nil }
            guard let episodeCell = self?.characterDetailsView.episodeCell else { return nil }

            switch indexPath.section {
            case 0:
                if let character = characterInfo as? CharacterDetails {
                    guard let image = character.item.image else { fatalError("Image not found") }
                    self?.avatarImageUrl = image
                    avatarCell.characterImage.sd_setImage(with: URL(string: image), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 300, height: 300)])
                    return avatarCell
                }
            case 1:
                if let character = characterInfo as? CharacterDetails {
                    switch indexPath.item {
                    case 0:
                        return InfoCell.configCell(cell: infoCell,
                                                   leftLabel: K.Info.gender,
                                                   rightLabel: character.item.gender ?? "",
                                                   infoImage: UIImage(named: K.Images.gender) ?? UIImage())
                    case 1:
                        return InfoCell.configCell(cell: infoCell,
                                                   leftLabel: K.Info.species,
                                                   rightLabel: character.item.species ?? "",
                                                   infoImage: UIImage(named: K.Images.species) ?? UIImage())
                    default:
                        return InfoCell.configCell(cell: infoCell,
                                                   leftLabel: K.Info.status,
                                                   rightLabel: character.item.status ?? "",
                                                   infoImage: UIImage(named: K.Images.status) ?? UIImage())
                    }
                }
            case 2:
                if let character = characterInfo as? CharacterDetails {
                    switch indexPath.item {
                    case 0:
                        return InfoCell.configCell(cell: infoCell,
                                                   leftLabel: K.Info.origin,
                                                   rightLabel: (character.item.origin?.name) ?? "",
                                                   infoImage: UIImage(named: K.Images.origin) ?? UIImage())
                    default:
                        return InfoCell.configCell(cell: infoCell,
                                                   leftLabel: K.Info.lastSeen,
                                                   rightLabel: (character.item.location?.name) ?? "",
                                                   infoImage: UIImage(named: K.Images.lastSeen) ?? UIImage())
                    }
                }
            case 3:
                if let episode = characterInfo as?
                    RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode {
                    return collectionView.dequeueConfiguredReusableCell(using: episodeCell,
                                                                        for: indexPath,
                                                                        item: episode)
                }
            case 4:
                showLoadingAnimation(currentCell: avatarCell)
                avatarCell.characterImage.layer.borderWidth = 0
                avatarCell.backgroundColor = .secondarySystemBackground
                return avatarCell
            case 5:
                showLoadingAnimation(currentCell: infoCell)
                return infoCell
            case 6:
                showLoadingAnimation(currentCell: infoCell)
                return infoCell
            default:
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })

        // for custom header
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.characterDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            var headerTitle: String
            switch indexPath.section {
            case 4:
                headerTitle = K.Headers.appearance
            case 5:
                headerTitle = K.Headers.info
            case 6:
                headerTitle = K.Headers.locations
            default:
                headerTitle = "\(Section.allCases[indexPath.section])".uppercased()
            }
            headerView.textLabel.text = headerTitle
            headerView.textLabel.textColor = .lightGray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: - CollectionView Delegate
extension CharacterDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section > 1 {
            if let episode = dataSource?.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetCharacterQuery.Data.Character.Episode? {
                viewModel.goEpisodeDetails(id: (episode?.id) ?? "", navController: self.navigationController ?? UINavigationController())
            }
            if let character = dataSource?.itemIdentifier(for: indexPath) as? CharacterDetails {
                switch indexPath.row {
                case 0:
                    if let originID = character.item.origin?.id {
                        viewModel.goLocationDetails(id: originID, navController: self.navigationController ?? UINavigationController())
                    }
                default:
                    viewModel.goLocationDetails(id: (character.item.location?.id) ?? "", navController: self.navigationController ?? UINavigationController())
                }
            }
        }
    }

    // MARK: - Customize the Title View on scroll
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            titleViewState = .titleWithImage
            updateTitleView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            titleViewState = collectionView.contentOffset.y < 3 ? .noTitle : .title
            updateTitleView()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 4 {
            if titleViewState != .noTitle {
                titleViewState = .noTitle
                updateTitleView()
            }
        } else if scrollView.contentOffset.y < 100 && titleViewState != .title {
            titleViewState = .title
            updateTitleView()
        }
    }

    func updateTitleView() {
        switch titleViewState {
        case .noTitle:
            navigationItem.titleView?.removeFromSuperview()
        case .title:
            let titleWithImage = characterDetailsView.titleView(image: nil, title: title ?? "")
            self.navigationItem.titleView = titleWithImage
            UIView.transition(with: self.navigationController?.navigationBar ?? UIView(), duration: 0.25, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        case .titleWithImage:
            let titleWithImage = characterDetailsView.titleView(image: self.avatarImageUrl, title: title ?? "")
            self.navigationItem.titleView = titleWithImage
            UIView.transition(with: self.navigationController?.navigationBar ?? UIView(), duration: 0.25, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
}

// MARK: Struct for Diffable DataSource
struct CharacterDetails: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetCharacterQuery.Data.Character
    init(id: UUID = UUID(), _ item: RickAndMortyAPI.GetCharacterQuery.Data.Character) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: CharacterDetails, rhs: CharacterDetails) -> Bool {
        lhs.id == rhs.id
    }
}
