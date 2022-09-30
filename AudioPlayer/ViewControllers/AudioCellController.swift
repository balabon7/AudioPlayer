//
//  AudioCellController.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 19.06.2022.
//

import UIKit
import Combine

class AudioCellController: UITableViewCell {
    
    private var audio: Audio?
    private var playerManager: PlayerManager?
    private var content: AudioCellView?
    
    private var loadingStatusSubscriber: AnyCancellable?
    private var playingAudioSubscriber: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setAudio(_ audio: Audio, inController controller: PlayerManager) {
        self.audio = audio
        self.playerManager = controller
        self.content = AudioCellView()
        content?.setAudioName(audio.name)
        content?.putContent(on: contentView)
        
        content?.playPauseButton.addTarget(self, action: #selector(playPauseMusic), for: .touchUpInside)
        
        addBindings()

    }
    
    private func addBindings() {
        
        loadingStatusSubscriber = playerManager?.loadingStatusChanged.sink { [weak self, audio] notLoaded in
            
            guard let currentAudio = self?.playerManager?.getCurrentAudio(), audio == currentAudio else { return }
            
            if notLoaded {
                self?.content?.startSpinner()
            } else {
                self?.content?.stopSpinner()
            }
        }
        
        playingAudioSubscriber = playerManager?.playingAudioPublisher.sink { [weak self, audio] value in
            guard let self = self else { return }
            if value.1 && value.0 == audio {
                self.content?.setPlayPauseIcon(isPlaying: true)
            } else {
                self.content?.setPlayPauseIcon(isPlaying: false)
            }
        }
        
    }
    
    @objc private func playPauseMusic(_ sender: UIButton) {
        guard let audio = audio else { return }
        playerManager?.playOrPause(audio: audio)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        content?.removeFromSuperview()
        playerManager = nil
        loadingStatusSubscriber = nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

