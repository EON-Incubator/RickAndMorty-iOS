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

    let location = PassthroughSubject<Locations, Never>()
    weak var coordinator: MainCoordinator?
    var locationId: String
    var networkTimeoutMessage: PassthroughSubject<String, Never> = .init()
    init(locationId: String) {
        self.locationId = locationId
    }

    var residentCount = 0

    func getResidentCount() -> Int {
        return residentCount
    }

    func fetchData() {
        if Network.shared.isOfflineMode() {
            getDataFromDB()
            return
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationQuery(
                locationId: locationId
                )) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let loc = response.data?.location {
                            self?.mapData(location: loc)
                        }
                    case .failure(let error):
                        print(error)
                        Network.shared.setOfflineMode(true)
                        self?.networkTimeoutMessage.send(error.localizedDescription)
                    }
                }
    }

    func mapData(location: RickAndMortyAPI.GetLocationQuery.Data.Location) {
        let loc = Locations()
        loc.id = location.id ?? ""
        loc.name = location.name ?? ""
        loc.type = location.type ?? ""
        loc.dimension = location.dimension ?? ""
        var charactersArray = [Characters]()
        let charcters = location.residents
        for char in charcters {
            let character = Characters()
            character.id = char?.id ?? ""
            character.name = char?.name ?? ""
            character.gender = char?.gender ?? ""
            character.image = char?.image ?? ""
            character.species = char?.species ?? ""
            character.status = char?.status ?? ""
            character.type = char?.type ?? ""
            charactersArray.append(character)
        }
        loc.residents.append(objectsIn: charactersArray)
        self.location.send(loc)
    }

    func getDataFromDB() {
        if let loc = DBManager.shared.getLocation(locationId: locationId) {
            self.location.send(loc)
        }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
