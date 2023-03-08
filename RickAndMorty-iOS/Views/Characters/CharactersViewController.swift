//
//  CharactersViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit

class CharactersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func loadView() {
        view = CharactersGridView()
    }

}
