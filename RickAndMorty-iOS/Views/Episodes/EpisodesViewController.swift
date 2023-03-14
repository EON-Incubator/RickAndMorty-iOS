//
//  EpisodesViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit
import Combine

class EpisodesViewController: UIViewController {

    let episodesView = EpisodesView()
//    let viewModel = EpisodesViewModel()
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        view = episodesView
    }

}
