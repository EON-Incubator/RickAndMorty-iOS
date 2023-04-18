//
//  Locations.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-11.
//

import Foundation
import RealmSwift

class Locations: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var dimension: String
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var residents = RealmSwift.List<Characters>()
}
