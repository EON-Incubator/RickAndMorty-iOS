//
//  YoutubePlayerView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-13.
//

import UIKit
import SnapKit
import YoutubePlayer_in_WKWebView

class YoutubePlayerView: BaseView {

    override init() {
        super.init()
        setupViews()
    }

    func setupViews() {
        addSubview(wkytPlayerView)
    }

    lazy var wkytPlayerView: WKYTPlayerView = {
        let playerView = WKYTPlayerView()
        return playerView
    }()

    func setupConstraints(controller: UIAlertController) {
        self.snp.makeConstraints { make in
            make.edges.equalTo(controller.view).inset(UIEdgeInsets(top: 15, left: 15, bottom: 80, right: 15))
        }

        controller.view.snp.makeConstraints { make in
            make.height.equalTo(300)
        }

        wkytPlayerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
