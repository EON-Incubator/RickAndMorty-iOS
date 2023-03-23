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

@testable import RickAndMorty_iOS

final class EpisodesSpec: QuickSpec {

        override func spec() {
            describe("EpisodesViewModel") {

                let sut = EpisodesViewModel()

                beforeEach {
                    sut.episodes = CurrentValueSubject<[RickAndMortyAPI.GetEpisodesQuery.Data.Episodes.Result], Never>([])
                }

                context("when data fetching is called with page 1") {

                    it("should return 20 results") {
                        sut.fetchData(page: 1)
                        sleep(1)
                        await expect(sut.episodes.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(3))
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

        }

}
