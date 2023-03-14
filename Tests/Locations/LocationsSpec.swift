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
                    await expect(sut.locations.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(10))
                }

            }

            context("when data fetching is called with page 99") {

                it("should return 0 results") {
                    sut.fetchData(page: 999)
                    await expect(sut.locations.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(10))
                }

            }

        }

    }

}
