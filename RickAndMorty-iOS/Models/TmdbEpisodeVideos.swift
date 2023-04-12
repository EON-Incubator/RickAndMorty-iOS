//
//  TmdbEpisodeVideos.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-12.
//

import Foundation
import RealmSwift

class TmdbEpisodeVideos: RealmSwift.Object {

    @Persisted(primaryKey: true) var id: String?
    @Persisted var key: String?
    @Persisted var name: String?
    @Persisted var site: String?

    convenience init(id: String? = nil, key: String?, name: String?, site: String?) {
        self.init()
        self.id = id
        self.key = key
        self.name = name
        self.site = site
    }
}
