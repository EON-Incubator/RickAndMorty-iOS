//
//  EpisodesViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import Foundation
import Combine

class EpisodesViewModel {

    var episodes = CurrentValueSubject<[RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodesQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                episode: nil)) { result in
                    switch result {
                    case .success(let response):
                        if page == 1 {
                            self.episodes.value = (response.data?.episodes?.results?.compactMap { $0 })!
                        } else {
                            self.episodes.value.append(contentsOf: (response.data?.episodes?.results?.compactMap { $0 })! )
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }
}
