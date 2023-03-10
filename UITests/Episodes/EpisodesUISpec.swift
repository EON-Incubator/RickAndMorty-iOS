//
//  EpisodesUISpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-10.
//

import XCTest
import Quick
import Nimble

final class EpisodesUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Given app launch") {

            app.launch()

            context("when user tap the Episode button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Episode"].tap()
                    }
                }

                it("should display a list of episodes with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("when user tap the first episode cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 0).tap()
                    }
                }

                it("should show the episode details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("EpisodeDetailsCollectionView"))
                }
            }
        }
    }
}
