//
//  LocationDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import UIKit
import Combine

class LocationDetailsViewController: UIViewController {

    let locationDetailsView = LocationDetailsView()
    let viewModel = LocationDetailsViewModel()
    weak var coordinator: MainCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

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
        viewModel.currentPage = 1
    }

    func subscribeToViewModel() {
//        viewModel.location.sink(receiveValue: { location in
//            var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyAPI.GetLocationQuery.Data.Location>()
//            snapshot.appendSections([.appearance])
//            snapshot.appendItems(location, toSection: .appearance)
//            self.dataSource.apply(snapshot, animatingDifferences: true)
//
//            // Dismiss refresh control.
//            DispatchQueue.main.async {
//                self.locationDetailsView.collectionView.refreshControl?.endRefreshing()
//            }
//
//        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.currentPage = 1
    }

    func loadMore() {
        viewModel.currentPage += 1
    }

}

// MARK: - CollectionView DataSource
extension LocationDetailsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationDetailsView.collectionView, cellProvider: { (collectionView, indexPath, location) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationRowCell.identifier, for: indexPath) as? LocationRowCell
            cell?.upperLabel.text = location.name
            cell?.lowerLeftLabel.text = location.type
            cell?.lowerRightLabel.text = location.dimension
            for index in 0...3 {
                let isIndexValid = location.residents.indices.contains(index)
                if isIndexValid {
                    let urlString = location.residents[index]?.image ?? ""
                    cell?.characterAvatarImageViews[index].sd_setImage(with: URL(string: urlString))
                }
            }
            return cell
        })
    }
}

// MARK: - CollectionView Delegate
extension LocationDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
