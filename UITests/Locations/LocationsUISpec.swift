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

        describe("Locations") {

            app.launch()

            context("1 when user tap the Location button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Locations"].tap()
                        sleep(1)
                    }
                }

                it("should display a list of location with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("2 when user swipe up for more than 20 cells") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.swipeUp(velocity: .fast)
                        app.collectionViews.element.swipeUp(velocity: .fast)
                        app.collectionViews.element.swipeUp(velocity: .slow)
                        sleep(1)
                    }
                }

                it("should display a cell with text \"Signus 5 Expanse\" from page 2 results") {

                    await expect(app.collectionViews.staticTexts["Signus 5 Expanse"].exists).toEventually(beTrue())
                }
            }

            context("3 when user tap \"Signus 5 Expanse\" cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.staticTexts["Signus 5 Expanse"].tap()
                        sleep(1)
                    }
                }

                it("should show the location details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("LocationDetailsCollectionView"))
                    let firstCell = app.collectionViews.element.cells.element(boundBy: 0)
                    await expect(firstCell.staticTexts["Signus 5 Expanse"].exists).toEventually(beTrue())
                    let secondCell = app.collectionViews.element.cells.element(boundBy: 1)
                    await expect(secondCell.staticTexts["Cromulon Dimension"].exists).toEventually(beTrue())
                }
            }

            context("4 when user tap the first character cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 2).tap()
                        sleep(1)
                    }
                }

                it("should show the character details with title \"Armagheadon\" in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                    await expect(app.staticTexts["Armagheadon"].exists).toEventually(beTrue())
                }
            }
        }
    }
}
