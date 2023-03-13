//
//  DemoViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-09.
//

import UIKit
import Combine

class DemoViewModel {

    var character = PassthroughSubject<RickAndMortyAPI.GetCharacterQuery.Data.Character, Never>()
    var characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
    var currentPage = 0 {
        didSet {
            fetchCharacter()
            fetchData(page: currentPage)
        }
    }

    func fetchCharacter() {
        Network.shared.apollo.fetch(query: RickAndMortyAPI.GetCharacterQuery(
            characterId: "1")) { result in
                switch result {
                case .success(let response):
                    if let char = response.data?.character {
                        self.character.send(char)
                    }

                case .failure(let error):
                    print(error)
                }
            }
    }

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                status: nil,
                gender: nil)) { result in

                    switch result {
                    case .success(let response):
                        self.characters.value = (response.data?.characters?.results?
                            .compactMap { $0?.fragments.characterBasics })!

                    case .failure(let error):
                        print(error)
                    }

                }
    }
}
