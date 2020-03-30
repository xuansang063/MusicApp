//
//  PlayMusicBar.swift
//  MusicApp
//
//  Created by admin on 24/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayer

class PlayMusicBar: BaseViewXib {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnControl: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    let videoPlayer = YouTubePlayerView()
    
    var type: PlaylistType = .normal
    
    var items: [Any] = []
    
    var currentIndex = 0 {
        didSet {
            if type == .trending {
                if items.count > 0, let itemVideos: [Item] = items as? [Item] {
                    let video = itemVideos[currentIndex]
                    self.currentId = video.id ?? ""
                    self.lblTitle.text = video.snippet!.title
                    self.img.loadImageFromInternet(link: video.snippet!.thumbnails!.defaults!.url ?? "")
                }
            }
        }
    }
    
    var currentId = "" {
        didSet {
            indicator.isHidden = false
            btnControl.isHidden = true
            videoPlayer.loadVideoID(currentId)
        }
    }
    
    var isPause = true {
        didSet {
            if isPause {
                btnControl.setTitle("Play", for: .normal)
                btnNext.setTitle("X", for: .normal)
                videoPlayer.pause()
            } else {
                btnControl.setTitle("Pause", for: .normal)
                btnNext.setTitle("Next", for: .normal)
                videoPlayer.play()
            }
        }
    }
    
    override func setUpViews() {
        videoPlayer.delegate = self
        contentView.setGradient(startColor: UIColor(displayP3Red: 133/255, green: 24/255, blue: 229/255, alpha: 1),
                                secondColor: UIColor(displayP3Red: 93/255, green: 153/255, blue: 238/255, alpha: 1))
    }
    
    @IBAction func onPressPlayVideo(_ sender: UIButton) {
        isPause = !isPause
    }
    
    @IBAction func onPressNextVideo(_ sender: UIButton) {
        if sender.titleLabel?.text == "Next" {
            currentIndex = currentIndex + 1
        } else {
            self.animateHideLeftToRight()
        }
    }
}

extension PlayMusicBar: YouTubePlayerDelegate
{
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        indicator.isHidden = true
        btnControl.isHidden = false
        isPause = false
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Ended {
            currentIndex = currentIndex + 1
        }
        if playerState == .Unstarted {
            print("Can't Play video")
            isPause = true
            currentIndex = currentIndex + 1
        }
    }
}
