//
//  CharactersGridView.swift
//  RickAndMorty-iOSTests
//
//  Created by Gagan on 2023-03-10.
//

import Quick
import Nimble
import SDWebImage

@testable import RickAndMorty_iOS

final class CharactersGridViewSpec: QuickSpec {

    override func spec() {
        describe("CharactersGridView") {

            var view: CharactersGridView!
            var collectionView: UICollectionView!

            beforeEach {
                view = await CharactersGridView()
                collectionView = await view.collectionView
            }

            context("When the view is loaded") {
                it("Should contain CollectionView as subView") {
                    let subViews = await view.subviews
                    expect(subViews).to(contain(collectionView))
                }
            }

            context("When user tap a collectionViewCell") {
                it("Should navigate user to CharacterDetailsViewController") {
                }
            }
        }
    }
}
