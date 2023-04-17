//
//  EpisodesViewModel.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class EpisodesViewModel {

    var episodes = CurrentValueSubject<[Episodes], Never>([])

    var currentPage = 0 {
        didSet {
            fetchData(page: currentPage)
        }
    }
    weak var coordinator: MainCoordinator?

    func fetchData(page: Int) {
        if Network.shared.isOfflineMode() {
            getDataFromDB(page: page)
            return
        }
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodesQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                episode: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.episodes?.results {
                            self?.mapData(page: page, episodes: results)
                        }
                    case .failure(let error):
                        print(error)
                        Network.shared.setOfflineMode(true)
                        self?.coordinator?.presentNetworkTimoutAlert(error.localizedDescription)
                    }
                }
    }

    func getDataFromDB(page: Int) {
        if let results = Network.shared.getEpisodes(page: page) {
            self.mapDataFromDB(page: page, episodes: results)
        } else {
            self.episodes.value = [Episodes]()
        }
    }

    func mapDataFromDB(page: Int, episodes: Results<Episodes>) {
        if page == 1 {
            self.episodes.value = (episodes.compactMap { $0 })
        } else {
            self.episodes.value.append(contentsOf: (episodes.compactMap { $0 }) )
        }
    }

    func mapData(page: Int, episodes: [RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result?]) {

        var episodesArray = [Episodes]()

        for item in episodes {
            let episode = Episodes()
            episode.id = item?.id ?? ""
            episode.name = item?.name ?? ""
            episode.airDate = item?.air_date ?? ""
            episode.episode = item?.episode ?? ""
            var charactersArray = [Characters]()
            if let charcters = item?.characters {
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
            }
            episode.characters.append(objectsIn: charactersArray)
            episodesArray.append(episode)
        }

        if page == 1 {
            self.episodes.value = (episodesArray.compactMap { $0 })
        } else {
            self.episodes.value.append(contentsOf: (episodesArray.compactMap { $0 }) )
        }

    }

    func refresh() {
        currentPage = 1
    }

    func loadMore() {
        currentPage += 1
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        coordinator?.goEpisodeDetails(id: id, navController: navController)
    }

}
