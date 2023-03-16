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

    override func loadView() {
        view = charactersGridView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        navigationItem.rightBarButtonItem = charactersGridView.filterButton(self, action: #selector(filterButtonPressed))
        navigationItem.leftBarButtonItem = charactersGridView.logoView()
        charactersGridView.collectionView.delegate = self
        charactersGridView.collectionView.dataSource = self
        charactersGridView.collectionView.refreshControl = UIRefreshControl()
        charactersGridView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToViewModel()
        viewModel.currentPage = 1

    }

    @objc func filterButtonPressed() {
        print("filterButtonPressed")
    }

    func subscribeToViewModel() {
        viewModel.characters.sink(receiveValue: { characterInfo in
            for characterInfo in characterInfo {
                self.characterInfo.append(characterInfo)
            }
            self.charactersGridView.collectionView.reloadData()
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self.charactersGridView.collectionView.refreshControl?.endRefreshing()
            }
        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        characterInfo = []
        viewModel.currentPage = 1
    }

    func loadMore() {
        characterInfo = []
        viewModel.currentPage += 1
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersGridCell.identifier,
                                                            for: indexPath) as? CharactersGridCell

        if !characterInfo.isEmpty {
            let name = self.characterInfo[indexPath.item].name
            guard let image = characterInfo[indexPath.item].image else { fatalError("Image not found") }
            cell?.characterNameLabel.text = name
            cell?.characterImage.sd_setImage(with: URL(string: image))
        }
        return cell!
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            charactersGridView.loadingIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadMore()
                self.charactersGridView.loadingIndicator.stopAnimating()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goCharacterDetails(id: characterInfo[indexPath.item].id!,
                                        navController: coordinator!.characterNavController)
    }
}
