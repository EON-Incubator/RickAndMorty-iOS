//
//  TVShowEpisodeObject.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-10.
//

import Foundation
import RealmSwift

/// A TV show episode.
class TVShowEpisodeObject: RealmSwift.Object {

    /// TV show episode identifier.
    @Persisted var id: Int
    /// TV show episode name.
    @Persisted var name: String
    /// TV show episode number.
    @Persisted var episodeNumber: Int
    /// TV show episode season number.
    @Persisted var seasonNumber: Int
    /// TV show episode overview.
    @Persisted var overview: String?
    /// TV show episode air date.
    @Persisted var airDate: Date?
    /// TV show episode production code.
    @Persisted var productionCode: String?
    /// TV show episode still image path.
    @Persisted var stillPath: String?
//    /// TV show episode crew.
//    @Persisted var crew: [CrewMember]?
//    /// TV show episode guest cast members.
//    @Persisted var guestStars: [CastMember]?
    /// Average vote score.
    @Persisted var voteAverage: Double?
    /// Number of votes.
    @Persisted var voteCount: Int?

    /// Creates a new `TVShowEpisode`.
    ///
    /// - Parameters:
    ///    - id: TV show episode identifier.
    ///    - name: TV show episode name.
    ///    - episodeNumber: TV show episode number.
    ///    - seasonNumber: TV show episode season number.
    ///    - overview: TV show episode overview.
    ///    - airDate: TV show episode air date.
    ///    - productionCode: TV show episode production code.
    ///    - stillPath: TV show episode still image path.
    ///    - crew: TV show episode crew.
    ///    - guestStars: TV show episode guest cast members.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
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
