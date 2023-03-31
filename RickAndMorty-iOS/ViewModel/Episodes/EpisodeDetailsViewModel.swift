//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodeDetailsViewModel {

    weak var coordinator: MainCoordinator?
    var episode = PassthroughSubject<RickAndMortyAPI.GetEpisodeQuery.Data.Episode, Never>()
    var episodeId: String

    init(episodeId: String) {
        self.episodeId = episodeId
    }

    func fetchData() {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodeQuery(episodeId: episodeId)) { [weak self] result in

                switch result {
                case .success(let response):
                    if let epi = response.data?.episode {
                        self?.episode.send(epi)
                    }
                case .failure(let error):
                    print(error)
                }

            }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
