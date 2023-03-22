//
//  LocationsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit
import Combine

class LocationsViewController: UIViewController {

    let locationsView = LocationsView()
    let viewModel = LocationsViewModel()
    weak var coordinator: MainCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    override func loadView() {
        view = locationsView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Locations"
        locationsView.collectionView.delegate = self
        locationsView.collectionView.refreshControl = UIRefreshControl()
        locationsView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .empty])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 8), toSection: .empty)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.locations.sink(receiveValue: { [self] locations in
            if !locations.isEmpty {
                snapshot.deleteAllItems()
                snapshot.appendSections([.appearance])
                snapshot.appendItems(locations, toSection: .appearance)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.locationsView.collectionView.refreshControl?.endRefreshing()
            }

        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.currentPage = 1
    }

    func loadMore() {
        viewModel.currentPage += 1
    }
}

// MARK: - CollectionView DataSource
extension LocationsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationsView.collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationRowCell.identifier, for: indexPath) as? LocationRowCell

            // section with empty location cells
            if indexPath.section == 1 {
                showLoadingAnimation(currentCell: cell!)
                return cell
            }

            let location = data as? RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result
            cell?.upperLabel.text = location?.name
            cell?.lowerLeftLabel.text = location?.type
            cell?.lowerRightLabel.text = location?.dimension
            for index in 0...3 {
                let isIndexValid = location?.residents.indices.contains(index)
                if isIndexValid! {
                    let urlString = location?.residents[index]?.image ?? ""
                    cell?.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString))
                }
            }
            hideLoadingAnimation(currentCell: cell!)
            return cell
        })
    }
}

// MARK: - CollectionView Delegate
extension LocationsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        coordinator?.goLocationDetails(id: viewModel.locations.value[indexPath.row].id!, navController: self.navigationController!)
    }
}
