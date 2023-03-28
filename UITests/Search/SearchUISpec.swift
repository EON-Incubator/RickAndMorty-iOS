//
//  SearchUISpec.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-10.
//

import XCTest
import Quick
import Nimble

final class SearchUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Search") {
            app.launch()
            context("1. when user tap the Search button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Search"].tap()
                    }
                }

                it("should display search bar on the screen") {
                    let searchTextFields = app.searchFields.matching(identifier: "SearchTextField")
                    await expect(searchTextFields.element.exists).toEventually(beTrue())
                }
            }

            context("2. when user search for rick from the searchbar") {

                beforeEach {
                    DispatchQueue.main.async {
                        let searchTextFields = app.searchFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.tap()
                        searchTextFields.element.typeText("rick")
                        app.keyboards.buttons["Search"].tap()
                    }
                }

                it("should show at least 1 result in the search result list") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }

                afterEach {
                    DispatchQueue.main.async {
                        let searchTextFields =  app.searchFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.buttons["Clear text"].tap()
                    }
                }
            }

            context("3. when user search for jndfslkj from the searchbar") {
                let collectionView = app.collectionViews.element
                let searchTextFields = app.searchFields.matching(identifier: "SearchTextField")

                beforeEach {
                    DispatchQueue.main.async {
                        searchTextFields.element.buttons["Clear text"].tap()
                        searchTextFields.element.tap()
                        searchTextFields.element.typeText("jndfslkj")
                        app.keyboards.buttons["Search"].tap()
                        sleep(1)
                    }
                }

                it("should show at no result in the search result list") {
                    await expect(collectionView.cells.count).toEventually(equal(0))
                }

                it("should show \"No results found for 'jndfslkj'\" on the screen") {
                    await expect(app.staticTexts["No results found for 'jndfslkj'"].exists).toEventually(beTrue())
                }

                afterEach {
                    DispatchQueue.main.async {
                        searchTextFields.element.buttons["Clear text"].tap()
                    }
                }
            }

            context("4. when user type 'Rick' in the search bar and select 'Locations' in the search scope") {
                let searchTextFields = app.searchFields.matching(identifier: "SearchTextField")
                let collectionView = app.collectionViews.element
                beforeEach {
                    DispatchQueue.main.async {
                        searchTextFields.element.buttons["Clear text"].tap()
                        searchTextFields.element.tap()
                        searchTextFields.element.typeText("Rick")
                        app.keyboards.buttons["Search"].tap()
                        sleep(1)
                        app.segmentedControls.buttons["Locations"].tap()
                        sleep(1)
                    }
                }

                it("should show a list of locations with at least 1 result") {
                    await expect(collectionView.staticTexts["LOCATIONS"].exists).toEventually(beTrue())
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("5. when user select 'Characters' in the search scope") {
                let collectionView = app.collectionViews.element
                beforeEach {
                    DispatchQueue.main.async {
                        app.segmentedControls.buttons["Characters"].tap()
                        sleep(1)
                    }
                }

                it("should show a list of characters with at least 1 result") {
                    await expect(collectionView.staticTexts["CHARACTERS"].exists).toEventually(beTrue())
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("6. when user select 'All' in the search scope and swipe up until \"Load More\" cell can be seen") {
                let collectionView = app.collectionViews.element
                beforeEach {
                    DispatchQueue.main.async {
                        app.segmentedControls.buttons["All"].tap()
                        sleep(1)

                        guard let lastCell = collectionView.cells.allElementsBoundByIndex.last else { return }

                        while !(collectionView.cells.staticTexts["Load More"].exists) || !(lastCell.isHittable) {
                            collectionView.swipeUp(velocity: .slow)
                        }
                    }
                }

                it("should show 'Load More' button and the header of 'LOCATIONS' at the middle of the lists") {
                    await expect(collectionView.cells.staticTexts["Load More"].exists).toEventually(beTrue())
                    await expect(collectionView.staticTexts["LOCATIONS"].exists).toEventually(beTrue())
                }
            }

            context("7. when tap on \"Load More\" cell") {
                let collectionView = app.collectionViews.element
                beforeEach {
                    DispatchQueue.main.async {
                        collectionView.cells.staticTexts["Load More"].tap()
                        sleep(1)
                    }
                }

                it("should expand the Characters list and push LOCATION header out of current screen") {
                    await expect(collectionView.staticTexts["LOCATIONS"].exists).toEventually(beFalse())
                }
            }
        }
    }
}
