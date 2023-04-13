//
//  Network.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-02-28.
//

import Foundation
import Apollo
import RealmSwift
import TMDb

class Network {
    static let shared = Network()
    let apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)

    private var charactersTotalPages = 0
    private var locationsTotalPages = 0
    private var episodesTotalPages = 0

    private var isEpisodesDataDownloaded = false {
        didSet {
            if isEpisodesDataDownloaded == true {
                downloadAllEpisodeDetails()
            }
        }
    }

    func downloadAllData() {
        DownloadProgressView.shared.show()
        downloadCharacters(page: 1)
        downloadEpisodes(page: 1)
        downloadLocations(page: 1)
    }

    func downloadCharacters(page: Int) {
        if charactersTotalPages > 0 {
            let progress = Float(page) / Float(charactersTotalPages) * 100
            let progressMsg = String(format: "Downloading Characters...%.0f%%", progress)
            DownloadProgressView.shared.titleLabel.text = progressMsg
        }
        apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                status: nil,
                gender: nil)) { [weak self] result in

                    switch result {
                    case .success(let response):

                        if let results = response.data?.characters?.results {
                            self?.saveCharacters(results)
                        }
                        if let pageInfo = response.data?.characters?.info {
                            if pageInfo.next != nil {
                                self?.charactersTotalPages = pageInfo.pages ?? 0
                                self?.downloadCharacters(page: page + 1)
                            } else {
                                DownloadProgressView.shared.dismiss()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }

                }
    }

    func saveCharacters(_ results: [RickAndMortyAPI.GetCharactersQuery.Data.Characters.Result?]) {
        var characters = [Characters]()

        for item in results {
            let character = Characters()
            character.id = item?.id ?? ""
            character.name = item?.name ?? ""
            character.image = item?.image ?? ""
            character.gender = item?.gender ?? ""
            character.species = item?.species ?? ""
            character.status = item?.status ?? ""
            character.type = item?.type ?? ""
            characters.append(character)
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(characters, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }
    }

    func downloadEpisodes(page: Int) {
        if episodesTotalPages > 0 {
            let progress = Float(page) / Float(episodesTotalPages) * 100
            let progressMsg = String(format: "Downloading Episodes...%.0f%%", progress)
            DownloadProgressView.shared.titleLabel.text = progressMsg
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodesQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                episode: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.episodes?.results {
                            self?.saveEpisodes(results)
                        }
                        if let pageInfo = response.data?.episodes?.info {
                            if pageInfo.next != nil {
                                self?.episodesTotalPages = pageInfo.pages ?? 0
                                self?.downloadEpisodes(page: page + 1)
                            } else {
                                self?.isEpisodesDataDownloaded = true
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }

    func saveEpisodes(_ results: [RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result?]) {
        var episodes = [Episodes]()

        for item in results {
            let episode = Episodes()
            episode.id = item?.id ?? ""
            episode.name = item?.name ?? ""
            episode.episode = item?.episode ?? ""
            episode.airDate = item?.air_date ?? ""
            for characterItem in item?.characters ?? [] {
                let character = Characters()
                character.id = characterItem?.id ?? ""
                character.name = characterItem?.name ?? ""
                character.image = characterItem?.image ?? ""
                character.gender = characterItem?.gender ?? ""
                character.species = characterItem?.species ?? ""
                character.status = characterItem?.status ?? ""
                character.type = characterItem?.type ?? ""
                episode.characters.append(character)
            }
            episodes.append(episode)
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(episodes, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }
    }

    func downloadLocations(page: Int) {
        if locationsTotalPages > 0 {
            let progress = Float(page) / Float(locationsTotalPages) * 100
            let progressMsg = String(format: "Downloading Locations...%.0f%%", progress)
            DownloadProgressView.shared.titleLabel.text = progressMsg
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                type: nil
            )) { [weak self] result in
                switch result {
                case .success(let response):
                    if let results = response.data?.locations?.results {
                        self?.saveLocations(results)
                    }
                    if let pageInfo = response.data?.locations?.info {
                        if pageInfo.next != nil {
                            self?.locationsTotalPages = pageInfo.pages ?? 0
                            self?.downloadLocations(page: page + 1)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }

    func saveLocations(_ results: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        var locations = [Locations]()

        for item in results {
            let location = Locations()
            location.id = item?.id ?? ""
            location.name = item?.name ?? ""
            location.dimension = item?.dimension ?? ""
            location.type = item?.type ?? ""
            for locationItem in item?.residents ?? [] {
                let character = Characters(id: locationItem?.id ?? "",
                                           name: locationItem?.name ?? "",
                                           image: locationItem?.image ?? "",
                                           gender: locationItem?.gender ?? "",
                                           status: locationItem?.status ?? "",
                                           species: locationItem?.species ?? "",
                                           type: locationItem?.type ?? "")
                location.residents.append(character)
            }
            locations.append(location)
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(locations, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func downloadAllEpisodeDetails() {
        do {
            let realm = try Realm()
            let episodes = realm.objects(Episodes.self)
            for item in episodes {
                let seasonNumberString = String(item.episode.dropFirst())
                    .prefix(while: { $0.isNumber })
                let seasonNumber = Int(seasonNumberString) ?? 0
                let episodeNumberString = String(item.episode.dropFirst(4))
                let episodeNumber = Int(episodeNumberString) ?? 0

                downloadEpisodeDetails(season: seasonNumber, episode: episodeNumber, parentId: item.id)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func downloadEpisodeDetails(season: Int, episode: Int, parentId: String) {
        DispatchQueue.main.async {
            let progressMsg = "Downloading Details of Season \(season), Episode \(episode)..."
            DownloadProgressView.shared.titleLabel.text = progressMsg
        }
        let tmdb = TMDbAPI(apiKey: K.Tmdb.tmdbApiKey)
        Task {
            let episodeDetails = try? await tmdb.tvShowEpisodes.details(forEpisode: episode, inSeason: season, inTVShow: K.Tmdb.showId)

            let episodePhotos = try? await tmdb.tvShowEpisodes.images(forEpisode: episode, inSeason: season, inTVShow: K.Tmdb.showId)

            let episodeVideos = try? await tmdb.tvShowEpisodes.videos(forEpisode: episode, inSeason: season, inTVShow: K.Tmdb.showId)

            let tmdbEpisodeDetails = TmdbEpisodeDetails()
            tmdbEpisodeDetails.id = episodeDetails?.id ?? 0
            tmdbEpisodeDetails.episodeId = parentId
            tmdbEpisodeDetails.name = episodeDetails?.name ?? ""
            tmdbEpisodeDetails.episodeNumber = episodeDetails?.episodeNumber ?? 0
            tmdbEpisodeDetails.seasonNumber = episodeDetails?.seasonNumber ?? 0
            tmdbEpisodeDetails.overview = episodeDetails?.overview ?? ""
            tmdbEpisodeDetails.airDate = episodeDetails?.airDate ?? Date()
            tmdbEpisodeDetails.productionCode = episodeDetails?.productionCode ?? ""
            tmdbEpisodeDetails.stillPath = episodeDetails?.stillPath?.absoluteString ?? ""
            tmdbEpisodeDetails.voteAverage = episodeDetails?.voteAverage ?? 0
            tmdbEpisodeDetails.voteCount = episodeDetails?.voteCount ?? 0

            if let stills = episodePhotos?.stills {
                for item in stills {
                    let image = TmdbEpisodeImages(id: item.id.absoluteString, filePath: item.filePath.absoluteString)
                    tmdbEpisodeDetails.episodeImages.append(image)
                }
            }

            if let videos = episodeVideos?.results {
                for item in videos {
                    let video = TmdbEpisodeVideos(id: item.id, key: item.key, name: item.name, site: item.site)
                    tmdbEpisodeDetails.episodeVideos.append(video)
                }
            }

            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let episode = realm.objects(Episodes.self).first(where: { $0.id == parentId })!

                    try realm.write {
                        realm.add(tmdbEpisodeDetails, update: .modified)
                        episode.episodeDetails = tmdbEpisodeDetails
                    }
                } catch {
                    print("REALM ERROR: error in initializing realm")
                }
            }
        }
    }
}

extension Network {

    func getCharacters(page: Int) -> Results<Characters>? {
        do {
            let realm = try Realm()
            let characters = realm.objects(Characters.self)
            return page == 1 ? characters : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getCharacter(characterId: String) -> Characters? {
        do {
            let realm = try Realm()
            let character = realm.object(ofType: Characters.self, forPrimaryKey: characterId)
            return character
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getLocations(page: Int) -> Results<Locations>? {
        do {
            let realm = try Realm()
            let locations = realm.objects(Locations.self)
            return page == 1 ? locations : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getLocation(locationId: String) -> Locations? {
        do {
            let realm = try Realm()
            let location = realm.object(ofType: Locations.self, forPrimaryKey: locationId)
            return location
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisodes(page: Int) -> Results<Episodes>? {
        do {
            let realm = try Realm()
            let episodes = realm.objects(Episodes.self)
            return page == 1 ? episodes : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisode(episodeId: String) -> Episodes? {
        do {
            let realm = try Realm()
            let episode = realm.object(ofType: Episodes.self, forPrimaryKey: episodeId)
            return episode
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }
}
