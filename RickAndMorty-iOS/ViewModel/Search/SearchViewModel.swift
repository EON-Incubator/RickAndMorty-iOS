//
//  SearchViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import Foundation
import Combine
class SearchViewModel {

    var characters = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.Characters.Result], Never>([])

    var locationName = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithName.Result], Never>([])

    var locationType = CurrentValueSubject<[RickAndMortyAPI.SearchForQuery.Data.LocationsWithType.Result], Never>([])

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

                        self.characters.value = (response.data?.characters?.results?.compactMap { $0 })!

                    case .failure(let error):
                        print(error)
                    }
                }
    }
}
