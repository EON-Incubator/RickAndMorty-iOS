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
}
