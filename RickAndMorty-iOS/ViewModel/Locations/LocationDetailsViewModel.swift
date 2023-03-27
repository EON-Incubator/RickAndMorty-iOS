//
//  LocationDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import Foundation
import Combine

class LocationDetailsViewModel {

    var location = PassthroughSubject<RickAndMortyAPI.GetLocationQuery.Data.Location, Never>()

    var locationId = "" {
        didSet {
            fetchData(locationId: locationId)
        }
    }

    func fetchData(locationId: String) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationQuery(
                locationId: locationId
                )) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let loc = response.data?.location {
                            self?.location.send(loc)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
}
