//
//  DemoSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-09.
//

import Quick
import Nimble
import Dispatch

@testable import RickAndMorty_iOS
import UIKit
import XCTest

final class DemoSpec: QuickSpec {

    // let subject = DemoViewController().demoView.textView
    override func spec() {
        describe("DemoViewModel") {

            let sut = DemoViewModel()

            context("when data fetching is called with page 1") {

                it("should return 20 results") {
                    sut.fetchData(page: 1)
                    await expect(sut.characters.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(10))
                }

            }

            context("when data fetching is called with page 99") {

                it("should return 0 results") {
                    sut.fetchData(page: 99)
                    await expect(sut.characters.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(10))
                }

            }

        }

    }

}
