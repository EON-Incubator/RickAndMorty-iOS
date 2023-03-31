//
//  EpisodesViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import Foundation
import Combine
import UIKit

class EpisodesViewModel {

    weak var coordinator: MainCoordinator?
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
                episode: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.episodes?.results {
                            self?.mapData(page: page, episodes: results)
                        }
                    case .failure(let error):
                        print(error)
                        self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
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

    func refresh() {
        currentPage = 1
    }

    func loadMore() {
        currentPage += 1
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        coordinator?.goEpisodeDetails(id: id, navController: navController)
    }

}
