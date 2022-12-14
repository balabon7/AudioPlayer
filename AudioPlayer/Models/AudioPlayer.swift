//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 14.06.2022.
//

import Foundation
import AVKit
import Combine

class AudioPlayer: AVPlayer, ObservableObject {
    
    /// Publishers
    @Published var currentTimeInSeconds: Double = 0.0
    @Published var isPlaying: Bool = false
    
    let timeAudioPlayerStatusChanged = PassthroughSubject<AVPlayer.TimeControlStatus, Never>()
    let audioDidEnd = ObservableObjectPublisher()
    
    private var timeObserverToken: Any?
    
    override init() {
        super.init()
        registerObserves()
    }
    
    /// observers
    private func registerObserves() {
        
        self.addObserver(self, forKeyPath: "currentItem", options: [.new], context: nil)
        self.addObserver(self, forKeyPath: #keyPath(timeControlStatus), options: [.old, .new], context: nil)
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = self.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] _ in
            self?.currentTimeInSeconds = self?.currentTime().seconds ?? 0.0
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem", let item = currentItem {
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        } else if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            
            let status: AVPlayer.TimeControlStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayer.TimeControlStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .waitingToPlayAtSpecifiedRate
            }
            
            timeAudioPlayerStatusChanged.send(status)
            
        }
            
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        isPlaying = false
        audioDidEnd.send()
    }
    
    /// player controls
    func playPausePlayer() {
        
        if isPlaying {
            self.pause()
        } else {
            self.play()
        }
        
        isPlaying.toggle()
        
    }
    
    func setCurrentAudioItem(with audio: Audio) {
        
        guard let url = URL(string: audio.url) else { return }
        let playerItem = AVPlayerItem(url: url)
        self.replaceCurrentItem(with: playerItem)
        self.isPlaying = true
        self.play()
        
    }
    
    /// deinit
    deinit {
        
        self.removeObserver(self, forKeyPath: "currentItem")
        
        if let token = timeObserverToken {
            self.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
