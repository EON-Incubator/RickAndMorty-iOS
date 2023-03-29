//
//  CharacterDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

class CharacterDetailsViewModel {

    var character = PassthroughSubject<RickAndMortyAPI.GetCharacterQuery.Data.Character, Never>()
    var characterId: String

    init(characterId: String) {
        self.characterId = characterId
    }

    func fetchData() {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharacterQuery(characterId: characterId)) { [weak self] result in

                switch result {
                case .success(let response):
                    if let char = response.data?.character {
                        self?.character.send(char)
                    }
                case .failure(let error):
                    print(error)
                }

            }
    }
}
