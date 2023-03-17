//
//  CharactersFilterViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-17.
//

import UIKit
import Combine

class CharactersFilterViewController: UIViewController {

    private let statuses = ["alive", "dead", "unknown"]
    private let genders = ["male", "female", "genderless", "unknown"]

    var currentStatus = ""
    var currentGender = ""

    private let charactersFilterView = CharactersFilterView()
    private var viewModel: CharactersViewModel

    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = charactersFilterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        charactersFilterView.statusSegmentControl.addTarget(self, action: #selector(statusValueChanged), for: .valueChanged)
        charactersFilterView.genderSegmentControl.addTarget(self, action: #selector(genderValueChanged), for: .valueChanged)

        charactersFilterView.applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        charactersFilterView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

    }

    @objc private func statusValueChanged() {
        let statusIndex = charactersFilterView.statusSegmentControl.selectedSegmentIndex
        if statusIndex >= 0 { viewModel.currentStatus = self.statuses[statusIndex] }
    }

    @objc private func genderValueChanged() {
        let genderIndex = charactersFilterView.genderSegmentControl.selectedSegmentIndex
        if genderIndex >= 0 { viewModel.currentGender = self.genders[genderIndex] }
    }

    @objc private func applyButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
}
