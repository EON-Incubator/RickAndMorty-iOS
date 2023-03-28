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

        describe("Episodes") {

            app.launch()

            context("1 when user tap the Episode button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Episodes"].tap()
                    }
                }

                it("should display a list of episodes with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("2 when user swipe up for more than 20 cells") {

                beforeEach {
                    DispatchQueue.main.async {
                        sleep(1)
                        app.collectionViews.element.swipeUp(velocity: .fast)
                        app.collectionViews.element.swipeUp(velocity: .fast)
                        app.collectionViews.element.swipeUp(velocity: .slow)
                        sleep(1)
                    }
                }

                it("should display a cell with text \"The Rickshank Rickdemption\" from page 2 results") {

                    await expect(app.collectionViews.staticTexts["The Rickshank Rickdemption"].exists).toEventually(beTrue())
                }
            }

            context("3 when user tap \"The Rickshank Rickdemption\" cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.staticTexts["The Rickshank Rickdemption"].tap()
                        sleep(1)
                    }
                }

                it("should show the episode details in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("EpisodeDetailsCollectionView"))
                    let firstCell = app.collectionViews.element.cells.element(boundBy: 0)
                    await expect(firstCell.staticTexts["S03E01"].exists).toEventually(beTrue())
                    let secondCell = app.collectionViews.element.cells.element(boundBy: 1)
                    await expect(secondCell.staticTexts["April 1, 2017"].exists).toEventually(beTrue())
                }
            }

            context("4 when user tap the first character cell") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.collectionViews.element.cells.element(boundBy: 2).tap()
                        sleep(1)
                    }
                }

                it("should show the character details with title \"Rick Sanchez\" in next screen") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.identifier).toEventually(equal("CharacterDetailsView"))
                    await expect(app.staticTexts["Rick Sanchez"].exists).toEventually(beTrue())
                }
            }
        }
    }
}
