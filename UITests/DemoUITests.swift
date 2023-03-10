//
//  RickAndMorty_iOSUITests.swift
//  RickAndMorty-iOSUITests
//
//  Created by Calvin Pak on 2023-03-10.
//

import XCTest
import Nimble

final class DemoUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {

    }

    func testWhenAppLanchedShouldDisplayCollectionWithAtLeastOneCell() throws {
        app.launch()
        let collectionView = app.collectionViews.element
        expect(collectionView.cells.count).to(beGreaterThanOrEqualTo(1))
    }

    func testWhenDemoTabIsTappedShouldShowRick() throws {
        app.tabBars.buttons["Demo"].tap()
        let textView = app.textViews.element
        sleep(1)
        expect(textView.value as? String).to(contain("Rick"))
    }

}
