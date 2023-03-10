//
//  SearchsUISpec.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-10.
//

import XCTest
import Quick
import Nimble

final class SearchsUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Given app launch") {

            app.launch()

            context("when user tap the Search button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Search"].tap()
                    }
                }

                it("should display search bar on the screen") {
                    let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                    await expect(searchTextFields.element.exists).toEventually(beTrue())
                }
            }

            context("when user search for rick from the searchbar") {

                beforeEach {
                    DispatchQueue.main.async {
                        let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.typeText("rick")
                        app.keyboards.buttons["Search"].tap()
                    }
                }

                it("should show at least 1 result in the search result list") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }

                afterEach {
                    let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                    searchTextFields.element.buttons["Clear text"].tap()
                }
            }

            context("when user search for jndfslkj from the searchbar") {

                beforeEach {
                    DispatchQueue.main.async {
                        let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.typeText("jndfslkj")
                        app.keyboards.buttons["Search"].tap()
                    }
                }

                it("should show at no result in the search result list") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(be(0))
                }

                afterEach {
                    let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                    searchTextFields.element.buttons["Clear text"].tap()
                }
            }
        }
    }
}
