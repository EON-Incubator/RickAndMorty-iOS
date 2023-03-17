//
//  CharactersFilterViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-17.
//

import UIKit

class CharactersFilterViewController: UIViewController {

    private let charactersFilterView = CharactersFilterView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = charactersFilterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        charactersFilterView.applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        charactersFilterView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

    }

    @objc private func applyButtonTapped() {
        print(charactersFilterView.statusSegmentControl.selectedSegmentIndex)
        print(charactersFilterView.genderSegmentControl.selectedSegmentIndex)
        self.dismiss(animated: true)
    }

    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}
