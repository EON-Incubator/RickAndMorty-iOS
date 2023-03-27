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

            context("1. when user tap the first Character cell on Characters screen") {
                let collectionView = app.collectionViews.element
                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Characters"].tap()
                        app.collectionViews.element.cells.element(boundBy: 0).tap()
                        sleep(1)
                    }
                }

                it("1.1 should show the Character details screen") {
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                }

                it("1.2 should display a list of Character Details with at least 1 cell") {
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }

                it("1.3 should display the name \"Rick Sanchez\" at the title") {
                    await expect(app.staticTexts["Rick Sanchez"].exists).toEventually(beTrue())
                }

                it("1.4 should display gender \"Male\", species \"Human\" and status \"Alive\"") {
                    await expect(app.staticTexts["Male"].exists).toEventually(beTrue())
                    await expect(app.staticTexts["Human"].exists).toEventually(beTrue())
                    await expect(app.staticTexts["Alive"].exists).toEventually(beTrue())
                }
            }

            context("2. when user scroll up on the Character Details screen") {
                let collectionView = app.collectionViews.element

                it("2.1 should continue to display the name \"Rick Sanchez\" at the title after scroll up") {
                    DispatchQueue.main.async {
                        collectionView.swipeUp(velocity: .slow)
                        sleep(1)
                    }

                    await expect(app.staticTexts["Rick Sanchez"].exists).toEventually(beTrue())
                }

                it("2.2 should display origin \"Earth (C-137)\", and last seen \"Citadel of Ricks\"") {
                    await expect(app.staticTexts["Earth (C-137)"].exists).toEventually(beTrue())
                    await expect(app.staticTexts["Citadel of Ricks"].exists).toEventually(beTrue())
                }

                it("2.3 should display Episode cell \"Pilot\"") {
                    await expect(app.staticTexts["Pilot"].exists).toEventually(beTrue())
                }
            }

            context("3. when user tap on Last Seen location") {

                let collectionView = app.collectionViews.element

                it("3.1 should display Location Details view") {
                    DispatchQueue.main.async {
                        collectionView.staticTexts["Last Seen"].tap()
                        sleep(1)
                    }
                    await expect(collectionView.identifier).toEventually(equal("LocationDetailsCollectionView"))
                }
            }
        }
    }
}
