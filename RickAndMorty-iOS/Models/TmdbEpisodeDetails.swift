//
//  TVShowEpisodeObject.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-10.
//

import Foundation
import RealmSwift

class TmdbEpisodeDetails: RealmSwift.Object {

    @Persisted(primaryKey: true) var id: Int
    @Persisted var episodeId: String
    @Persisted var name: String
    @Persisted var episodeNumber: Int
    @Persisted var seasonNumber: Int
    @Persisted var overview: String?
    @Persisted var airDate: Date?
    @Persisted var productionCode: String?
    @Persisted var stillPath: String?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int?
    @Persisted var episodeImages = List<TmdbEpisodeImages>()
    @Persisted var episodeVideos = List<TmdbEpisodeVideos>()

    convenience init(id: Int, name: String, episodeNumber: Int, seasonNumber: Int, overview: String? = nil,
                     airDate: Date? = nil, productionCode: String? = nil, stillPath: String? = nil,
                     voteAverage: Double? = nil,
                     voteCount: Int? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.productionCode = productionCode
        self.stillPath = stillPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}
