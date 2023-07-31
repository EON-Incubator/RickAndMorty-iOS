//
//  DownloadProgressView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-11.
//

import UIKit
import SnapKit

class DownloadProgressView: BaseView {

    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: K.Images.systemClose), for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.accessibilityIdentifier = K.Identifiers.dismissButton
        return button
    }()

    private let dismissLabel: UILabel = {
        let label = UILabel()
        label.text = "Hide"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = K.Titles.download
        label.font = UIFont(name: K.Fonts.secondary, size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemCyan
        return progressView
    }()

    override init() {
        super.init()
        setupViews()
    }

    func setupViews() {
        accessibilityIdentifier = K.Identifiers.downloadProgressView
        backgroundColor = .clear
        alpha = 0
        layer.cornerRadius = 10
        clipsToBounds = true
        insertSubview(blurView, at: 0)
        addSubview(dismissButton)
        addSubview(dismissLabel)
        addSubview(titleLabel)
        addSubview(progressView)
    }

    func setupConstraints() {

        self.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }

        blurView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        dismissButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-15)
            make.height.width.equalTo(24)
        }

        dismissLabel.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp_bottomMargin).offset(5)
            make.centerX.equalTo(dismissButton.snp_centerXWithinMargins)
            make.height.equalTo(12)
            make.width.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            make.leading.trailing.equalToSuperview().inset(60)
        }
    }
}
