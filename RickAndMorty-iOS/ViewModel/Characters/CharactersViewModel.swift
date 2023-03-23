//
//  CharactersViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

struct FilterOptions {
    var status: String
    var gender: String
}

class CharactersViewModel {

    var characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }

    var filterOptions = FilterOptions(status: "", gender: "") {
        didSet {
            fetchData(page: 1)
        }
    }

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                status: GraphQLNullable<String>(stringLiteral: filterOptions.status),
                gender: GraphQLNullable<String>(stringLiteral: filterOptions.gender))) { result in

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
