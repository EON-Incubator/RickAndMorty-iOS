//
//  LocationsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit
import Combine

class LocationsViewController: BaseViewController {

    private let locationsView = LocationsView()
    private let viewModel: LocationsViewModel

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private var dataSource: DataSource?
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()

    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = locationsView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = K.Titles.locations
        locationsView.collectionView.delegate = self
        locationsView.collectionView.refreshControl = UIRefreshControl()
        locationsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        viewModel.refresh()
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .empty])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 8), toSection: .empty)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.locations.sink(receiveValue: { [weak self] locations in
            if !locations.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.appearance])
                    snapshot.appendItems(locations, toSection: .appearance)
                    self?.dataSource?.apply(snapshot, animatingDifferences: true)
                }
                self?.locationsView.loadingView.spinner.stopAnimating()
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self?.locationsView.collectionView.refreshControl?.endRefreshing()
            }

        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.refresh()
    }
}

// MARK: - CollectionView DataSource
extension LocationsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationsView.collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationRowCell.identifier, for: indexPath) as? LocationRowCell

            // section with empty location cells
            if indexPath.section == 1 {
                cell?.showLoadingAnimation()
                return cell
            }

            let location = data as? RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result
            cell?.upperLabel.text = location?.name
            cell?.lowerLeftLabel.text = location?.type
            cell?.lowerRightLabel.text = location?.dimension
            for index in 0...3 {
                let isIndexValid = location?.residents.indices.contains(index)
                if isIndexValid ?? false {
                    let urlString = location?.residents[index]?.image ?? ""
                    cell?.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 50, height: 50)])
                }
            }
            if location?.dimension == "" {
                cell?.lowerRightLabel.isHidden = true
            }
            return cell
        })
    }
}

// MARK: - CollectionView Delegate
extension LocationsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            locationsView.loadingView.spinner.startAnimating()
            viewModel.loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        if let location = dataSource?.itemIdentifier(for: indexPath) as? RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result {
            viewModel.goLocationDetails(id: location.id ?? "", navController: navigationController ?? UINavigationController())
        }
    }
}
