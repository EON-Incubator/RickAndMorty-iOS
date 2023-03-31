//
//  LoadingIndicator.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-29.
//

import UIKit

class LoadingView: UIView {

    lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(spinner)
    }

    func setupConstraints(view: UIView) {
        let layoutGuide = safeAreaLayoutGuide
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

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
