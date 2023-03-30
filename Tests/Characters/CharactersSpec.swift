//
//  CharactersSpec.swift
//  RickAndMorty-iOSTests
//
//  Created by Calvin Pak on 2023-03-09.
//

import Quick
import Nimble
import XCTest
import Combine
import ApolloTestSupport

@testable import RickAndMorty_iOS

final class CharactersSpec: QuickSpec {
    override func spec() {
        describe("CharactersViewModel") {

            let sut = CharactersViewModel()

            beforeEach {
                sut.characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
            }

            context("when data fetching is called with page 1") {

                it("should return 20 results") {
                    sut.fetchData(page: 1)
                    sleep(1)
                    await expect(sut.characters.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(3))
                }

            }

            context("when data fetching is called with page 999") {

                it("should return 0 results") {
                    sut.fetchData(page: 999)
                    sleep(1)
                    await expect(sut.characters.value.count).toEventually(equal(0), timeout: DispatchTimeInterval.seconds(3))
                }

            }

            context("when data fetching is called with page 42") {

                it("should return 6 results") {
                    sut.fetchData(page: 42)
                    sleep(1)
                    await expect(sut.characters.value.count).toEventually(equal(6), timeout: DispatchTimeInterval.seconds(3))
                }

            }

            context("when data fetching is called with negative page value") {

                it("should return 20 results like page 1") {
                    sut.fetchData(page: -1)
                    sleep(1)
                    await expect(sut.characters.value.count).toEventually(equal(20), timeout: DispatchTimeInterval.seconds(3))
                }

            }

        }

        describe("Test Mocks") {

            let sut = CharactersViewModel()

            beforeEach {
                sut.characters = CurrentValueSubject<[RickAndMortyAPI.CharacterBasics], Never>([])
            }

            context("when there is 1 mock character (\"Character 1\") from the results") {

                it("should return a result with character name (\"Character 1\")") {

                    let character1 = Mock<Character>()
                    character1.id = "1"
                    character1.name = "Character 1"
                    character1.type = "Character Type 1"
                    character1.species = "Species 1"
                    character1.gender = "Male"
                    character1.origin = Mock<Location>(name: "Origin 1")
                    character1.status = "Dead"

                    let getCharactersQuery = RickAndMortyAPI.GetCharactersQuery.Data.Characters.Result.from(character1)

                    sut.mapData(page: 1, characters: [getCharactersQuery])
                    sleep(1)
                    await expect(sut.characters.value.first?.name).toEventually(equal("Character 1"))
                }

            }

        }

    }
}
