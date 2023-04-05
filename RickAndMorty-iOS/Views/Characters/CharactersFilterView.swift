//
//  CharactersFilterView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-17.
//

import UIKit
import SnapKit

class CharactersFilterView: BaseView {

    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: K.Images.systemClose), for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.accessibilityIdentifier = K.Identifiers.dismissButton
        return button
    }()

    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle(K.Titles.clearButton, for: .normal)
        button.titleLabel?.font = UIFont(name: K.Fonts.secondary, size: 20)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        return button
    }()

    let statusSegmentControl: CustomSegmentedControl = {
        let items = [K.FilterLabels.alive, K.FilterLabels.dead, K.FilterLabels.unknown]
        let segmentControl = CustomSegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.font: UIFont(name: K.Fonts.secondary, size: 14) as Any], for: .normal)
        return segmentControl
    }()

    let genderSegmentControl: CustomSegmentedControl = {
        let items = [K.FilterLabels.male, K.FilterLabels.female, K.FilterLabels.genderless, K.FilterLabels.unknown]
        let segmentControl = CustomSegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.font: UIFont(name: K.Fonts.secondary, size: 14) as Any], for: .normal)
        return segmentControl
    }()

    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = K.FilterLabels.title
        label.font = UIFont(name: K.Fonts.primary, size: 24)
        return label
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = K.FilterLabels.status
        label.font = UIFont(name: K.Fonts.secondary, size: 14)
        return label
    }()

    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = K.FilterLabels.gender
        label.font = UIFont(name: K.Fonts.secondary, size: 14)
        return label
    }()

    override init() {
        super.init()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        accessibilityIdentifier = K.Identifiers.filter
        backgroundColor = .clear
        insertSubview(blurView, at: 0)
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(clearButton)
        addSubview(lineView)
        addSubview(statusLabel)
        addSubview(statusSegmentControl)
        addSubview(genderLabel)
        addSubview(genderSegmentControl)
    }

    func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }

        clearButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(24)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp_bottomMargin).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        statusSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }

        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(statusSegmentControl.snp_bottomMargin).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        genderSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }
}

class CustomSegmentedControl: UISegmentedControl {
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let previousIndex = selectedSegmentIndex
        super.touchesEnded(touches, with: event)
        if previousIndex == selectedSegmentIndex {
            guard let touchLocation = touches.first?.location(in: self) else { return }
            if bounds.contains(touchLocation) {
                sendActions(for: .valueChanged)
            }
        }
    }
}
