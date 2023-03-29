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

    weak var coordinator: MainCoordinator?
    var characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
    var charactersForSearch = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])

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

    var name = ""

    func fetchData(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: GraphQLNullable<String>(stringLiteral: self.name),
                status: GraphQLNullable<String>(stringLiteral: filterOptions.status),
                gender: GraphQLNullable<String>(stringLiteral: filterOptions.gender))) { [weak self] result in

                    switch result {
                    case .success(let response):
                        if let results = response.data?.characters?.results {
                            self?.mapData(page: page, characters: results)
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

    func showCharactersFilter(viewController: UIViewController, viewModel: CharactersViewModel, sender: AnyObject, completion: (() -> Void)? = nil) {
        coordinator?.showCharactersFilter(viewController: viewController, viewModel: viewModel, sender: sender, completion: completion)
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
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
