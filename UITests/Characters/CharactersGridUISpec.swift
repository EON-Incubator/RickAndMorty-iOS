//
//  CharactersGridView.swift
//  RickAndMorty-iOSUITests
//
//  Created by Gagan on 2023-03-13.
//

import XCTest
import Quick
import Nimble

final class CharactersGridView: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Given app launch") {

            app.launch()

            context("when user tap the Characters button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Characters"].tap()
                    }
                }

                it("should display a list of Characters with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("when user tap the first Character cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 0).tap()
                    }
                }

                it("should show the Characters details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                }
            }
        }
    }
}
