//
//  CharactersFilterUISpec.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-17.
//

import XCTest
import Quick
import Nimble

final class CharactersFilterUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()
        var filterView = app.otherElements["CharactersFilterView"]

        describe("Chracters Filter") {

            app.launch()

            context("1 when user tap Filter button on Navigation Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.navigationBars.buttons["Filter"].tap()
                        sleep(1)
                    }
                }

                it("should display a filter view") {

                    filterView = app.otherElements["CharactersFilterView"]
                    await expect(filterView.identifier).toEventually(equal("CharactersFilterView"))
                }
            }

            context("2 when user tap \"Dead\" on the filter") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.segmentedControls.buttons["Dead"].tap()
                        sleep(1)
                    }
                }

                it("should show \"Adjudicator Rick\" in the first item of the collection view") {
                    let collectionView = app.collectionViews.element
                    let cell = collectionView.cells.element(boundBy: 0)
                    await expect(cell.staticTexts.element(boundBy: 0).label).toEventually(equal("Adjudicator Rick"))
                }
            }

            context("3 when user tap \"Female\" on the filter") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.segmentedControls.buttons["Female"].tap()
                        sleep(1)
                    }
                }

                it("should show \"Bearded Lady\" in the first item of the collection view") {
                    let collectionView = app.collectionViews.element
                    let cell = collectionView.cells.element(boundBy: 0)
                    await expect(cell.staticTexts.element(boundBy: 0).label).toEventually(equal("Bearded Lady"))
                }
            }

            context("4 when user tap the clear button on the filter") {

                beforeEach {
                    DispatchQueue.main.async {
                        filterView.buttons["Clear"].tap()
                        sleep(1)
                    }
                }

                it("should show \"Rick Sanchez\" in the first item of the collection view") {
                    let collectionView = app.collectionViews.element
                    let cell = collectionView.cells.element(boundBy: 0)
                    await expect(cell.staticTexts.element(boundBy: 0).label).toEventually(equal("Rick Sanchez"))
                }
            }

            context("5 when user select \"Female\" again and tap the close button on the filter") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.segmentedControls.buttons["Female"].tap()
                        filterView.buttons["DismissButton"].tap()
                        sleep(1)
                    }
                }

                it("should dismiss the filter view") {
                    await expect(app.otherElements["CharactersFilterView"].exists).toEventually(beFalse())
                }
            }

            context("6 when user tap the filter button again") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.navigationBars.buttons["Filter"].tap()
                        sleep(1)
                    }
                }

                it("should show filter view with \"Female\" selected") {
                    await expect(app.segmentedControls.buttons["Female"].isSelected).toEventually(beTrue())
                }
            }

            context("7 when user swipe the filter view down") {

                beforeEach {
                    DispatchQueue.main.async {
                        filterView.swipeDown()
                        sleep(1)
                    }
                }

                it("should dismiss the filter view again") {
                    await expect(app.otherElements["CharactersFilterView"].exists).toEventually(beFalse())
                }
            }

        }
    }
}
