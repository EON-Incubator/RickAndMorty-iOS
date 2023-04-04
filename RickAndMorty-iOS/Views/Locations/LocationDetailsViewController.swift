//
//  LocationDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit
import Combine

class LocationDetailsViewController: BaseViewController {

    enum LocationDetailsSection: Int, CaseIterable {
        case info
        case residents
        case emptyInfo
        case emptyResidents
    }

    private let locationDetailsView = LocationDetailsView()
    private let viewModel: LocationDetailsViewModel

    typealias DataSource = UICollectionViewDiffableDataSource<LocationDetailsSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<LocationDetailsSection, AnyHashable>
    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()

    init(viewModel: LocationDetailsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = locationDetailsView
        locationDetailsView.collectionView.delegate = self
        locationDetailsView.collectionView.refreshControl = UIRefreshControl()
        locationDetailsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
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
        snapshot.appendSections([.info, .residents, .emptyInfo, .emptyResidents])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 2), toSection: .emptyInfo)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.location.sink(receiveValue: { [weak self] location in
            self?.title = location.name
            if location.id != nil {
                self?.snapshot.deleteAllItems()
                self?.snapshot.appendSections([.info, .residents])
                self?.snapshot.appendItems([LocationDetails(location), LocationDetails(location)], toSection: .info)
                self?.snapshot.appendItems(location.residents, toSection: .residents)
                if let snapshot = self?.snapshot {
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                }
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self?.locationDetailsView.collectionView.refreshControl?.endRefreshing()
            }

        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.fetchData()
    }
}

// MARK: - CollectionView DataSource
extension LocationDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationDetailsView.collectionView, cellProvider: { [weak self] (collectionView, indexPath, location) -> UICollectionViewCell? in

            switch indexPath.section {
            case 0:
                guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell else { return nil }
                return self?.configLocationInfoCell(cell: infoCell, data: location, itemIndex: indexPath.item)
            case 1:
                guard let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell else { return nil }
                if let character = location as? RickAndMortyAPI.GetLocationQuery.Data.Location.Resident? {
                    let urlString = character?.image ?? ""
                    characterRowCell.characterAvatarImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 100, height: 100)])
                    characterRowCell.upperLabel.text = character?.name
                    characterRowCell.lowerLeftLabel.text = character?.gender
                    characterRowCell.lowerRightLabel.text = character?.species
                    characterRowCell.characterStatusLabel.text = character?.status
                    characterRowCell.characterStatusLabel.backgroundColor = characterRowCell.statusColor(character?.status ?? "")
                    return characterRowCell
                }
            case 2:
                let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                infoCell?.showLoadingAnimation()
                return infoCell
            case 3:
                let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell
                characterRowCell?.showLoadingAnimation()
                return characterRowCell
            default:
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })
        applySupplementaryHeader()
    }

    func configLocationInfoCell(cell: InfoCell, data: AnyHashable, itemIndex: Int) -> UICollectionViewListCell {
        if let locationDetails = data as? LocationDetails {
            switch itemIndex {
            case 0:
                cell.leftLabel.text = K.Info.type
                cell.rightLabel.text = locationDetails.item.type
                cell.infoImage.image = UIImage(systemName: K.Images.systemGlobeHalf)

            case 1:
                cell.leftLabel.text = K.Info.dimension
                cell.rightLabel.text = locationDetails.item.dimension
                cell.infoImage.image = UIImage(systemName: K.Images.systemGlobeFull)
            default:
                cell.rightLabel.text = "-"
            }
        }
        return cell
    }

    func applySupplementaryHeader() {
        // for custom header
        dataSource?.supplementaryViewProvider = { [weak self] (_ collectionView, _ kind, indexPath) in
            guard let headerView = self?.locationDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.Headers.identifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = indexPath.section == 0 || indexPath.section == 2 ? K.Headers.info : K.Headers.residents
            headerView.textLabel.textColor = .gray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
}

// MARK: - CollectionView Delegate
extension LocationDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let character = dataSource?.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetLocationQuery.Data.Location.Resident? {
            viewModel.goCharacterDetails(id: character?.id ?? "", navController: navigationController ?? UINavigationController())
        }
    }
}

// MARK: Struct for Diffable DataSource
struct LocationDetails: Hashable {
    let id: UUID
    let item: RickAndMortyAPI.GetLocationQuery.Data.Location
    init(id: UUID = UUID(), _ item: RickAndMortyAPI.GetLocationQuery.Data.Location) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: LocationDetails, rhs: LocationDetails) -> Bool {
        lhs.id == rhs.id
    }
}
