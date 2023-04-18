//
//  EpisodeImages.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-12.
//

import Foundation
import RealmSwift

class TmdbEpisodeImages: RealmSwift.Object {

    @Persisted(primaryKey: true) var id: String?
    @Persisted var filePath: String?

    convenience init(id: String, filePath: String? = nil) {
        self.init()
        self.id = id
        self.filePath = filePath
    }

}
