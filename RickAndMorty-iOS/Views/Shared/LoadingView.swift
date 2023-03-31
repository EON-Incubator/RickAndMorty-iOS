//
//  LoadingIndicator.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-29.
//

import UIKit

class LoadingView: BaseView {

    lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()

    override init() {
        super.init()
        self.addSubview(spinner)
    }

    func setupConstraints(view: UIView) {
        let layoutGuide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: spinner.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10)
        ])

        self.snp.makeConstraints { make in
            make.bottom.equalTo(view)
            make.right.equalTo(view).offset(-30)
            make.left.equalTo(view).offset(30)
        }
    }

}
