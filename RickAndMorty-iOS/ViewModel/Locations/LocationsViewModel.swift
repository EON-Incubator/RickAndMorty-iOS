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
    var locationsNameSearch = CurrentValueSubject<[RickAndMortyAPI.LocationDetails], Never>([])
    var locationsTypeSearch = CurrentValueSubject<[RickAndMortyAPI.LocationDetails], Never>([])

    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }

    var name = ""
    var type = ""

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: GraphQLNullable<String>(stringLiteral: name),
                type: GraphQLNullable<String>(stringLiteral: type)
            )) { result in
                switch result {
                case .success(let response):
                    if let results = response.data?.locations?.results {
                        self.mapData(page: page, locations: results)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }

    func mapData(page: Int, locations: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        self.locationsNameSearch.value = (locations.compactMap { $0?.fragments.locationDetails })
        self.locationsTypeSearch.value = (locations.compactMap { $0?.fragments.locationDetails })
        if page == 1 {
            self.locations.value = (locations.compactMap { $0 })
        } else {
            self.locations.value.append(contentsOf: (locations.compactMap { $0 }) )
        }
    }
}
