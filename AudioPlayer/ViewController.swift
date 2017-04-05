//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Alex on 4/4/17.
//  Copyright © 2017 alex. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var player: AVPlayer!
    var playing = false

    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var totaltimeLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var playbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func PlayPauseAudio(_ sender: Any) {
        let url = URL(string: "https://raw.githubusercontent.com/futomtom/media/master/Call%20Me%20Maybe.mp3")!

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playing = !playing
        if playing {
            
            player.play()
        } else {
            player.pause()
        }


    }

    @IBAction func ff30sec(_ sender: Any) {
        let currentItem = player?.currentItem
        let currentTime = CMTimeGetSeconds((currentItem?.currentTime())!)
        player?.seek(to: CMTimeMake(Int64(currentTime + 30), 1))


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
