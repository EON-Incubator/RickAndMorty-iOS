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
    var charactersGridView = CharactersView()
    let viewModel = CharactersViewModel()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private var dataSource: DataSource!
    private var cancellables = Set<AnyCancellable>()
    var snapshot = Snapshot()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        showEmptyData()
        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    override func loadView() {
        view = charactersGridView
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        navigationItem.rightBarButtonItem = charactersGridView.filterButton(self, action: #selector(filterButtonPressed))
        navigationItem.leftBarButtonItem = charactersGridView.logoView()

        charactersGridView.collectionView.delegate = self
        charactersGridView.collectionView.refreshControl = UIRefreshControl()
        charactersGridView.collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    func showEmptyData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.appearance, .empty])
        snapshot.appendItems(Array(repeatingExpression: EmptyData(id: UUID()), count: 10), toSection: .empty)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    func subscribeToViewModel() {
        viewModel.characters.sink(receiveValue: { [weak self] characters in
            if !characters.isEmpty {
                if var snapshot = self?.snapshot {
                    snapshot.deleteAllItems()
                    snapshot.appendSections([.appearance])
                    snapshot.appendItems(characters, toSection: .appearance)
                    self?.dataSource.apply(snapshot, animatingDifferences: true)
                }
                self?.charactersGridView.loadingView.spinner.stopAnimating()
            }
            // Dismiss refresh control.
            DispatchQueue.main.async {
                self?.charactersGridView.collectionView.refreshControl?.endRefreshing()
            }
        }).store(in: &cancellables)
    }

    @objc func onRefresh() {
        viewModel.currentPage = 1
    }

    func loadMore() {
        viewModel.currentPage += 1
    }

    @objc func filterButtonPressed(sender: AnyObject?) {
        coordinator?.showCharactersFilter(sender: self, viewModel: viewModel)
    }
}

// MARK: - UICollectionViewDataSource
extension CharactersViewController {
    private func configureDataSource() {
        dataSource = DataSource(collectionView: charactersGridView.collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in

            let characterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterGridCell.identifier, for: indexPath) as? CharacterGridCell

            if indexPath.section == 1 {
                showLoadingAnimation(currentCell: characterCell!)
                return characterCell
            }

            if let char = character as? RickAndMortyAPI.CharacterBasics {
                characterCell!.characterNameLabel.text = char.name
                if let image = char.image {
                    characterCell!.characterImage.sd_setImage(with: URL(string: image), placeholderImage: nil, context: [.imageThumbnailPixelSize: CGSize(width: 200, height: 200)])
                }
            }
            return characterCell
        })
    }
}

// MARK: - UICollectionViewDelegate
extension CharactersViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            // show lazy-loading indicator
            self.charactersGridView.loadingView.spinner.startAnimating()
            loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goCharacterDetails(id: viewModel.characters.value[indexPath.row].id!, navController: self.navigationController!)
    }
}
