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

    let locationsNameSearch = CurrentValueSubject<[Locations], Never>([])
    let locationsTypeSearch = CurrentValueSubject<[Locations], Never>([])

    var locations = CurrentValueSubject<[Locations], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }
    var name = ""
    var type = ""
    weak var coordinator: MainCoordinator?

    func fetchData(page: Int, name: String = "", type: String = "") {
        if UserDefaults().bool(forKey: "isOfflineMode") {
            getDataFromDB(page: page)
            return
        }
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

    func getDataFromDB(page: Int) {
        if let results = Network.shared.getLocations(page: page) {
            self.mapDataFromDB(page: page, locations: results)
        } else {
            self.locations.value = [Locations]()
        }
    }

    func mapDataFromDB(page: Int, locations: Results<Locations>) {
        if page == 1 {
            self.locations.value = (locations.compactMap { $0 })
        } else {
            self.locations.value.append(contentsOf: (locations.compactMap { $0 }) )
        }
    }

    func mapData(page: Int, locations: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {

        var locationsArray = [Locations]()

        for item in locations {
            let location = Locations()
            location.id = item?.id ?? ""
            location.name = item?.name ?? ""
            location.type = item?.type ?? ""
            location.dimension = item?.dimension ?? ""
            var charactersArray = [Characters]()
            if let charcters = item?.residents {
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
            }
            location.residents.append(objectsIn: charactersArray)
            locationsArray.append(location)
        }

        locationsNameSearch.value = (locationsArray.compactMap { $0 })
        locationsTypeSearch.value = (locationsArray.compactMap { $0 })

        if page == 1 {
            self.locations.value = (locationsArray.compactMap { $0 })
        } else {
            self.locations.value.append(contentsOf: (locationsArray.compactMap { $0 }) )
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
