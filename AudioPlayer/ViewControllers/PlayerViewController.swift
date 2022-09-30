//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 19.06.2022.
//

import UIKit
import Combine

class PlayerViewController: UIViewController {
    
    let playerManager: PlayerManager
    private var audio: Audio
    private var contentView: PlayerView { return view as! PlayerView }
    
    private var audioLenght: Double?
    private var loadingStatusSubscriber: AnyCancellable?
    private var playingAudioSubscriber: AnyCancellable?
    private var currentTimeSubscriber: AnyCancellable?
    
    init(audio: Audio, for playerCotroller: PlayerManager) {
        self.playerManager = playerCotroller
        self.audio = audio
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = PlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.setAudioName(audio.name)
        
        contentView.playPauseButton.addTarget(self, action: #selector(playPauseAudio), for: .touchUpInside)
        contentView.goBackButton.addTarget(self, action: #selector(backwardTo15Sec), for: .touchUpInside)
        contentView.goForwardButton.addTarget(self, action: #selector(forwardTo15Sec), for: .touchUpInside)
        contentView.slider.addTarget(self, action: #selector(rewindTime(_:)), for: .valueChanged)
        
        addBindings()
        
    }
    
    private func addBindings() {
        
        loadingStatusSubscriber = playerManager.loadingStatusChanged.sink { [weak self, audio] notLoaded in
       
            guard let self = self, self.playerManager.isCurrentAudio(audio) else { return }
            
            if let lenght = self.playerManager.getPlayingDuration() {
                let formattedLenght = self.toMinSeconds(lenght)
                self.contentView.setAudioLenght(lenght, formatted: formattedLenght)
            }
            
            if notLoaded {
                self.contentView.startSpinner()
            } else {
                self.contentView.stopSpinner()
            }
        }
        
        playingAudioSubscriber = playerManager.playingAudioPublisher.sink { [weak self, audio] value in
            guard let self = self else { return }
            if value.1 && value.0 == audio {
                self.contentView.setPlayPauseIcon(isPlaying: true)
            } else {
                self.contentView.setPlayPauseIcon(isPlaying: false)
            }
        }
        
        currentTimeSubscriber = playerManager.timeChanged.sink { [weak self, audio] value in
            
            guard let self = self, self.playerManager.isCurrentAudio(audio) else { return }
            
            let formattedTime = self.toMinSeconds(value)
            self.contentView.setCurrentTime(Float(value), formatted: formattedTime)
        }
        
    }
    
    @objc private func playPauseAudio() {
        playerManager.playOrPause(audio: audio)
        guard audioLenght == nil else { return }
        contentView.startSpinner()
    }
    
    @objc private func backwardTo15Sec() {
        guard playerManager.isCurrentAudio(audio) else { return }
        playerManager.backward15Sec()
    }
    
    @objc private func forwardTo15Sec() {
        guard playerManager.isCurrentAudio(audio) else { return }
        playerManager.forward15Sec()
    }
    
    @objc private func rewindTime(_ sender: UISlider) {
        guard playerManager.isCurrentAudio(audio) else { return }
        playerManager.rewindTime(to: Double(sender.value))
    }
    
    private func toMinSeconds(_ seconds : Double) -> String {
        let (_,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        let seconds = Int(60 * secf)
        return "\(Int(min)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

