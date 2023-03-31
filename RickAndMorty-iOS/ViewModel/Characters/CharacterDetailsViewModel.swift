//
//  CharacterDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

class CharacterDetailsViewModel {

    let character = PassthroughSubject<RickAndMortyAPI.GetCharacterQuery.Data.Character, Never>()

    var selectedCharacter = "" {
        didSet {
            fetchData(charID: selectedCharacter)
        }
    }

    func fetchData(charID: String) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharacterQuery(characterId: charID)) { [weak self] result in

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
