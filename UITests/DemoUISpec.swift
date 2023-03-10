//
//  DemoUISpec.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-10.
//  This is an demonstration of UITest using Quick + Nimble.
//
import XCTest
import Quick
import Nimble

final class DemoUISpec: QuickSpec {

    override func spec() {

        let app = XCUIApplication()

        describe("Demo") {

            app.launch()

            context("when in the first screen") {

                it("should display collection view with at least 1 cell") {
                    let collectionView = app.collectionViews.element
                    await expect(collectionView.cells.count).toEventually(beGreaterThanOrEqualTo(1))
                }
            }

            context("when user tap the Demo button on Tab Bar") {

                beforeEach {
                    DispatchQueue.main.async {
                        app.tabBars.buttons["Demo"].tap()
                    }
                }

                it("should display the MainTextView") {
                    let textView = app.textViews.element
                    await expect(textView.identifier).toEventually(equal("MainTextView"))
                }

                it("should display Rick in the textview") {
                    let textView = app.textViews.element
                    await expect(textView.value as? String).toEventually(contain("Rick"))
                }

            }
        }
    }
}
