//
//  YoutubeView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-14.
//

import UIKit
import YouTubeiOSPlayerHelper

class YoutubeView: BaseView {

    let playerView = YTPlayerView()

    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    override init() {
        super.init()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        backgroundColor = .clear
        insertSubview(blurView, at: 0)
        addSubview(playerView)
    }

    func setupConstraints() {
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 20, left: 15, bottom: 80, right: 15))
        }

        blurView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
