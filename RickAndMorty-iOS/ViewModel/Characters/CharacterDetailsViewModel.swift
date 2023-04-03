//
//  CharacterDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

class CharacterDetailsViewModel {

    weak var coordinator: MainCoordinator?
    let character = PassthroughSubject<RickAndMortyAPI.GetCharacterQuery.Data.Character, Never>()
    private var characterId: String

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
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }

            }
    }

    func goLocationDetails(id: String, navController: UINavigationController) {
        coordinator?.goLocationDetails(id: id, navController: navController)
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        coordinator?.goEpisodeDetails(id: id, navController: navController)
    }

}
