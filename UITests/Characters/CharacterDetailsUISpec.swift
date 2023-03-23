//
//  CharacterDetails.swift
//  RickAndMorty-iOSUITests
//
//  Created by Gagan on 2023-03-13.
//

import XCTest
import Quick
import Nimble

final class CharacterDetailsUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Given app launch") {

            app.launch()

            context("when user tap the Character cell on Characters screen") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Characters"].tap()
                        app.collectionViews.element.cells.element(boundBy: 0).tap()

                    }
                }

                it("should show the Character details screen") {
                    let collectionView = app.collectionViews.element
                    sleep(1)
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                }

                it("should display a list of Character Details with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    sleep(1)
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }
        }
    }
}
