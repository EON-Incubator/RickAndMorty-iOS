//
//  LocationDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-14.
//

import Foundation
import Combine
import UIKit

class LocationDetailsViewModel {

    weak var coordinator: MainCoordinator?
    var location = PassthroughSubject<RickAndMortyAPI.GetLocationQuery.Data.Location, Never>()
    var locationId: String

    init(locationId: String) {
        self.locationId = locationId
    }

    func fetchData() {
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

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
