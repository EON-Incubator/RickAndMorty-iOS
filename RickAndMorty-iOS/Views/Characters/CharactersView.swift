//
//  CharactersGridView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit
import SnapKit

class CharactersView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false

        let layoutGuide = self.safeAreaLayoutGuide
        self.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10)
        ])

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()

    lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
    }()

    var characterCell = UICollectionView.CellRegistration<CharacterGridCell, RickAndMortyAPI.CharacterBasics> { (cell, _ indexPath, character) in
        cell.characterNameLabel.text = character.name
        if let image = character.image {
            cell.characterImage.sd_setImage(with: URL(string: image))
        }
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)

        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaInsets).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
}

extension CharactersView {
    func filterButton(_ target: Any?, action: Selector) -> UIBarButtonItem {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        filterButton.layer.cornerRadius = 15
        filterButton.tintColor = .black
        filterButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.81, alpha: 1.00)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.white, for: .highlighted)
        filterButton.titleLabel?.font = .systemFont(ofSize: 12)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: filterButton)
    }

    func logoView() -> UIBarButtonItem {
        let imageView = UIImageView(image: UIImage(named: "RickAndMorty"))
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return UIBarButtonItem(customView: imageView)
    }
}
