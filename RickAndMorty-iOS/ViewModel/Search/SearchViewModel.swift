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
                    self?.searchResults.send(response.data!)

                    self?.characters.value = (response.data?.characters?.results?.compactMap { $0 })!
                    self?.locatonsWithGivenName.value = (response.data?.locationsWithName?.results?.compactMap { $0 })!
                    self?.locationsWithGivenType.value = (response.data?.locationsWithType?.results?.compactMap { $0 })!

                case .failure(let error):
                    print(error)
                }
            }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }

    func goLocationDetails(id: String, navController: UINavigationController) {
        coordinator?.goLocationDetails(id: id, navController: navController)
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
