//
//  YoutubePlayerView.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-13.
//

import UIKit
import SnapKit
import YoutubePlayer_in_WKWebView

class YoutubePlayerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(wkytPlayerView)
        closeButton.addTarget(self, action: #selector(buttonPressed), for: .allTouchEvents)

        backgroundColor = .clear
//        insertSubview(blurView, at: 0)
    }

    lazy var wkytPlayerView: WKYTPlayerView = {
        let playerView = WKYTPlayerView()

        return playerView
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.zPosition = 100
        return button
    }()

    @objc func buttonPressed(sender: UIButton!) {
        self.removeFromSuperview()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != wkytPlayerView {
            self.removeFromSuperview()
        }
    }

    private let blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    func setupConstraints() {
        wkytPlayerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
//            make.centerY.equalToSuperview()
            make.height.equalTo(200)
        }
//        blurView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//        }
//        closeButton.snp.makeConstraints { make in
//            make.right.top.equalToSuperview().inset(-15)
//            make.height.equalTo(50)
//            make.width.equalTo(50)
//        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
