//
//  CharactersFilterView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-17.
//

import UIKit
import SnapKit

class CharactersFilterView: UIView {

    let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.accessibilityIdentifier = "DismissButton"
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = UIFont(name: "Creepster-Regular", size: 24)
        return label
    }()

    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 20)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        return button
    }()

    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "STATUS"
        label.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        return label
    }()

    let statusSegmentControl: CustomSegmentedControl = {
        let items = ["Alive", "Dead", "Unknown"]
        let segmentControl = CustomSegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.font: UIFont(name: "Chalkboard SE Regular", size: 14)!], for: .normal)
        return segmentControl
    }()

    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "GENDER"
        label.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        return label
    }()

    let genderSegmentControl: CustomSegmentedControl = {
        let items = ["Male", "Female", "Genderless", "Unknown"]
        let segmentControl = CustomSegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.font: UIFont(name: "Chalkboard SE Regular", size: 14)!], for: .normal)
        return segmentControl
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        accessibilityIdentifier = "CharactersFilterView"
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
            let touchLocation = touches.first!.location(in: self)
            if bounds.contains(touchLocation) {
                sendActions(for: .valueChanged)
            }
        }
    }
}
