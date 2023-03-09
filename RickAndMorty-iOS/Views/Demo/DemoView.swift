//
//  DemoViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-09.
//

import UIKit

class DemoView: UIView {

    var textView = UITextView()
    var button = UIButton()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    private func setupViews() {
        self.backgroundColor = .systemBackground

        textView.backgroundColor = .systemGray6
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textView)

        button.backgroundColor = .systemGray
        button.setTitle("Load More", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            button.heightAnchor.constraint(equalToConstant: 30.0),
            button.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),

            textView.topAnchor.constraint(equalTo: self.button.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}
