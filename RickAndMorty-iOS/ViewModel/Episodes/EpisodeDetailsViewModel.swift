//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodeDetailsViewModel {
    let episode = PassthroughSubject<RickAndMortyAPI.GetEpisodeQuery.Data.Episode, Never>()

    var episodeID = "" {
        didSet {
            fetchData(epiID: episodeID)
        }
    }

    func fetchData(epiID: String) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodeQuery(episodeId: epiID)) { [weak self] result in

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
}
