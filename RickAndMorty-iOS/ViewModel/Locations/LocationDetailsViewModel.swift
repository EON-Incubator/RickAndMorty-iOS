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

    let location = PassthroughSubject<RickAndMortyAPI.GetLocationQuery.Data.Location, Never>()
    var locationId: String
    weak var coordinator: MainCoordinator?

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
                        self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                    }
                }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
