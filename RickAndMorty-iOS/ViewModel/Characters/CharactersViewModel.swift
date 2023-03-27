//
//  CharactersViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

class CharactersViewModel {

    var characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
    var charactersForSearch = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])

    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }
    var currentStatus = ""
    var currentGender = ""
    var name = ""

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: GraphQLNullable<String>(stringLiteral: self.name),
                status: GraphQLNullable<String>(stringLiteral: self.currentStatus),
                gender: GraphQLNullable<String>(stringLiteral: self.currentGender))) { result in

                    switch result {
                    case .success(let response):
                        if let results = response.data?.characters?.results {
                            self.mapData(page: page, characters: results)
                        }
                    case .failure(let error):
                        print(error)
                    }

                }
    }

    func mapData(page: Int, characters: [RickAndMortyAPI.GetCharactersQuery.Data.Characters.Result?]) {
        self.charactersForSearch.value = (characters.compactMap { $0?.fragments.characterBasics })
        if page == 1 {
            self.characters.value = (characters.compactMap { $0?.fragments.characterBasics })
        } else {
            self.characters.value.append(contentsOf: (characters.compactMap { $0?.fragments.characterBasics }) )
        }
    }

}
// MARK: Extension for Hashable (Equatable)
extension RickAndMortyAPI.CharacterBasics: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: RickAndMortyAPI.CharacterBasics, rhs: RickAndMortyAPI.CharacterBasics) -> Bool {
        lhs.id == rhs.id
    }
}
