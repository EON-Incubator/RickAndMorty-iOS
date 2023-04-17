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
    var episodeDetails: TVShowEpisode?
    var episodeVideo: String?

    init(episodeId: String) {
        self.episodeId = episodeId
    }

    var episodeImages: TVShowEpisodeImageCollection? {
        didSet {
            if let data = episodeData as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode {
                self.episode.send(data)
            }
        }
    }

    var episodeNumber: String? = "" {
        didSet {
            let tmdb = TMDbAPI(apiKey: Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")
            let episodeArray = episodeNumber?.split(separator: "", maxSplits: 5)
            let episode = "\(episodeArray?[4] ?? "")\(episodeArray?[5] ?? "")"
            let season = "\(episodeArray?[1] ?? "")\(episodeArray?[2] ?? "")"
            Task {
                episodeDetails = try? await tmdb.tvShowEpisodes.details(forEpisode: Int(episode) ?? 0, inSeason: Int(season) ?? 0, inTVShow: 60625)
                let video = try? await tmdb.tvShowEpisodes.videos(forEpisode: Int(episode) ?? 0, inSeason: Int(season) ?? 0, inTVShow: 60625)
                if let videoId = video?.results.first?.key {
                    episodeVideo = videoId
                }
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
