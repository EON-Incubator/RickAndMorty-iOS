//
//  CharacterInfoHasher.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import Foundation

struct CharacterInfoHasher: Hashable {
    var id: UUID
    var item: RickAndMortyAPI.GetCharacterQuery.Data.Character
    init(id: UUID = UUID(), item: RickAndMortyAPI.GetCharacterQuery.Data.Character) {
        self.id = id
        self.item = item
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: CharacterInfoHasher, rhs: CharacterInfoHasher) -> Bool {
        lhs.id == rhs.id
    }
}
