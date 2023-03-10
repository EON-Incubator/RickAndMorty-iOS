//
//  CharactersViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit

class CharactersViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var charactersGridView = CharactersGridView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = charactersGridView
        charactersGridView.collectionView.delegate = self
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
