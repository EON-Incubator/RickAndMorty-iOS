//
//  YoutubeViewController.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-04-14.
//

import UIKit
import YouTubeiOSPlayerHelper

class YoutubeViewController: BaseViewController, YTPlayerViewDelegate {

    private let youtubeView = YoutubeView()

    private var videoId: String

    init(videoId: String) {
        self.videoId = videoId
        super.init()
    }

   override func viewDidLoad() {
       youtubeView.playerView.delegate = self
       youtubeView.playerView.load(withVideoId: videoId, playerVars: ["modestbranding": 1])
   }

   override func loadView() {
       super.loadView()
       view = youtubeView
   }

   func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
       playerView.playVideo()
   }
}
