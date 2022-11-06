//
//  YTWrapper.swift
//  USC Films
//
//  Created by Youqi Rong on 2021/4/28.
//

import Foundation
import SwiftUI
import youtube_ios_player_helper

struct YTWrapper : UIViewRepresentable {
    var videoID : String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoID, playerVars: ["playsinline": 1])
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        print(self.videoID)
    }
}
