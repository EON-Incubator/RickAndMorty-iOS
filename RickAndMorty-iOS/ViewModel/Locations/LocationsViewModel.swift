//
//  LocationsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import Foundation
import Combine

class LocationsViewModel {

    var locations = CurrentValueSubject<[RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                type: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.locations?.results {
                            self?.mapData(page: page, locations: results)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }

    func mapData(page: Int, locations: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        if page == 1 {
            self.locations.value = (locations.compactMap { $0 })
        } else {
            self.locations.value.append(contentsOf: (locations.compactMap { $0 }) )
        }
    }
}
