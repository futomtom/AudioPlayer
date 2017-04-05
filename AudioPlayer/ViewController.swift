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
    fileprivate var player: AVPlayer!
    fileprivate var playing = false
    fileprivate var timeObserver: Any!
    fileprivate var playerItem: AVPlayerItem!

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totaltimeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bufferingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://raw.githubusercontent.com/futomtom/media/master/Call%20Me%20Maybe.mp3")!
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    @IBAction func PlayPauseAudio(_ sender: Any) {

        playing = !playing
        if playing {
            bufferingLabel.isHidden = false
            player?.play()
            playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
            playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new], context: nil)

            playButton.setImage(#imageLiteral(resourceName: "pause_con"), for: .normal)
            let timeInterval = CMTimeMakeWithSeconds(1, 1)
            timeObserver = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: nil) {
                time in
                self.updateTimeUI()
            }


        } else {
            playerItem.removeObserver(self, forKeyPath: "status")
            playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
            player.removeTimeObserver(timeObserver)
            playButton.setImage(#imageLiteral(resourceName: "play_con"), for: .normal)
            player.pause()

        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        switch keyPath! {
        case "status":
            updatePlayItemStatus()
        case "loadedTimeRanges":
            updateLoadingProgress()
        default:
            break
        }
    }

    func updateLoadingProgress () {
        if let timeInterVarl = self.availableDuration() {
            let duration = playerItem?.duration
            let totalDuration = CMTimeGetSeconds(duration!)
            loadedTimeDidChange(loadedDuration: timeInterVarl, totalDuration: totalDuration)
            
        }
    }
    
    open func loadedTimeDidChange(loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        let ratio = Float(loadedDuration) / Float(totalDuration)
        progressView.setProgress(ratio, animated: true)
        if ratio == 1.0 {
            bufferingLabel.isHidden = true
        }
        
    }
    
    fileprivate func availableDuration() -> TimeInterval? {
        if let loadedTimeRanges = player?.currentItem?.loadedTimeRanges,
            let first = loadedTimeRanges.first {
            let timeRange = first.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSecound = CMTimeGetSeconds(timeRange.duration)
            let result = startSeconds + durationSecound
            return result
        }
        return nil
    }


    func updatePlayItemStatus () {
        let itemStatus = player.currentItem?.status
        switch itemStatus! {
        case .readyToPlay:
            print("readyToPlay")

        //    bufferingLabel.isHidden = true
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
        guard secounds.isNaN != true else { return "00:00" }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }

    @IBAction func ff30sec(_ sender: Any) {
        let currentItem = player?.currentItem
        let currentTime = CMTimeGetSeconds((currentItem?.currentTime())!)
        player?.seek(to: CMTimeMake(Int64(currentTime + 30), 1))


    }





}
