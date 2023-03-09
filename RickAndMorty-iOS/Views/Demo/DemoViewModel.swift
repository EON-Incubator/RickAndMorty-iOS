//
//  DemoViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-09.
//

import UIKit
import Combine

class DemoViewModel {

    var characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
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
