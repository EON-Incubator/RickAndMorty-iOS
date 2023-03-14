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
    }

    weak var coordinator: MainCoordinator?
    let locationDetailsView = LocationDetailsView()
    let viewModel = LocationDetailsViewModel()
    var locationId: String

    typealias DataSource = UICollectionViewDiffableDataSource<LocationDetailsSection, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

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
        title = "Locations"
        locationDetailsView.collectionView.delegate = self
        locationDetailsView.collectionView.refreshControl = UIRefreshControl()
        locationDetailsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        subscribeToViewModel()
        viewModel.locationId = locationId
    }

    func subscribeToViewModel() {
        viewModel.location.sink(receiveValue: { location in

            self.title = location.name

            var snapshot = NSDiffableDataSourceSnapshot<LocationDetailsSection, AnyHashable>()
            snapshot.appendSections([.info, .residents])
            snapshot.appendItems([LocationDetails(location), LocationDetails(location)], toSection: .info)
            snapshot.appendItems(location.residents, toSection: .residents)
            self.dataSource.apply(snapshot, animatingDifferences: true)

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

            var cell = UICollectionViewCell()

            switch indexPath.section {
            case 0:
                if let locationDetails = location as? LocationDetails {
                    let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
                    switch indexPath.item {
                    case 0:
                        infoCell?.leftLabel.text = "Type"
                        infoCell?.rightLabel.text = locationDetails.item.name
                        infoCell?.infoImage.image = UIImage(named: "gender")
                    case 1:
                        infoCell?.leftLabel.text = "Dimension"
                        infoCell?.rightLabel.text = locationDetails.item.dimension
                        infoCell?.infoImage.image = UIImage(named: "dna")
                    default:
                        infoCell?.rightLabel.text = "-"
                    }
                    cell = infoCell!
                }

            case 1:
                if let character = location as? RickAndMortyAPI.GetLocationQuery.Data.Location.Resident? {
                    let characterRowCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterRowCell.identifier, for: indexPath) as? CharacterRowCell
                    let urlString = character?.image ?? ""
                    characterRowCell?.upperLabel.text = character?.name
                    characterRowCell?.lowerLeftLabel.text = character?.gender
                    characterRowCell?.lowerRightLabel.text = character?.species
                    characterRowCell?.characterAvatarImageView.sd_setImage(with: URL(string: urlString))
                    cell = characterRowCell!
                }

            default:
                cell = UICollectionViewCell()
            }

            return cell
        })

        // for custom header
        dataSource.supplementaryViewProvider = { (_ collectionView, _ kind, indexPath) in
            guard let headerView = self.locationDetailsView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else {
                fatalError()
            }
            headerView.textLabel.text = "\(LocationDetailsSection.allCases[indexPath.section])".uppercased()
            headerView.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            return headerView
        }
    }
}

// MARK: - CollectionView Delegate
extension LocationDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
