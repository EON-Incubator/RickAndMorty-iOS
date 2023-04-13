//
//  LocationsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class LocationsViewModel {

    let locationsNameSearch = CurrentValueSubject<[RickAndMortyAPI.LocationDetails], Never>([])
    let locationsTypeSearch = CurrentValueSubject<[RickAndMortyAPI.LocationDetails], Never>([])

    var locations = CurrentValueSubject<[RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }
    var name = ""
    var type = ""
    weak var coordinator: MainCoordinator?

    func fetchData(page: Int, name: String = "", type: String = "") {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: GraphQLNullable<String>(stringLiteral: name),
                type: GraphQLNullable<String>(stringLiteral: type)
            )) { [weak self] result in
                switch result {
                case .success(let response):
                    if let results = response.data?.locations?.results {
                        self?.mapData(page: page, locations: results)
                    }
                case .failure(let error):
                    print(error)
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }
            }
    }

    func mapData(page: Int, locations: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        locationsNameSearch.value = (locations.compactMap { $0?.fragments.locationDetails })
        locationsTypeSearch.value = (locations.compactMap { $0?.fragments.locationDetails })
        if page == 1 {
            self.locations.value = (locations.compactMap { $0 })
        } else {
            self.locations.value.append(contentsOf: (locations.compactMap { $0 }) )
        }
    }

    func refresh() {
        currentPage = 1
    }

    func loadMore() {
        currentPage += 1
    }

    func goLocationDetails(id: String, navController: UINavigationController, residentCount: Int) {
        coordinator?.goLocationDetails(id: id, navController: navController, residentCount: residentCount)
    }
}
