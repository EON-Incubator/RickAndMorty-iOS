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

    typealias DataSource = UICollectionViewDiffableDataSource<Section, RickAndMortyAPI.LocationBasics>
    private var dataSource: DataSource!

    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = locationsView
        // demoView.button.addTarget(self, action: #selector(loadMore), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    func subscribeToViewModel() {
        viewModel.locations.sink(receiveValue: { locationBasics in
            var snapshot = NSDiffableDataSourceSnapshot<Section, RickAndMortyAPI.LocationBasics>()
            snapshot.appendSections([.appearance])
            snapshot.appendItems(locationBasics, toSection: .appearance)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }).store(in: &cancellables)
    }

    @objc func loadMore() {
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
            return cell
        })
    }
}
