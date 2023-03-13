//
//  LocationsViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-13.
//

import UIKit

class LocationsViewController: UIViewController {
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = LocationsView()
    }
}
