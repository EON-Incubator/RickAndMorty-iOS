//
//  CharactersViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit
import Combine
import SDWebImage

class CharactersViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var charactersGridView = CharactersGridView()
    let viewModel = CharactersViewModel()
    var characterInfo: [RickAndMortyAPI.CharacterBasics] = []
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = charactersGridView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        subscribeToViewModel()
        charactersGridView.collectionView.delegate = self
        charactersGridView.collectionView.dataSource = self
        viewModel.currentPage = 1
    }

    func subscribeToViewModel() {
        viewModel.characters.sink(receiveValue: { characterInfo in
            for characterInfo in characterInfo {
                self.characterInfo.append(characterInfo)
            }
            self.charactersGridView.collectionView.reloadData()
        }).store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersGridCell.identifier,
                                                            for: indexPath) as? CharactersGridCell else { fatalError("Wrong cell class dequeued") }
        let name = characterInfo[indexPath.item].name
        guard let image = characterInfo[indexPath.item].image else { fatalError("Image not found") }
        cell.characterNameLabel.text = name
        cell.characterImage.sd_setImage(with: URL(string: image))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goCharacterDetails(id: characterInfo[indexPath.item].id!,
                                        navController: coordinator!.characterNavController)
    }
}
