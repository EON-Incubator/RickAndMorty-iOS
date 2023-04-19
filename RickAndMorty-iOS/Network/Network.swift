//
//  Network.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-02-28.
//

import Foundation
import Network
import Apollo
import RealmSwift
import TMDb
import SDWebImage
import UIKit

// swiftlint: disable file_length
class Network {
    static let shared = Network()
    let networkMontior = NWPathMonitor()
    let defaults = UserDefaults.standard
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

    private var isEpisodeDetailsDataDownloaded = false {
        didSet {
            if isEpisodeDetailsDataDownloaded == true {
                downloadLocations(page: 1)
            }
        }
    }

    private var isLocationsDataDownloaded = false {
        didSet {
            if isLocationsDataDownloaded == true {
                downloadCharacters(page: 1)
            }
        }
    }

    private var isCharactersDataDownloaded = false {
        didSet {
            if isCharactersDataDownloaded == true {
                cacheCharactersImages()
            }
        }
    }

    private var isCharactersImagesDownloaded = false {
        didSet {
            if isCharactersImagesDownloaded == true {
                cacheEpisodesImages()
            }
        }
    }

    private var isEpisodesImagesDownloaded = false {
        didSet {
            if isEpisodesImagesDownloaded == true {
                DownloadProgressView.shared.dismiss()
                defaults.set(true, forKey: "isDownloadCompleted")
            }
        }
    }

    func setOfflineMode(_ mode: Bool) {
        defaults.set(mode, forKey: "isOfflineMode")
    }

    func isOfflineMode() -> Bool {
        defaults.bool(forKey: "isOfflineMode")
    }
}

// MARK: - Download Operations
extension Network {
    func downloadAllData() {
        defaults.set(false, forKey: "isDownloadCompleted")
        DownloadProgressView.shared.show()
        downloadEpisodes(page: 1)
    }

    func downloadCharacters(page: Int) {
        if charactersTotalPages > 0 {
            let progress = Float(page) / Float(charactersTotalPages)
            let progressMsg = String(format: "Downloading Characters...%.0f%%", progress * 100)
            DownloadProgressView.shared.titleLabel.text = progressMsg
            DownloadProgressView.shared.progressView.progress = progress
        }
        apollo.fetch(
            query: RickAndMortyAPI.GetCharactersWithDetailsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page))) { [weak self] result in

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
                                self?.isCharactersDataDownloaded = true
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }

                }
    }

    func downloadEpisodes(page: Int) {
        if episodesTotalPages > 0 {
            let progress = Float(page) / Float(episodesTotalPages)
            let progressMsg = String(format: "Downloading Episodes...%.0f%%", progress * 100)
            DownloadProgressView.shared.titleLabel.text = progressMsg
            DownloadProgressView.shared.progressView.progress = progress
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

    func downloadLocations(page: Int) {
        if locationsTotalPages > 0 {
            let progress = Float(page) / Float(locationsTotalPages)
            let progressMsg = String(format: "Downloading Locations...%.0f%%", progress * 100)
            DownloadProgressView.shared.titleLabel.text = progressMsg
            DownloadProgressView.shared.progressView.progress = progress
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
                        } else {
                            self?.isLocationsDataDownloaded = true
                        }
                    }
                case .failure(let error):
                    print(error)
                }
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
            isEpisodeDetailsDataDownloaded = true
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func downloadEpisodeDetails(season: Int, episode: Int, parentId: String) {
        DispatchQueue.main.async {
            let progressMsg = "Downloading Episode Details..."
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

            saveEpisodeDetails(tmdbEpisodeDetails, parentId: parentId)
        }
    }
}

