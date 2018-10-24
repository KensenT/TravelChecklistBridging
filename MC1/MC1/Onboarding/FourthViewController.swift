//
//  FourthViewController.swift
//  Onboarding
//
//  Created by Resky Javieri on 24/10/18.
//  Copyright © 2018 Resky Javieri. All rights reserved.
//

import UIKit
import AVFoundation

class FourthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "Onboarding2", ofType: "mp4")
        playVideo(url: URL(fileURLWithPath: path!))
    }
    
    func playVideo(url: URL) {
        
        let player = AVPlayer(url: url)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 75, y: 260, width: 240, height: 448)
        layer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(layer)
        player.actionAtItemEnd = .none
        
        
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            player.seek(to: kCMTimeZero)
            player.play()
        }
        
    }
}
