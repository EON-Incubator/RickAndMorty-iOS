//
//  LocationDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit
import Combine

class LocationDetailsViewController: UIViewController {

    enum LocationDetailsSection: Int, CaseIterable {
        case info
        case residents
        case emptyInfo
        case emptyResidents
    }

    weak var coordinator: MainCoordinator?
    let locationDetailsView = LocationDetailsView()
    let viewModel = LocationDetailsViewModel()
    var locationId: String

    typealias DataSource = UICollectionViewDiffableDataSource<LocationDetailsSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<LocationDetailsSection, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    init(locationId: String) {
        self.locationId = locationId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = locationDetailsView
        navigationController?.navigationBar.prefersLargeTitles = true
        locationDetailsView.collectionView.delegate = self
        locationDetailsView.collectionView.refreshControl = UIRefreshControl()
        locationDetailsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        viewModel.locationId = locationId
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.info, .residents, .emptyInfo, .emptyResidents])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 2), toSection: .emptyInfo)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.location.sink(receiveValue: { [self] location in
            self.title = location.name
            if location.id != nil {
                snapshot.deleteAllItems()
                snapshot.appendSections([.info, .residents])
                snapshot.appendItems([LocationDetails(location), LocationDetails(location)], toSection: .info)
                snapshot.appendItems(location.residents, toSection: .residents)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.locationDetailsView.collectionView.refreshControl?.endRefreshing()
            }

        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.locationId = self.locationId
    }
}

// MARK: - CollectionView DataSource
extension LocationDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationDetailsView.collectionView, cellProvider: { (collectionView, indexPath, location) -> UICollectionViewCell? in

            let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
            let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell

            switch indexPath.section {
            case 0:
                hideLoadingAnimation(currentCell: infoCell!)
                return self.configLocationInfoCell(cell: infoCell!, data: location, itemIndex: indexPath.item)
            case 1:
                if let character = location as? RickAndMortyAPI.GetLocationQuery.Data.Location.Resident? {
                    let urlString = character?.image ?? ""
                    characterRowCell?.characterAvatarImageView.sd_setImage(with: URL(string: urlString))
                    characterRowCell?.upperLabel.text = character?.name
                    characterRowCell?.lowerLeftLabel.text = character?.gender
                    characterRowCell?.lowerRightLabel.text = character?.species
                    characterRowCell?.characterStatusLabel.text = character?.status
                    characterRowCell?.characterStatusLabel.backgroundColor = characterRowCell?.statusColor(character?.status ?? "")
                    hideLoadingAnimation(currentCell: characterRowCell!)
                    return characterRowCell!
                }
            case 2:
                showLoadingAnimation(currentCell: infoCell!)
                return infoCell!
            case 3:
                showLoadingAnimation(currentCell: characterRowCell!)
                return characterRowCell!
            default:
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })

        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.locationDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = indexPath.section == 0 || indexPath.section == 2 ? "INFO" : "RESIDENTS"
            headerView.textLabel.textColor = .gray
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }

    func configLocationInfoCell(cell: InfoCell, data: AnyHashable, itemIndex: Int) -> UICollectionViewListCell {
        if let locationDetails = data as? LocationDetails {
            switch itemIndex {
            case 0:
                cell.leftLabel.text = "Type"
                cell.rightLabel.text = locationDetails.item.name
                cell.infoImage.image = UIImage(systemName: "globe.asia.australia")
            case 1:
                cell.leftLabel.text = "Dimension"
                cell.rightLabel.text = locationDetails.item.dimension
                cell.infoImage.image = UIImage(systemName: "globe")
            default:
                cell.rightLabel.text = "-"
            }
        }
        return cell
    }
}

// MARK: - CollectionView Delegate
extension LocationDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let character = dataSource.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetLocationQuery.Data.Location.Resident? {
            coordinator?.goCharacterDetails(id: (character?.id)!, navController: self.navigationController!)
        }
    }
}

// MARK: Struct for Diffable DataSource
struct LocationDetails: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetLocationQuery.Data.Location
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
