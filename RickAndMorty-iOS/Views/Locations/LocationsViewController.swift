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

    typealias DataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = locationsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Locations"
        configureDataSource()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    func subscribeToViewModel() {
        viewModel.locations.sink(receiveValue: { locations in
            var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result>()
            snapshot.appendSections([.appearance])
            snapshot.appendItems(locations, toSection: .appearance)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }

    func loadMore() {
        viewModel.currentPage += 1
    }

}

// MARK: - CollectionView DataSource
extension LocationsViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: locationsView.collectionView, cellProvider: { (collectionView, indexPath, location) -> UICollectionViewCell? in
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
