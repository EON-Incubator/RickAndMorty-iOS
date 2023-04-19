//
//  EpisodesSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-10.
//

import Quick
import Nimble
import Dispatch
import Combine
import ApolloTestSupport

@testable import RickAndMorty_iOS

final class EpisodesSpec: QuickSpec {

        override func spec() {
            describe("EpisodesViewModel") {

                let sut = EpisodesViewModel()

                beforeEach {
                    sut.episodes = CurrentValueSubject<[RickAndMorty_iOS.Episodes], Never>([])
                }

                context("when data fetching is called with page 1") {

                    it("should return 20 results") {
                        sut.fetchData(page: 1)
                        sleep(1)
                        await expect(sut.episodes.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(3))
                    }

                }

                context("when data fetching is called with page 3") {

                    it("should return 11 results") {
                        sut.fetchData(page: 3)
                        sleep(1)
                        await expect(sut.episodes.value.count).toEventually(equal(11), timeout: DispatchTimeInterval.seconds(3))
                    }

                }

                context("when data fetching is called with page 99") {

                    it("should return 0 results") {
                        sut.fetchData(page: 999)
                        sleep(1)
                        await expect(sut.episodes.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(3))
                    }

                }

            }

            describe("Test Mocks") {

                let sut = EpisodesViewModel()

                beforeEach {
                    sut.episodes = CurrentValueSubject<[RickAndMorty_iOS.Episodes], Never>([])
                }

                context("when there is 1 mock episode (\"Episode 0\") from the results") {

                    it("should return a result with episode name (\"Episode 0\")") {

                        let episode0 = Mock<Episode>()
                        episode0.id = "0"
                        episode0.name = "Episode 0"
                        episode0.air_date = "1900-01-01"
                        episode0.episode = "S00E00"
                        episode0.characters = [Mock<Character>]()

                        let getEpisodesQuery = RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result.from(episode0)

                        sut.mapData(page: 1, episodes: [getEpisodesQuery])
                        sleep(1)
                        await expect(sut.episodes.value.first?.name).toEventually(equal("Episode 0"))
                    }

                }

            }

        }

}
