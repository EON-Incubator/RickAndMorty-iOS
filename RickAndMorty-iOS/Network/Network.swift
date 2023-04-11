//
//  Network.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-02-28.
//

import Foundation
import Apollo
import RealmSwift

class Network {
    static let shared = Network()
    let apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)

    func downloadAllData() {
        downloadCharacters(page: 1)
        downloadEpisodes(page: 1)
        downloadLocations(page: 1)
    }

    func downloadCharacters(page: Int) {
        print("Downloading page \(page)...")
        apollo.fetch(
            query: RickAndMortyAPI.GetCharactersQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                status: nil,
                gender: nil)) { [weak self] result in

                    switch result {
                    case .success(let response):

                        if let results = response.data?.characters?.results {
                            self?.saveCharacters(results)
                        }
                        if let pageInfo = response.data?.characters?.info {
                            if pageInfo.next != nil {
                                self?.downloadCharacters(page: page + 1)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }

                }
    }

    func saveCharacters(_ results: [RickAndMortyAPI.GetCharactersQuery.Data.Characters.Result?]) {
        print("Saving \(results.count) characters...")
        var characters = [Characters]()

        for item in results {
            let character = Characters()
            character.id = item?.id ?? ""
            character.name = item?.name ?? ""
            character.image = item?.image ?? ""
            character.gender = item?.gender ?? ""
            character.species = item?.species ?? ""
            character.status = item?.status ?? ""
            character.type = item?.type ?? ""
            characters.append(character)
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(characters, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func downloadEpisodes(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetEpisodesQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                episode: nil)) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if let results = response.data?.episodes?.results {
                            self?.saveEpisodes(results)
                        }
                        if let pageInfo = response.data?.episodes?.info {
                            if pageInfo.next != nil {
                                self?.downloadEpisodes(page: page + 1)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
    }

    func saveEpisodes(_ results: [RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result?]) {
        print("Saving \(results.count) Episodes results...")
        var episodes = [Episodes]()

        for item in results {
            let episode = Episodes()
            episode.id = item?.id ?? ""
            episode.name = item?.name ?? ""
            episode.episode = item?.episode ?? ""
            episode.airDate = item?.air_date ?? ""
            for characterItem in item?.characters ?? [] {
                let character = Characters()
                character.id = characterItem?.id ?? ""
                character.name = characterItem?.name ?? ""
                character.image = characterItem?.image ?? ""
                character.gender = characterItem?.gender ?? ""
                character.species = characterItem?.species ?? ""
                character.status = characterItem?.status ?? ""
                character.type = characterItem?.type ?? ""
                episode.characters.append(character)
            }
            episodes.append(episode)
        }

        do {
            let realm = try Realm()
            try realm.write {
                print("Saving Episodes results...")
                realm.add(episodes, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func downloadLocations(page: Int) {
        Network.shared.apollo.fetch(
            query: RickAndMortyAPI.GetLocationsQuery(
                page: GraphQLNullable<Int>(integerLiteral: page),
                name: nil,
                type: nil
            )) { [weak self] result in
                switch result {
                case .success(let response):
                    if let results = response.data?.locations?.results {
                        self?.saveLocations(results)
                    }
                    if let pageInfo = response.data?.locations?.info {
                        if pageInfo.next != nil {
                            self?.downloadLocations(page: page + 1)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }

    func saveLocations(_ results: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        print("Saving \(results.count) Locations results...")
        var locations = [Locations]()

        for item in results {
            let location = Locations()
            location.id = item?.id ?? ""
            location.name = item?.name ?? ""
            location.dimension = item?.dimension ?? ""
            location.type = item?.type ?? ""
            for locationItem in item?.residents ?? [] {
                let character = Characters()
                character.id = locationItem?.id ?? ""
                character.name = locationItem?.name ?? ""
                character.image = locationItem?.image ?? ""
                character.gender = locationItem?.gender ?? ""
                character.species = locationItem?.species ?? ""
                character.status = locationItem?.status ?? ""
                character.type = locationItem?.type ?? ""
                location.residents.append(character)
            }
            locations.append(location)
        }

        do {
            let realm = try Realm()
            try realm.write {
                print("Saving Locations results...")
                realm.add(locations, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }
}
