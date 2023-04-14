//
//  DownloadProgressView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-04-11.
//

import UIKit
import SnapKit

class DownloadProgressView: BaseView {

    static let shared = DownloadProgressView()
    let currentWindow = UIApplication.shared.connectedScenes.compactMap {
                            ($0 as? UIWindowScene)?.keyWindow
                        }.last

    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: K.Images.systemClose), for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.accessibilityIdentifier = K.Identifiers.dismissButton
        return button
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
        setupConstraints()
    }

    func setupViews() {
        accessibilityIdentifier = K.Identifiers.downloadProgressView
        backgroundColor = .clear
        alpha = 0
        layer.cornerRadius = 30
        clipsToBounds = true
        insertSubview(blurView, at: 0)
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(progressView)
        currentWindow?.addSubview(self)
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
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
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
            make.height.width.equalTo(24)
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

    func show() {
        alpha = 0
        currentWindow?.addSubview(self)
        self.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        self.superview?.layoutSubviews()

        UIView.animate(withDuration: 0.5, animations: {
            self.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(90)
            }
            self.superview?.layoutSubviews()
            self.alpha = 1
        }, completion: nil)
    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.superview?.layoutSubviews()
            self.alpha = 0
        }, completion: nil)
    }
}
