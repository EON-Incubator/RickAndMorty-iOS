//
//  LocationsUISpec.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-10.
//
import XCTest
import Quick
import Nimble

final class LocationsUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Given app launch") {

            app.launch()

            context("when user tap the Location button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Locations"].tap()
                    }
                }

                it("should display a list of location with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("when user tap the first location cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 0).tap()
                    }
                }

                it("should show the location details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("LocationDetailsCollectionView"))
                }
            }
        }
    }
}
