//
//  PlayerManager.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 17.06.2022.
//

import Foundation
import AVKit
import Combine

class PlayerManager: ObservableObject {
    
    @Published var isLoading: Bool = false
    var loadingStatusChanged: AnyPublisher<Bool, Never>  {
        return $isLoading
            .eraseToAnyPublisher()
    }
    var playingAudioPublisher: AnyPublisher<(Audio?, Bool), Never> {
        return player.$isPlaying.map { value in
            (self.getCurrentAudio(), value)
        }.eraseToAnyPublisher()
    }
    
    var timeChanged: AnyPublisher<Double, Never>  {
        return player.$currentTimeInSeconds
            .eraseToAnyPublisher()
    }
    
    let playlist: Playlist
    fileprivate let player: AudioPlayer
    private var remoteContol: RemotePlayerControl? = nil
    
    init(player: AudioPlayer, for playlist: Playlist) {
        self.player = player
        self.playlist = playlist
        remoteContol = RemotePlayerControl(forController: self)
    }
    
    // MARK: player controls
    func playOrPause(audio: Audio) {
        
        guard audio != playlist.currentAudio else {
            player.playPausePlayer()
            return
        }
        
        playlist.setCurrentAudio(audio)
        isLoading = true
        player.setCurrentAudioItem(with: audio)
        
        /// подписка на начало воспроизведения песни
        var waitingForStatusChanging: AnyCancellable?
        waitingForStatusChanging = player.timeAudioPlayerStatusChanged.sink { newStatus in
            
            guard newStatus == .playing else { return }
            
            self.remoteContol?.updateNowPlaying()
            self.isLoading = false
            waitingForStatusChanging?.cancel()
        }
        
    }
    
    func rewindTime(to seconds: Double) {
        let timeCM = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: timeCM)
        updateRemotePlayingTime(seconds: seconds)
    }
    
    func forward15Sec() {
        
        guard let audioLenght = player.currentItem?.duration.seconds else { return }
        let currentTime = player.currentTimeInSeconds
        let forwardTime = audioLenght > currentTime + 15.0 ? currentTime + 15.0 : audioLenght
        
        rewindTime(to: forwardTime)
    }
    
    func backward15Sec() {
        let currentTime = player.currentTimeInSeconds
        let backwardTime = currentTime > 15.0 ? currentTime - 15.0 : 0.0
        rewindTime(to: backwardTime)
    }
    
    func getCurrentAudio() -> Audio? {
        return playlist.currentAudio
    }
    
    func getPlayingDuration() -> Double? {
        return player.currentItem?.duration.seconds
    }
    
    func nowPlaying(_ audio: Audio) -> Bool {
        return player.isPlaying && playlist.currentAudio == audio
    }
    
    func nowLoading(_ audio: Audio) -> Bool {
        return nowPlaying(audio) && isLoading
    }
    
    func isCurrentAudio(_ audio: Audio) -> Bool {
        return playlist.currentAudio == audio
    }
    
}

// MARK: extention for remote contols
extension PlayerManager {
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    func remotePlay() -> Bool {
        
        guard !player.isPlaying, let _ = playlist.currentAudio else { return false }
        
        player.playPausePlayer()
        return true
        
    }
    
    func remotePause() -> Bool {
        
        guard player.isPlaying else { return false }
        
        player.playPausePlayer()
        return true
        
    }
    
    func updateRemotePlayingTime(seconds: Double) {
        remoteContol?.updateRemotePlayingTime(seconds)
    }
}
