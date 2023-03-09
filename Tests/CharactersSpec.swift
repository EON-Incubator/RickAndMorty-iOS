//
//  CharactersSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-09.
//

import Quick
import Nimble

@testable import RickAndMorty_iOS

final class CharactersSpec: QuickSpec {
    override func spec() {
        describe("Given the demo test") {

            beforeEach {
                print("-- before each context --")
            }

            context("When the test is started") {

                it("Should pass the test") {
                    expect(true).to(beTruthy())
                }

            }

            context("When another test is started") {

                it("Should also pass the test") {
                    expect("something").notTo(beNil())
                }

            }

            afterEach {
                print("-- after each context --")
            }

        }

    }
}
