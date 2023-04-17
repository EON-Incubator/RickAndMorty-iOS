//
//  CharacterDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import UIKit
import Combine

class CharacterDetailsViewModel {

    let character = PassthroughSubject<Characters, Never>()
    weak var coordinator: MainCoordinator?
    private var characterId: String

    init(characterId: String) {
        self.characterId = characterId
    }

    func fetchData() {
        if Network.shared.isOfflineMode() {
            getDataFromDB()
            return
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetCharacterQuery(characterId: characterId)) { [weak self] result in

                switch result {
                case .success(let response):
                    if let char = response.data?.character {
                        self?.mapData(character: char)
                    }
                case .failure(let error):
                    print(error)
                    Network.shared.setOfflineMode(true)
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }

            }
    }

    func mapData(character: RickAndMortyAPI.GetCharacterQuery.Data.Character) {
        let char = Characters()
        char.id = character.id ?? ""
        char.name = character.name ?? ""
        char.gender = character.gender ?? ""
        char.image = character.image ?? ""
        char.species = character.species ?? ""
        char.status = character.status ?? ""
        char.gender = character.gender ?? ""
        char.type = character.type ?? ""
        var episodesArray = [Episodes]()
        let episodes = character.episode
        for epi in episodes {
            let episode = Episodes()
            episode.id = epi?.id ?? ""
            episode.name = epi?.name ?? ""
            episode.airDate = epi?.air_date ?? ""
            episode.episode = epi?.episode ?? ""
            if let characters = epi?.characters {
                for cha in characters {
                    let character = Characters()
                    character.image = cha?.image ?? ""
                    episode.characters.append(character)
                }
            }
            episodesArray.append(episode)
        }
        char.episodes.append(objectsIn: episodesArray)
        self.character.send(char)
    }

    func getDataFromDB() {
        if let char = Network.shared.getCharacter(characterId: characterId) {
            self.character.send(char)
        }
    }

    func goLocationDetails(id: String, navController: UINavigationController) {
        coordinator?.goLocationDetails(id: id, navController: navController, residentCount: 0)
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        coordinator?.goEpisodeDetails(id: id, navController: navController)
    }

}
