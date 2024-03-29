//
//  Constants.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-30.
//

import Foundation
import UIKit

// swiftlint: disable type_name
struct K {
    struct Apollo {
        static let graphQLUrl = "https://rickandmortyapi.com/graphql"
    }

    struct Tmdb {
        static let tmdbApiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        static let showId = 60625
        static let imageBaseUrl = "https://image.tmdb.org/t/p/w400"
    }

    struct DataUpdate {
        static let downloadAlertTitle = "New data available"
        static let downloadAlertMsg = "Do you want to download Rick and Morty data for offline access?"
        static let downloadAlertDownloadButton = "Download"
        static let downloadAlertCancelButton = "Cancel"
    }

    struct Titles {
        static let characters = "Characters"
        static let locations = "Locations"
        static let episodes = "Episodes"
        static let search = "Search"
        static let filter = "Filter"
        static let clearButton = "Clear"
        static let loadMore = "↓    Load More   ↓"
        static let download = "Download"
        static let hulu = "Hulu"
        static let amazon = "Amazon"
        static let adultSwim = "Adult Swim"
        static let apple = "Apple"
    }

    struct Identifiers {
        static let characters = "CharactersCollectionView"
        static let characterDetails = "CharacterDetailsView"
        static let locations = "LocationsCollectionView"
        static let locationDetails = "LocationDetailsCollectionView"
        static let episodeDetails = "EpisodeDetailsCollectionView"
        static let search = "SearchTextField"
        static let dismissButton = "DismissButton"
        static let filter = "CharactersFilterView"
        static let characterRowCell = "CharacterRowCell"
        static let characterCell = "CharacterCell"
        static let characterAvatarCell = "CharacterAvatarCell"
        static let loadMoreCell = "LoadMoreCell"
        static let locationRowCell = "LocationRowCell"
        static let downloadProgressView = "DownloadProgressView"
        static let carouselCell = "CarouselCell"
        static let episodeOverviewCell = "EpisodeOverviewCell"
    }

    struct Headers {
        static let identifier = "HeaderView"
        static let appearance = "APPEARANCE"
        static let info = "INFO"
        static let locations = "LOCATIONS"
        static let residents = "RESIDENTS"
        static let characters = "CHARACTERS"
        static let overview = "OVERVIEW"
        static let episodes = "EPISODES"
    }

    struct Info {
        static let gender = "Gender"
        static let species = "Species"
        static let status = "Status"
        static let origin = "Origin"
        static let lastSeen = "Last Seen"
        static let type = "Type"
        static let dimension = "Dimension"
        static let episode = "Episode"
        static let airDate = "Air Date"
        static let rating = "Rating"
        static let identifier = "InfoCell"
    }

    struct FilterLabels {
        static let alive = "Alive"
        static let dead = "Dead"
        static let unknown = "Unknown"
        static let male = "Male"
        static let female = "Female"
        static let genderless = "Genderless"
        static let status = "STATUS"
        static let gender = "GENDER"
        static let title = "Filter"
    }

    struct Images {
        static let logo = "RickAndMorty"
        static let gender = "gender"
        static let species = "dna"
        static let status = "heart"
        static let origin = "chick"
        static let lastSeen = "map"
        static let filter = "filter"
        static let systemClose = "xmark"
        static let systemGlobeFull = "globe"
        static let systemGlobeHalf = "globe.asia.australia"
        static let television = "tv"
        static let calendar = "calendar"
        static let systemBackArrow = "arrow.backward.circle"
        static let systemCharacters = "person.text.rectangle"
        static let map = "map"
        static let systemMagnifyingGlass = "magnifyingglass"
        static let systemPerson = "person.circle"
        static let systemStar = "star"
        static let hulu = "hulu"
        static let amazon = "amazon"
        static let adultSwim = "adultSwim"
        static let systemApple = "apple.logo"
        static let systemplay = "play"
        static let systemlink = "link"
    }

    struct Fonts {
        static let primary = "Creepster-Regular"
        static let secondary = "Chalkboard SE Regular"
        static let secondaryBold = "Chalkboard SE Bold"
    }

    struct Colors {
        static let locationsView = "LocationView"
        static let locationCell = "LocationCell"
        static let episodeView = "EpisodeView"
        static let episodeCell = "EpisodeCell"
        static let infoCell = "InfoCell"
        static let characterView = "CharacterView"
        static let characterRow = "characterRowBackgroundColor"
        static let gender = UIColor(red: 0.87, green: 0.96, blue: 0.95, alpha: 0.4)
        static let species = UIColor(red: 0.98, green: 0.99, blue: 0.76, alpha: 0.4)
        static let episodeNumber = UIColor(red: 1.00, green: 0.75, blue: 0.66, alpha: 0.4)
        static let episodeDate = UIColor(red: 1.00, green: 0.92, blue: 0.71, alpha: 0.4)
        static let characterNameLabel = UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 0.7)
        static let filterButtonActive = UIColor(red: 0.65, green: 0.76, blue: 0.81, alpha: 1.00)
        static let filterButton = UIColor(red: 0.65, green: 0.76, blue: 0.81, alpha: 1.00)
        static let dimension = UIColor(red: 0.87, green: 0.99, blue: 0.98, alpha: 0.4)
        static let type = UIColor(red: 1.00, green: 0.75, blue: 0.66, alpha: 0.4)
    }

    struct Urls {
        static let amazon = "https://www.amazon.com/gp/video/detail/0JHRH3V853S6L8MJQA4Q04BREF/ref=atv_dl_rdr?autoplay=1"
        static let hulu = "https://www.hulu.com/series/rick-and-morty-d76d6361-3fbf-4842-8dd7-e05520557280"
        static let adultSwim = "https://www.adultswim.com/videos/rick-and-morty"
        static let apple = "https://tv.apple.com/ca/show/rick-and-morty/umc.cmc.12dp30hnvyq5fbm9716puu8zc"
    }

    struct UserDefaultsKeys {
        static let isOfflineMode = "isOfflineMode"
        static let isDownloadCompleted = "isDownloadCompleted"
    }
}
// swiftlint: enable type_name
