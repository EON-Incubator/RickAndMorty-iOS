//
//  Characters.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-11.
//

import Foundation
import RealmSwift

class Characters: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var gender: String
    @Persisted var status: String
    @Persisted var species: String
    @Persisted var type: String

    convenience init(id: String, name: String, image: String, gender: String, status: String,
                     species: String, type: String) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.gender = gender
        self.status = status
        self.species = species
        self.type = type
    }
}
