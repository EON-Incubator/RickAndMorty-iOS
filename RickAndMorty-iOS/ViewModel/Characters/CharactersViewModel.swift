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
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }
    var currentStatus = ""
    var currentGender = ""

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                status: GraphQLNullable<String>(stringLiteral: self.currentStatus),
                gender: GraphQLNullable<String>(stringLiteral: self.currentGender))) { result in

                    switch result {
                    case .success(let response):
                        if page == 1 {
                            self.characters.value = (response.data?.characters?.results?
                                .compactMap { $0?.fragments.characterBasics })!
                        } else {
                            self.characters.value.append(contentsOf: (response.data?.characters?.results?
                                .compactMap { $0?.fragments.characterBasics })!)
                        }

                    case .failure(let error):
                        print(error)
                    }

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
