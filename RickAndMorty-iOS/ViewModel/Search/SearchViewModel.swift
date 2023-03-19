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
                case .failure(let error):
                    print(error)
                }
            }
    }
}
