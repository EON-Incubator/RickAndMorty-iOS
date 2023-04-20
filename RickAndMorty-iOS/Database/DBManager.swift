//
//  DBManager.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-19.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()

    // MARK: - LocalDB Read Operations
    func search(keyword: String) -> SearchResults {
        var characters = [Characters]()
        var locationsWithName = [Locations]()
        var locationsWithType = [Locations]()
        var episodes = [Episodes]()

        do {
            let realm = try Realm()
            let char = realm.objects(Characters.self).filter("name CONTAINS[c] %@", keyword)
            characters = Array(char)
            let locWithName = realm.objects(Locations.self).filter("name CONTAINS[c] %@", keyword)
            locationsWithName = Array(locWithName)
            let locWithType = realm.objects(Locations.self).filter("type CONTAINS[c] %@", keyword)
            locationsWithType = Array(locWithType)
            let episodeFilter = realm.objects(Episodes.self).filter("episodeDetails.name CONTAINS[c] %@ OR episodeDetails.overview CONTAINS[c] %@", keyword, keyword)
            episodes = Array(episodeFilter)

        } catch {
            print("REALM ERROR: error in initializing realm")
        }

        let searchResults = SearchResults(characters: characters, charactersTotalPages: 1, locationsWithName: locationsWithName, locationsWithNameTotalPages: 1, locationsWithType: locationsWithType, locationsWithTypeTotalPages: 1, episodes: episodes)

        return searchResults
    }

    func getCharacters(page: Int, status: String = "", gender: String = "", name: String = "") -> Results<Characters>? {
        let status = status.count > 0 ? status : "*"
        let gender = gender.count > 0 ? gender : "*"
        let name = name.count > 0 ? name : "*"

        do {
            let realm = try Realm()
            let characters = realm.objects(Characters.self).filter("status LIKE[c] %@ AND gender LIKE[c] %@ AND name LIKE[c] %@", status, gender, name)
            return page == 1 ? characters : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getCharacter(characterId: String) -> Characters? {
        do {
            let realm = try Realm()
            let character = realm.object(ofType: Characters.self, forPrimaryKey: characterId)
            return character
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getLocations(page: Int) -> Results<Locations>? {
        do {
            let realm = try Realm()
            let locations = realm.objects(Locations.self)
            return page == 1 ? locations : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getLocation(locationId: String) -> Locations? {
        do {
            let realm = try Realm()
            let location = realm.object(ofType: Locations.self, forPrimaryKey: locationId)
            return location
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisodes(page: Int) -> Results<Episodes>? {
        do {
            let realm = try Realm()
            let episodes = realm.objects(Episodes.self)
            return page == 1 ? episodes : nil
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisode(episodeId: String) -> Episodes? {
        do {
            let realm = try Realm()
            let episode = realm.object(ofType: Episodes.self, forPrimaryKey: episodeId)
            return episode
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisodesImages() -> Results<TmdbEpisodeImages>? {
        do {
            let realm = try Realm()
            let episodesImages = realm.objects(TmdbEpisodeImages.self)
            return episodesImages
        } catch {
            print("REALM ERROR: error in initializing realm")
            return nil
        }
    }

    func getEpisodeCount() -> Int {
        do {
            let realm = try Realm()
            let episodes = realm.objects(Episodes.self)
            return episodes.count
        } catch {
            print("REALM ERROR: error in initializing realm")
            return -1
        }
    }

    // MARK: - LocalDB Save Operations
    func saveCharacters(_ results: [RickAndMortyAPI.GetCharactersWithDetailsQuery.Data.Characters.Result?]) {
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

            do {

                let realm = try Realm()

                if let originId = item?.origin?.id {
                    let origin = realm.object(ofType: Locations.self, forPrimaryKey: originId)
                    character.origin = origin
                }

                if let locationId = item?.location?.id {
                    let location = realm.object(ofType: Locations.self, forPrimaryKey: locationId)
                    character.location = location
                }

                if let episodes = item?.episode {
                    for epi in episodes {
                        if let episode = realm.object(ofType: Episodes.self, forPrimaryKey: epi?.id) {
                            character.episodes.append(episode)
                        }
                    }
                }
            } catch {
                print("REALM ERROR: error in initializing realm")
            }
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

    func saveLocations(_ results: [RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result?]) {
        var locations = [Locations]()

        for item in results {
            let location = Locations()
            location.id = item?.id ?? ""
            location.name = item?.name ?? ""
            location.dimension = item?.dimension ?? ""
            location.type = item?.type ?? ""
            for locationItem in item?.residents ?? [] {
                let character = Characters(id: locationItem?.id ?? "",
                                           name: locationItem?.name ?? "",
                                           image: locationItem?.image ?? "",
                                           gender: locationItem?.gender ?? "",
                                           status: locationItem?.status ?? "",
                                           species: locationItem?.species ?? "",
                                           type: locationItem?.type ?? "")
                location.residents.append(character)
            }
            locations.append(location)
        }

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(locations, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }

    }

    func saveEpisodes(_ results: [RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result?]) {
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
                realm.add(episodes, update: .modified)
            }
        } catch {
            print("REALM ERROR: error in initializing realm")
        }
    }

    func saveEpisodeDetails(_ tmdbEpisodeDetails: TmdbEpisodeDetails, parentId: String) {
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                let episode = realm.objects(Episodes.self).first(where: { $0.id == parentId })!

                try realm.write {
                    realm.add(tmdbEpisodeDetails, update: .modified)
                    episode.episodeDetails = tmdbEpisodeDetails
                }
            } catch {
                print("REALM ERROR: error in initializing realm")
            }
        }
    }
}
