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
import Combine

struct DownloadProgress {
    var message: String
    var progress: Float
}

class Network {
    static let shared = Network()
    let networkMontior = NWPathMonitor()
    let defaults = UserDefaults.standard
    let apollo = ApolloClient(url: URL(string: K.Apollo.graphQLUrl)!)
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
                showDownloadProgress.send(false)
                setDownloadCompleted(true)
                setOfflineMode(true)
            }
        }
    }

    var downloadProgress: PassthroughSubject<DownloadProgress, Never> = .init()
    var showDownloadProgress: PassthroughSubject<Bool, Never> = .init()
    var showDownloadAlert: PassthroughSubject<UIAlertController, Never> = .init()

    func setOfflineMode(_ mode: Bool) {
        defaults.set(mode, forKey: K.UserDefaultsKeys.isOfflineMode)
    }

    func isOfflineMode() -> Bool {
        defaults.bool(forKey: K.UserDefaultsKeys.isOfflineMode)
    }

    func setDownloadCompleted(_ mode: Bool) {
        defaults.set(mode, forKey: K.UserDefaultsKeys.isDownloadCompleted)
    }

    func isDownloadCompleted() -> Bool {
        defaults.bool(forKey: K.UserDefaultsKeys.isDownloadCompleted)
    }
}

// MARK: - Download Operations
extension Network {
    func downloadAllData() {
        setDownloadCompleted(false)
        showDownloadProgress.send(true)

        downloadEpisodes(page: 1)
    }

    func downloadCharacters(page: Int) {
        if charactersTotalPages > 0 {
            let progress = Float(page) / Float(charactersTotalPages)
            let progressMsg = String(format: "Downloading Characters...%.0f%%", progress * 100)
            downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
        }
        apollo.fetch(
            query: RickAndMortyAPI.GetCharactersWithDetailsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page))) { [weak self] result in

                    switch result {
                    case .success(let response):

                        if let results = response.data?.characters?.results {
                            DBManager.shared.saveCharacters(results)
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
            downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodesQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                episode: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.episodes?.results {
                            DBManager.shared.saveEpisodes(results)
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
            downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
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
                        DBManager.shared.saveLocations(results)
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
            let progress: Float = 0.0
            self.downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
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

            DBManager.shared.saveEpisodeDetails(tmdbEpisodeDetails, parentId: parentId)
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
                    let episodeCountFromDB = DBManager.shared.getEpisodeCount()
                    // Currently there are {episodeCountFromDB} episodes from the local DB.
                    if episodeCountFromDB == -1 { return }
                    let isDownloadCompleted = self?.isDownloadCompleted()
                    if (count > episodeCountFromDB) || !(isDownloadCompleted ?? false) {
                        // New data availble.
                        let downloadAlert = UIAlertController(title: K.DataUpdate.downloadAlertTitle, message: K.DataUpdate.downloadAlertMsg, preferredStyle: .alert)
                        let downloadAction = UIAlertAction(title: K.DataUpdate.downloadAlertDownloadButton, style: .default) { _ in
                            Network.shared.downloadAllData()
                        }
                        downloadAlert.addAction(downloadAction)
                        let cancel = UIAlertAction(title: K.DataUpdate.downloadAlertCancelButton, style: .cancel)
                        downloadAlert.addAction(cancel)
                        self?.showDownloadAlert.send(downloadAlert)

                    } else {
                        // User have the latest data.
                    }

                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Image Caching
extension Network {
    func cacheCharactersImages() {
        if let characters = DBManager.shared.getCharacters(page: 1) {
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
                    self.downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
                }
            }, completed: { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.isCharactersImagesDownloaded = true
                }
            })
        }
    }

    func cacheEpisodesImages() {
        if let episodeImages = DBManager.shared.getEpisodesImages() {
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
                    self.downloadProgress.send(DownloadProgress(message: progressMsg, progress: progress))
                }
            }, completed: { [weak self] (_, _) in
                DispatchQueue.main.async {
                    self?.isEpisodesImagesDownloaded = true
                }
            })
        }
    }
}
