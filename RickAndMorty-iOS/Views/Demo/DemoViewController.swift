//
//  DemoViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-09.
//

import UIKit
import Combine

class DemoViewController: UIViewController {

    let demoView = DemoView()
    let viewModel = DemoViewModel()
    weak var coordinator: MainCoordinator?
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = demoView
        demoView.button.addTarget(self, action: #selector(loadMore), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeToViewModel()
        viewModel.currentPage = 1
    }

    func subscribeToViewModel() {
        viewModel.characters.sink(receiveValue: { characterBasics in
            for characterBasic in characterBasics {
                self.demoView.textView.text += "\(characterBasic.name!)\n"
            }
        }).store(in: &cancellables)

        viewModel.character.sink(receiveValue: { character in
            self.demoView.textView.text += "\(character.name!)\n"
        }).store(in: &cancellables)
    }

    @objc func loadMore() {
        viewModel.currentPage += 1
    }

}
