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
                        if let results = response.data?.episodes?.results {
                            self.mapData(page: page, episodes: results)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }

    func mapData(page: Int, episodes: [RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result?]) {
        if page == 1 {
            self.episodes.value = (episodes.compactMap { $0 })
        } else {
            self.episodes.value.append(contentsOf: (episodes.compactMap { $0 }) )
        }
    }
}
