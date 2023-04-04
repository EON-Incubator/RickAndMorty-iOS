//
//  SearchViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import Foundation
import Combine
import UIKit

class SearchViewModel {

    weak var coordinator: MainCoordinator?
    let searchResults = PassthroughSubject<RickAndMortyAPI.SearchForQuery.Data, Never>()

    // for viewModel testing
    let characters = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.Characters.Result], Never>([])
    let locatonsWithGivenName = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result], Never>([])
    let locationsWithGivenType = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithType.Result], Never>([])

    var searchInput = "" {
        didSet {
            fetchData(input: searchInput)
        }
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

                    self?.searchResults.send(data)

                    self?.characters.value = charactersData.compactMap { $0 }
                    self?.locatonsWithGivenName.value = locationsWithNameData.compactMap { $0 }
                    self?.locationsWithGivenType.value = locationsWithTypeData.compactMap { $0 }

                case .failure(let error):
                    print(error)
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }
            }
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
