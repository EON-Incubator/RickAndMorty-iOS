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

        describe("Given app launch") {
            app.launch()
            context("1when user tap the Search button on Tab Bar") {

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

            context("2when user search for rick from the searchbar") {

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

            context("when user search for jndfslkj from the searchbar") {

                beforeEach {
                    DispatchQueue.main.async {
                        let searchTextFields = app.searchFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.tap()
                        searchTextFields.element.typeText("jndfslkj")
                        app.keyboards.buttons["Search"].tap()
                    }
                }

                it("should show at no result in the search result list") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(equal(0))
                }

                afterEach {
                    DispatchQueue.main.async {
                        let searchTextFields = app.textFields.matching(identifier: "SearchTextField")
                        searchTextFields.element.buttons["Clear text"].tap()
                    }
                }
            }
        }
    }
}