// MARK: - LocalDB Save Operations
extension Network {
    func saveCharacters(_ results: [RickAndMortyAPI.GetCharactersWithDetailsQuery.Data.Characters.Result?]) {
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

            do {

                let realm = try Realm()

                if let originId = item?.origin?.id {
                    let origin = realm.object(ofType: Locations.self, forPrimaryKey: originId)
                    character.origin = origin
                }

                if let locationId = item?.location?.id {
                    let location = realm.object(ofType: Locations.self, forPrimaryKey: locationId)
                    character.location = location
                }

                if let episodes = item?.episode {
                    for epi in episodes {
                        if let episode = realm.object(ofType: Episodes.self, forPrimaryKey: epi?.id) {
                            character.episodes.append(episode)
                        }
                    }
                }
            } catch {
                print("REALM ERROR: error in initializing realm")
            }
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

    func saveEpisodeDetails(_ tmdbEpisodeDetails: TmdbEpisodeDetails, parentId: String) {
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

// MARK: - LocalDB Read Operations
extension Network {

    func search(keyword: String) -> SearchResults {
        var characters = [Characters]()
        var locationsWithName = [Locations]()
        var locationsWithType = [Locations]()
        var uniqueEpisodes = [Episodes]()

        do {
            let realm = try Realm()
            let char = realm.objects(Characters.self).filter("name CONTAINS[c] %@", keyword)
            characters = Array(char)
            let locWithName = realm.objects(Locations.self).filter("name CONTAINS[c] %@", keyword)
            locationsWithName = Array(locWithName)
            let locWithType = realm.objects(Locations.self).filter("type CONTAINS[c] %@", keyword)
            locationsWithType = Array(locWithType)
            let episodeFilterByOverview = realm.objects(Episodes.self).filter("episodeDetails.overview  CONTAINS[c] %@", keyword.lowercased())
            let episodeFilterByName = realm.objects(Episodes.self).filter("episodeDetails.name  CONTAINS[c] %@", keyword.lowercased())

            let episodes = Array(episodeFilterByName) + Array(episodeFilterByOverview)
            uniqueEpisodes = Array(Set(episodes))
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

        let searchResults = SearchResults(characters: characters, charactersTotalPages: 1, locationsWithName: locationsWithName, locationsWithNameTotalPages: 1, locationsWithType: locationsWithType, locationsWithTypeTotalPages: 1, episodes: uniqueEpisodes)

        return searchResults
    }

    func getCharacters(page: Int, status: String = "", gender: String = "", name: String = "") -> Results<Characters>? {
        let status = status.count > 0 ? status : "*"
        let gender = gender.count > 0 ? gender : "*"
        let name = name.count > 0 ? name : "*"

        do {
            let realm = try Realm()
            let characters = realm.objects(Characters.self).filter("status LIKE[c] %@ AND gender LIKE[c] %@ AND name LIKE[c] %@", status, gender, name)
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

    func getEpisodesImages() -> Results<TmdbEpisodeImages>? {
        do {
            let realm = try Realm()
            let episodesImages = realm.objects(TmdbEpisodeImages.self)
            return episodesImages
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }
}
// MARK: - Check for Data Update
extension Network {
    func checkForUpdate() {
        Network.shared.apollo.fetch(query: RickAndMortyAPI.GetEpisodesCountQuery()) { [weak self] result in
            switch result {
            case .success(let response):
                if let count = response.data?.episodes?.info?.count as? Int {
                    // Currently there are {count} episodes from the API.
                    if let episodeCountFromDB = self?.episodeCountFromDB() {
                        // Currently there are {episodeCountFromDB} episodes from the local DB.
                        if episodeCountFromDB == -1 { return }
                        let isDownloadCompleted = self?.defaults.bool(forKey: "isDownloadCompleted") ?? false
                        if (count > episodeCountFromDB) || !isDownloadCompleted {
                            // New data availble.
                            let downloadAlert = UIAlertController(title: K.DataUpdate.downloadAlertTitle, message: K.DataUpdate.downloadAlertMsg, preferredStyle: .alert)
                            let downloadAction = UIAlertAction(title: K.DataUpdate.downloadAlertDownloadButton, style: .default) { _ in
                                Network.shared.downloadAllData()
                            }
                            downloadAlert.addAction(downloadAction)
                            let cancel = UIAlertAction(title: K.DataUpdate.downloadAlertCancelButton, style: .cancel)
                            downloadAlert.addAction(cancel)
                            DownloadProgressView.shared.currentWindow?.rootViewController?.present(downloadAlert, animated: true)
                        } else {
                            // User have the latest data.
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func episodeCountFromDB() -> Int {
        do {
            let realm = try Realm()
            let episodes = realm.objects(Episodes.self)
            return episodes.count
        } catch {
            print("REALM ERROR: error in initializing realm")
            return -1
        }
    }
}

// MARK: - Image Caching
extension Network {
    func cacheCharactersImages() {
        if let characters = getCharacters(page: 1) {
            var imageURLs = [URL]()
            for character in characters {
                if let url = URL(string: character.image) {
                    imageURLs.append(url)
                }
            }
            SDWebImagePrefetcher.shared.prefetchURLs(imageURLs, progress: { (noOfFinishedUrls, noOfTotalUrls) in
                let progress = Float(noOfFinishedUrls) / Float(noOfTotalUrls)
                let progressMsg = String(format: "Downloading Characters Images...%.0f%%", progress * 100)
                DispatchQueue.main.async {
                    DownloadProgressView.shared.titleLabel.text = progressMsg
                    DownloadProgressView.shared.progressView.progress = progress
                }
            }, completed: { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.isCharactersImagesDownloaded = true
                }
            })
        }
    }

    func cacheEpisodesImages() {
        if let episodeImages = getEpisodesImages() {
            var imageURLs = [URL]()
            for image in episodeImages {
                if let url = URL(string: K.Tmdb.imageBaseUrl + (image.filePath ?? "")) {
                    imageURLs.append(url)
                }
            }
            SDWebImagePrefetcher.shared.prefetchURLs(imageURLs, progress: { (noOfFinishedUrls, noOfTotalUrls) in
                let progress = Float(noOfFinishedUrls) / Float(noOfTotalUrls)
                let progressMsg = String(format: "Downloading Episodes Images...%.0f%%", progress * 100)
                DispatchQueue.main.async {
                    DownloadProgressView.shared.titleLabel.text = progressMsg
                    DownloadProgressView.shared.progressView.progress = progress
                }
            }, completed: { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.isEpisodesImagesDownloaded = true
                }
            })
        }
    }
}
// swiftlint: enable file_length
