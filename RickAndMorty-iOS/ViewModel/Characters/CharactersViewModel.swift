//
//  CharactersViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine
import RealmSwift

struct FilterOptions {
    var status: String
    var gender: String
}

class CharactersViewModel {

    let charactersForSearch = CurrentValueSubject<[Characters], Never>([])
    var characters = CurrentValueSubject<[Characters], Never>([])
    var networkTimeoutMessage: PassthroughSubject<String, Never> = .init()
    var name = ""
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
    weak var coordinator: MainCoordinator?

    func fetchData(page: Int, name: String = "") {
        if Network.shared.isOfflineMode() {
            getDataFromDB(page: page, name: name)
            return
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: GraphQLNullable<String>(stringLiteral: name),
                status: GraphQLNullable<String>(stringLiteral: filterOptions.status),
                gender: GraphQLNullable<String>(stringLiteral: filterOptions.gender))) { [weak self] result in

                    switch result {
                    case .success(let response):
                        if let results = response.data?.characters?.results {
                            self?.mapData(page: page, characters: results)
                        }
                    case .failure(let error):
                        print(error)
                        Network.shared.setOfflineMode(true)
                        self?.networkTimeoutMessage.send(error.localizedDescription)
                    }

                }
    }

    func getDataFromDB(page: Int, name: String = "") {
        if let results = DBManager.shared.getCharacters(page: page, status: filterOptions.status, gender: filterOptions.gender, name: name) {
            self.mapDataFromDB(page: page, characters: results)
        } else {
            self.characters.value = [Characters]()
        }
    }

    func mapDataFromDB(page: Int, characters: Results<Characters>) {
        if page == 1 {
            self.characters.value = (characters.compactMap { $0 })
        } else {
            self.characters.value.append(contentsOf: (characters.compactMap { $0 }) )
        }
    }

    func mapData(page: Int, characters: [RickAndMortyAPI.GetCharactersQuery.Data.Characters.Result?]) {

        var charatersArray = [Characters]()

        for item in characters {
            let character = Characters()
            character.id = item?.id ?? ""
            character.name = item?.name ?? ""
            character.gender = item?.gender ?? ""
            character.image = item?.image ?? ""
            character.species = item?.species ?? ""
            character.status = item?.status ?? ""
            character.type = item?.type ?? ""
            charatersArray.append(character)
        }

        charactersForSearch.value = (charatersArray.compactMap { $0 })

        if page == 1 {
            self.characters.value = (charatersArray.compactMap { $0 })
        } else {
            self.characters.value.append(contentsOf: (charatersArray.compactMap { $0 }) )
        }
    }

    func refresh() {
        currentPage = 1
    }

    func loadMore() {
        currentPage += 1
    }

    func showCharactersFilter(viewController: UIViewController, viewModel: CharactersViewModel, sender: AnyObject, onDismiss: (() -> Void)? = nil) {
        coordinator?.showCharactersFilter(viewController: viewController, viewModel: viewModel, sender: sender, onDismiss: onDismiss)
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
