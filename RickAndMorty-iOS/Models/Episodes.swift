//
//  Episodes.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-11.
//

import Foundation
import RealmSwift

class Episodes: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var episode: String
    @Persisted var airDate: String
    @Persisted var characters = RealmSwift.List<Characters>()
    @Persisted var episodeDetails: TmdbEpisodeDetails?
}
