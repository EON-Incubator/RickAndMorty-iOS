//
//  LocationsSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-09.
//

import Quick
import Nimble
import Dispatch
import Combine
import UIKit
import XCTest
import ApolloTestSupport

@testable import RickAndMorty_iOS

final class LocationsSpec: QuickSpec {

    override func spec() {
        describe("LocationsViewModel") {

            let sut = LocationsViewModel()

            beforeEach {
                sut.locations = CurrentValueSubject<[RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result], Never>([])
            }

            context("when data fetching is called with page 1") {

                it("should return 20 results") {
                    sut.fetchData(page: 1)
                    sleep(1)
                    await expect(sut.locations.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(10))
                }

            }

            context("when data fetching is called with page 99") {

                it("should return 0 results") {
                    sut.fetchData(page: 999)
                    sleep(1)
                    await expect(sut.locations.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(10))
                }

            }

        }

        describe("Test Mocks") {

            let sut = LocationsViewModel()

            beforeEach {
                sut.locations = CurrentValueSubject<[RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result], Never>([])
            }

            context("when there is only 1 mock location (\"Location 1\") from the results") {

                it("should return a result with location name (\"Location 1\")") {

                    let character1 = Mock<Character>()
                    character1.id = "1"
                    character1.name = "Character 1"
                    character1.type = "Character Type 1"
                    character1.species = "Species 1"
                    character1.gender = "Male"
                    character1.origin = Mock<Location>(name: "Origin 1")
                    character1.status = "Dead"

                    let location1 = Mock<Location>()
                    location1.id = "1"
                    location1.name = "Location 1"
                    location1.type = "Location Type 1"
                    location1.dimension = "Dimension 1"
                    location1.residents = [character1]

                    let getLocationsQuery = RickAndMortyAPI.GetLocationsQuery.Data.Locations.Result.from(location1)

                    sut.mapData(page: 1, locations: [getLocationsQuery])
                    sleep(1)
                    await expect(sut.locations.value.first?.name).toEventually(equal("Location 1"))
                }

            }

        }

    }

}
