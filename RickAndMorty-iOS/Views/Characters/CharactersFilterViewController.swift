//
//  CharactersFilterViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-17.
//

import UIKit
import Combine

class CharactersFilterViewController: BaseViewController {

    private let statuses = [K.FilterLabels.alive, K.FilterLabels.dead, K.FilterLabels.unknown]
    private let genders = [K.FilterLabels.male, K.FilterLabels.female, K.FilterLabels.genderless, K.FilterLabels.unknown]

    private let charactersFilterView = CharactersFilterView()
    private let viewModel: CharactersViewModel
    private let dismissHandler: (() -> Void)?
    private let currentFilterOptions: CurrentValueSubject<FilterOptions, Never>
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CharactersViewModel, onDismiss: (() -> Void)?) {
        self.viewModel = viewModel
        self.dismissHandler = onDismiss
        self.currentFilterOptions = CurrentValueSubject<FilterOptions, Never>(FilterOptions(
            status: viewModel.filterOptions.status,
            gender: viewModel.filterOptions.gender))
        super.init()
    }

    override func loadView() {
        super.loadView()
        view = charactersFilterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
        addTargets()
        bindToViewModel()
        restoreStatesFromViewModel()
    }

    private func addTargets() {
        charactersFilterView.statusSegmentControl.addTarget(self, action: #selector(statusValueChanged), for: .valueChanged)
        charactersFilterView.genderSegmentControl.addTarget(self, action: #selector(genderValueChanged), for: .valueChanged)
        charactersFilterView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        charactersFilterView.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }

    private func bindToViewModel() {
        currentFilterOptions
            .receive(on: DispatchQueue.main)
            .map({ $0 })
            .assign(to: \.filterOptions, on: self.viewModel)
            .store(in: &cancellables)
    }

    private func restoreStatesFromViewModel() {
        if let currentStatusIndex = statuses.firstIndex(of: viewModel.filterOptions.status) {
            charactersFilterView.statusSegmentControl.selectedSegmentIndex = currentStatusIndex
        }
        if let currentGenderIndex = genders.firstIndex(of: viewModel.filterOptions.gender) {
            charactersFilterView.genderSegmentControl.selectedSegmentIndex = currentGenderIndex
        }
    }

    @objc private func statusValueChanged() {
        let statusIndex = charactersFilterView.statusSegmentControl.selectedSegmentIndex
        if statusIndex >= 0 {
            if currentFilterOptions.value.status != self.statuses[statusIndex] {
                currentFilterOptions.value.status = self.statuses[statusIndex]
            } else {
                charactersFilterView.statusSegmentControl.selectedSegmentIndex = -1
                currentFilterOptions.value.status = ""
            }
        }
    }

    @objc private func genderValueChanged() {
        let genderIndex = charactersFilterView.genderSegmentControl.selectedSegmentIndex
        if genderIndex >= 0 {
            if currentFilterOptions.value.gender != self.genders[genderIndex] {
                currentFilterOptions.value.gender = self.genders[genderIndex]
            } else {
                charactersFilterView.genderSegmentControl.selectedSegmentIndex = -1
                currentFilterOptions.value.gender = ""
            }
        }
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func clearButtonTapped() {
        charactersFilterView.statusSegmentControl.selectedSegmentIndex = -1
        charactersFilterView.genderSegmentControl.selectedSegmentIndex = -1
        currentFilterOptions.value = FilterOptions(status: "", gender: "")
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissHandler?()
    }
}

extension CharactersFilterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        dismiss(animated: true)
        return true
    }
}
