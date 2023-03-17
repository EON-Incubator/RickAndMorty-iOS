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
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = UIFont(name: "Creepster-Regular", size: 24) // UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
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

    let statusSegmentControl: UISegmentedControl = {
        let items = ["Alive", "Dead", "Unknown"]
        let segmentControl = UISegmentedControl(items: items)
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

    let genderSegmentControl: UISegmentedControl = {
        let items = ["Male", "Female", "Genderless", "Unknown"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentTintColor = .systemCyan
        segmentControl.setTitleTextAttributes([.font: UIFont(name: "Chalkboard SE Regular", size: 14)!], for: .normal)
        return segmentControl
    }()

    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 24)
        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        return button
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
        backgroundColor = .clear
        insertSubview(blurView, at: 0)
        addSubview(dismissButton)
        addSubview(titleLabel)
        addSubview(lineView)
        addSubview(statusLabel)
        addSubview(statusSegmentControl)
        addSubview(genderLabel)
        addSubview(genderSegmentControl)
        addSubview(applyButton)
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
        }

        applyButton.snp.makeConstraints { make in
            make.top.equalTo(genderSegmentControl.snp_bottomMargin).offset(36)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(46)
        }
    }
}
