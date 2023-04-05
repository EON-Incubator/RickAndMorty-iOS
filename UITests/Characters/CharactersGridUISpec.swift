//
//  CharactersGridView.swift
//  RickAndMorty-iOSUITests
//
//  Created by Gagan on 2023-03-13.
//

import XCTest
import Quick
import Nimble

final class CharactersGridViewUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Characters Grid View") {

            app.launch()

            context("1. when user tap the Characters button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Characters"].tap()
                        sleep(1)
                    }
                }

                it("should display a list of Characters with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharactersCollectionView"))
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("2. when user rotate the device") {

                beforeEach {
                    DispatchQueue.main.async {
                        XCUIDevice.shared.orientation = .landscapeLeft
                        sleep(1)
                    }
                }

                it("should continue to display a list of Characters with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharactersCollectionView"))
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }

                afterEach {
                    DispatchQueue.main.async {
                        XCUIDevice.shared.orientation = .portrait
                        sleep(1)
                    }
                }
            }

            context("3. when user swipe up for more than 20 cells") {

                beforeEach {
                    DispatchQueue.main.async {
                        var tryCount = 0
                        while !(app.collectionViews.staticTexts["Aqua Rick"].exists) && tryCount <= 5 {
                            app.collectionViews.element.swipeUp(velocity: .default)
                            sleep(1)
                            tryCount += 1
                        }
                    }
                }

                it("should display a cell with text \"Aqua Rick\" from page 2 results") {

                    await expect(app.collectionViews.staticTexts["Aqua Rick"].exists).toEventually(beTrue())
                }
            }

            context("4. when user tap the a Character cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 0).tap()
                        sleep(1)
                    }
                }

                it("should show the Characters details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                }

                afterEach {
                    DispatchQueue.main.async {
                        app.navigationBars.buttons.element(boundBy: 0).tap()
                        sleep(1)
                    }
                }
            }

        }
    }
}
