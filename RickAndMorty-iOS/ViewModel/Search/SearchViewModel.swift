//
//  SearchViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import Foundation
import Combine

class SearchViewModel {

    var searchResults = PassthroughSubject<RickAndMortyAPI.SearchForQuery.Data, Never>()

    // for viewModel testing
    var characters = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.Characters.Result], Never>([])
    var locatonsWithGivenName = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result], Never>([])
    var locationsWithGivenType = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithType.Result], Never>([])

    var searchInput = "" {
        didSet {
            fetchData(input: searchInput)
        }
    }

    func fetchData(input: String) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.SearchForQuery(keyword: GraphQLNullable<String>(stringLiteral: input))) { result in
                switch result {
                case .success(let response):
                    self.searchResults.send(response.data!)

                    self.characters.value = (response.data?.characters?.results?.compactMap { $0 })!
                    self.locatonsWithGivenName.value = (response.data?.locationsWithName?.results?.compactMap { $0 })!
                    self.locationsWithGivenType.value = (response.data?.locationsWithType?.results?.compactMap { $0 })!

                case .failure(let error):
                    print(error)
                }
            }
    }
}
