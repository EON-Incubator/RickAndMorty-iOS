//
//  EpisodeDetailsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-14.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    var characterID: String?
    var episodeDetailsView = EpisodeDetailsView()
    let viewModel = EpisodesViewModel()

    override func loadView() {
        view = episodeDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
