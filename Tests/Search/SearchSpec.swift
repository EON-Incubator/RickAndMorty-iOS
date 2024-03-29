//
//  SearchSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-10.
//

import Quick
import Nimble
import Dispatch

@testable import RickAndMorty_iOS

final class SearchSpec: QuickSpec {

    override func spec() {
        describe("SearchViewModel") {

            let sut = SearchViewModel()

            context("when data fetching is called with search keyword 'space'") {

                it("should return at least 1 result from characters") {
                    sut.fetchData(input: "space")
                    await expect(sut.characters.value.count).toEventually(beGreaterThanOrEqualTo(1), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return at least 1 result from locations with given name") {
                    sut.fetchData(input: "space")
                    await expect(sut.locatonsWithGivenName.value.count).toEventually(beGreaterThanOrEqualTo(1), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return at least 1 result from locations with given type") {
                    sut.fetchData(input: "space")
                    await expect(sut.locationsWithGivenType.value.count).toEventually(beGreaterThanOrEqualTo(1), timeout: DispatchTimeInterval.seconds(3))
                }

            }

            context("when data fetching is called with search keyword 'adfjdskjhs'") {

                it("should return 0 result from characters") {
                    sut.fetchData(input: "adfjdskjhs")
                    sleep(1)
                    await expect(sut.characters.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return 0 result from locations with given name") {
                    sut.fetchData(input: "adfjdskjhs")
                    sleep(1)
                    await expect(sut.locatonsWithGivenName.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(3))
                }

                it("should return 0 result from locations with given type") {
                    sut.fetchData(input: "adfjdskjhs")
                    sleep(1)
                    await expect(sut.locationsWithGivenType.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(3))
                }

            }

        }

    }

}
