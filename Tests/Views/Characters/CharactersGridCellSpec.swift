//
//  CharacterGridCell.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-09.
//

import Quick
import Nimble
import SDWebImage

@testable import RickAndMorty_iOS

final class CharacterGridCellSpec: QuickSpec {

    override func spec() {
        describe("CharacterGridCell") {

            var view: CharactersGridCell!
            var imageView: UIImageView!
            var label: UILabel!

            beforeEach {
                view = await CharactersGridCell()
                imageView = await view.characterImage
                label = await view.characterNameLabel
            }

            context("When the view is loaded") {

                it("Should contain characterImage as subView") {
                    let subViews = await view.subviews
                    expect(subViews).to(contain(imageView))
                }

                it("Should contain characterNameLabel as subView") {
                    let subViews = await view.subviews
                    expect(subViews).to(contain(label))
                }

            }

            context("When characterImage is loaded") {
                it("Should contain an image") {
                    let image = await imageView.image
                    expect(image).notTo(beNil())
                }
            }

            afterEach {
                print("-- after each context --")
            }

        }
    }
}
