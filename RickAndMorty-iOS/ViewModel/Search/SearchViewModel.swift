//
//  SearchViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import Foundation
import Combine
import UIKit

struct SearchResult {
    let characters: [Characters]
    let charactersTotalPages: Int
    let locationsWithName: [Locations]
    let locationsWithNameTotalPages: Int
    let locationsWithType: [Locations]
    let locationsWithTypeTotalPages: Int

}

class SearchViewModel {

    let searchResults = PassthroughSubject<SearchResult, Never>()
    // for viewModel testing
    let characters = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.Characters.Result], Never>([])
    let locatonsWithGivenName = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result], Never>([])
    let locationsWithGivenType = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithType.Result], Never>([])

    var searchInput = "" {
        didSet {
            fetchData(input: searchInput)
        }
    }
    weak var coordinator: MainCoordinator?

    func refresh(input: String) {
        searchInput = input
    }

    func fetchData(input: String) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.SearchForQuery(keyword: GraphQLNullable<String>(stringLiteral: input))) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let data = response.data else { return }
                    guard let charactersData = data.characters?.results else { return }
                    guard let locationsWithNameData = data.locationsWithName?.results else { return }
                    guard let locationsWithTypeData = data.locationsWithType?.results else { return }

                    self?.mapData(data: data)
                    // self?.searchResults.send(data)

                    self?.characters.value = charactersData.compactMap { $0 }
                    self?.locatonsWithGivenName.value = locationsWithNameData.compactMap { $0 }
                    self?.locationsWithGivenType.value = locationsWithTypeData.compactMap { $0 }

                case .failure(let error):
                    print(error)
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }
            }
    }

    func mapData(data: RickAndMortyAPI.SearchForQuery.Data) {

        var characters = [Characters]()
        var charactersTotalPages = 0
        var locationsWithName = [Locations]()
        var locationsWithNameTotalPages = 0
        var locationsWithType = [Locations]()
        var locationsWithTypeTotalPages = 0

        charactersTotalPages = data.characters?.info?.pages ?? 0
        locationsWithNameTotalPages = data.locationsWithName?.info?.pages ?? 0
        locationsWithTypeTotalPages = data.locationsWithType?.info?.pages ?? 0

        if let characterData = data.characters?.results {
            for item in characterData {
                let character = Characters()
                character.id = item?.id ?? ""
                character.name = item?.name ?? ""
                character.gender = item?.gender ?? ""
                character.image = item?.image ?? ""
                character.species = item?.species ?? ""
                character.status = item?.status ?? ""
                character.type = item?.type ?? ""
                characters.append(character)
            }
        }

        if let locationsWithNameData = data.locationsWithName?.results {
            for item in locationsWithNameData {
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
                locationsWithName.append(location)
            }
        }

        if let locationsWithTypeData = data.locationsWithType?.results {
            for item in locationsWithTypeData {
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
                locationsWithType.append(location)
            }
        }

        let searchResults = SearchResult(characters: characters, charactersTotalPages: charactersTotalPages, locationsWithName: locationsWithName, locationsWithNameTotalPages: locationsWithNameTotalPages, locationsWithType: locationsWithType, locationsWithTypeTotalPages: locationsWithTypeTotalPages)

        self.searchResults.send(searchResults)
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }

    func goLocationDetails(id: String, navController: UINavigationController, residentCount: Int) {
        coordinator?.goLocationDetails(id: id, navController: navController, residentCount: residentCount)
    }
}

extension RickAndMortyAPI.SearchForQuery.Data.Characters.Result: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: RickAndMortyAPI.SearchForQuery.Data.Characters.Result, rhs: RickAndMortyAPI.SearchForQuery.Data.Characters.Result) -> Bool {
        lhs.id == rhs.id
    }
}

extension RickAndMortyAPI.LocationDetails: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: RickAndMortyAPI.LocationDetails, rhs: RickAndMortyAPI.LocationDetails) -> Bool {
        lhs.id == rhs.id
    }
}
