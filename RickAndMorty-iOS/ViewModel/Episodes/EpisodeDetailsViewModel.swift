//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine
import TMDb

class EpisodeDetailsViewModel {

    let episode = PassthroughSubject<RickAndMortyAPI.GetEpisodeQuery.Data.Episode, Never>()
    var episodeId: String
    weak var coordinator: MainCoordinator?
    var episodeData: (any Hashable)?

    init(episodeId: String) {
        self.episodeId = episodeId
    }

    var episodeDetails: TVShowEpisode? {
        didSet {
            if let data = episodeData as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode {
                self.episode.send(data)
            }
        }
    }

    var episodeImages: TVShowEpisodeImageCollection?
//https://image.tmdb.org/t/p/w500/oWaKdUeMOlVZem3v9DWsdDGlTuY.jpg

    var episodeNumber: String? = "" {
        didSet {
            let tmdb = TMDbAPI(apiKey: "1ecd1b26d36c0ce0ec76aec3676d5773")
            let episodeArray = episodeNumber?.split(separator: "", maxSplits: 5)
            let episode = "\(episodeArray?[4] ?? "")\(episodeArray?[5] ?? "")"
            let season = "\(episodeArray?[1] ?? "")\(episodeArray?[2] ?? "")"
            Task {
                episodeDetails = try? await tmdb.tvShowEpisodes.details(forEpisode: Int(episode) ?? 0, inSeason: Int(season) ?? 0, inTVShow: 60625)
                episodeImages = try? await tmdb.tvShowEpisodes.images(forEpisode: Int(episode) ?? 0, inSeason: Int(season) ?? 0, inTVShow: 60625)
            }
        }
    }

    func fetchData() {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodeQuery(episodeId: episodeId)) { result in
                switch result {
                case .success(let response):
                    if let episode = response.data?.episode {
                        self.episodeNumber = episode.episode
                        self.episodeData = episode
                    }
                case .failure(let error):
                    print(error)
                    self.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }

            }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
