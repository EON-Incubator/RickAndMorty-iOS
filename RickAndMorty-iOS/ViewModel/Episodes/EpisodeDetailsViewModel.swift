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

    let episode = PassthroughSubject<Episodes, Never>()
    let tmdb = TMDbAPI(apiKey: K.Tmdb.tmdbApiKey)
    weak var coordinator: MainCoordinator?
    var episodeId: String
    var seasonNo = 0
    var episodeNo = 0
    var episodeData: (any Hashable)?
    var episodeDetails: TVShowEpisode? {
        didSet {
            Task {
                episodeImages = try? await tmdb.tvShowEpisodes.images(forEpisode: episodeNo, inSeason: seasonNo, inTVShow: K.Tmdb.showId)
            }
        }
    }

    var episodeImages: TVShowEpisodeImageCollection? {
        didSet {
            if let data = episodeData as? RickAndMortyAPI.GetEpisodeQuery.Data.Episode {
                if let episodeDetails = episodeDetails {
                    self.mapData(episode: data, episodeDetails: episodeDetails, episodeImages: episodeImages)
                }
            }
        }
    }
    var episodeVideo: String?

    var episodeNumber: String? = "" {
        didSet {
            let episodeArray = episodeNumber?.split(separator: "", maxSplits: 5)
            episodeNo = Int("\(episodeArray?[4] ?? "")\(episodeArray?[5] ?? "")") ?? 0
            seasonNo = Int("\(episodeArray?[1] ?? "")\(episodeArray?[2] ?? "")") ?? 0
            Task {
                episodeDetails = try? await tmdb.tvShowEpisodes.details(forEpisode: episodeNo, inSeason: seasonNo, inTVShow: K.Tmdb.showId)
                let video = try? await tmdb.tvShowEpisodes.videos(forEpisode: episodeNo, inSeason: seasonNo, inTVShow: K.Tmdb.showId)
                if let videoId = video?.results.first?.key {
                    episodeVideo = videoId
                }
            }
        }
    }

    init(episodeId: String) {
        self.episodeId = episodeId
    }

    func fetchData() {
        if Network.shared.isOfflineMode() {
            getDataFromDB()
            return
        }
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
                    Network.shared.setOfflineMode(true)
                    self.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }

            }
    }

    func mapData(episode: RickAndMortyAPI.GetEpisodeQuery.Data.Episode, episodeDetails: TVShowEpisode, episodeImages: TVShowEpisodeImageCollection?) {

        let epi = Episodes()
        epi.id = episode.id ?? ""
        epi.name = episode.name ?? ""
        epi.airDate = episode.air_date ?? ""
        epi.episode = episode.episode ?? ""
        var charactersArray = [Characters]()
        let charcters = episode.characters
        for char in charcters {
            let character = Characters()
            character.id = char?.id ?? ""
            character.name = char?.name ?? ""
            character.gender = char?.gender ?? ""
            character.image = char?.image ?? ""
            character.species = char?.species ?? ""
            character.status = char?.status ?? ""
            character.type = char?.type ?? ""
            charactersArray.append(character)
        }
        epi.characters.append(objectsIn: charactersArray)

        let details = TmdbEpisodeDetails()
        details.id = episodeDetails.id
        details.name = episodeDetails.name
        details.episodeNumber = episodeDetails.episodeNumber
        details.seasonNumber = episodeDetails.seasonNumber
        details.overview = episodeDetails.overview
        details.airDate = episodeDetails.airDate
        details.voteCount = episodeDetails.voteCount
        details.voteAverage = episodeDetails.voteAverage
        details.stillPath = episodeDetails.stillPath?.absoluteString
        details.productionCode = episodeDetails.productionCode

        if let episodeImages = episodeImages {
            for item in episodeImages.stills {
                let image = TmdbEpisodeImages()
                image.id = item.id.absoluteString
                image.filePath = item.filePath.absoluteString
                details.episodeImages.append(image)
            }
        }

        epi.episodeDetails = details
        self.episode.send(epi)
    }

    func getDataFromDB() {
        if let epi = Network.shared.getEpisode(episodeId: episodeId) {
            self.episode.send(epi)
        }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
