//
//  EpisodeDetailsViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodeDetailsViewModel {

    let episode = PassthroughSubject<Episodes, Never>()

    var episodeId: String
    weak var coordinator: MainCoordinator?

    init(episodeId: String) {
        self.episodeId = episodeId
    }

    func fetchData() {
        if UserDefaults().bool(forKey: "isOfflineMode") {
            getDataFromDB()
            return
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodeQuery(episodeId: episodeId)) { [weak self] result in

                switch result {
                case .success(let response):
                    if let epi = response.data?.episode {
                        self?.mapData(episode: epi)
                    }
                case .failure(let error):
                    print(error)
                    self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                }

            }
    }

    func mapData(episode: RickAndMortyAPI.GetEpisodeQuery.Data.Episode) {

        let epi = Episodes()
        epi.id = episode.id ?? ""
        epi.name = episode.name ?? ""
        epi.airDate = episode.air_date ?? ""
        epi.episode = episode.episode ?? ""
        var charactersArray = [Characters]()
        let charcters = episode.characters
        for char in charcters {
            let character = Characters()
            character.id = char?.id ?? ""
            character.name = char?.name ?? ""
            character.gender = char?.gender ?? ""
            character.image = char?.image ?? ""
            character.species = char?.species ?? ""
            character.status = char?.status ?? ""
            character.type = char?.type ?? ""
            charactersArray.append(character)
        }

        epi.characters.append(objectsIn: charactersArray)
        self.episode.send(epi)
    }

    func getDataFromDB() {
        if let epi = Network.shared.getEpisode(episodeId: episodeId) {
            self.episode.send(epi)
        }
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        coordinator?.goCharacterDetails(id: id, navController: navController)
    }
}
