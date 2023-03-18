//
//  SearchViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-17.
//

import UIKit

class SearchViewController: UIViewController {

    let searchView = SearchView()
    let viewModel = SearchViewModel()
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
