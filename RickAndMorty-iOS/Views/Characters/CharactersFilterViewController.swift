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

    private let charactersFilterView = CharactersFilterView()
    private var viewModel: CharactersViewModel

    private var currentFilterOptions: CurrentValueSubject<FilterOptions, Never>

    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        self.currentFilterOptions = CurrentValueSubject<FilterOptions, Never>(FilterOptions(status: viewModel.filterOptions.status, gender: viewModel.filterOptions.gender))
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
        charactersFilterView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        charactersFilterView.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)

        if let currentStatusIndex = statuses.firstIndex(of: viewModel.filterOptions.status) {
            charactersFilterView.statusSegmentControl.selectedSegmentIndex = currentStatusIndex
        }

        if let currentGenderIndex = genders.firstIndex(of: viewModel.filterOptions.gender) {
            charactersFilterView.genderSegmentControl.selectedSegmentIndex = currentGenderIndex
        }

        currentFilterOptions
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .assign(to: \.filterOptions, on: self.viewModel)
            .store(in: &cancellables)
    }

    @objc private func statusValueChanged() {
        let statusIndex = charactersFilterView.statusSegmentControl.selectedSegmentIndex
        if statusIndex >= 0 {
            currentFilterOptions.value.status = self.statuses[statusIndex]
        }
    }

    @objc private func genderValueChanged() {
        let genderIndex = charactersFilterView.genderSegmentControl.selectedSegmentIndex
        if genderIndex >= 0 {
            currentFilterOptions.value.gender = self.genders[genderIndex]
        }
    }

    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func clearButtonTapped() {
        charactersFilterView.statusSegmentControl.selectedSegmentIndex = -1
        charactersFilterView.genderSegmentControl.selectedSegmentIndex = -1
        currentFilterOptions.value = FilterOptions(status: "", gender: "")
    }
}
