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
    var timeObserver: Any!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totaltimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bufferingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://raw.githubusercontent.com/futomtom/media/master/Call%20Me%20Maybe.mp3")!
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    @IBAction func PlayPauseAudio(_ sender: Any) {
       
        playing = !playing
        if playing {
            bufferingLabel.isHidden = false
            player?.play()
            player.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
            
            playButton.setImage(#imageLiteral(resourceName: "pause_con"), for: .normal)
            let timeInterval = CMTimeMakeWithSeconds(1, 1)
            timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: nil) {
                time in
                self.updateTimeUI()
            }
           

        } else {
            player.removeObserver(self, forKeyPath: "status")
            player.removeTimeObserver(timeObserver)
            playButton.setImage(#imageLiteral(resourceName: "play_con"), for: .normal)
            player.pause()
           
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        guard keyPath! == "status" else { return }
        
        let itemStatus = player.currentItem?.status
        switch itemStatus! {
        case .readyToPlay:
           print("readyToPlay")
             
            bufferingLabel.isHidden = true
        case .failed:
            break
        case .unknown:
            break
        }
        
        
   }




func updateTimeUI() {
    let currentItem = player?.currentItem
    let currentTime = CMTimeGetSeconds((currentItem?.currentTime())!)
    let totalDuration = CMTimeGetSeconds((currentItem?.duration)!)
    currentTimeLabel.text = formatSecondsToString(currentTime)
    totaltimeLabel.text = formatSecondsToString(totalDuration)

}

fileprivate func formatSecondsToString(_ secounds: TimeInterval) -> String {
    guard secounds.isNaN != true else { return "00:00"}
    let Min = Int(secounds / 60)
    let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
    return String(format: "%02d:%02d", Min, Sec)
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
