//
//  Playlist.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 17.06.2022.
//

import Foundation
import Combine

final class Playlist {
    
    var newAudioBatch = PassthroughSubject<[Audio], Never>()
    
    var audioList: [Audio] = [Audio]()
    @Published var currentAudio: Audio? = nil
    private var beginningPage: Int = 0
    
    func setCurrentAudio(_ audio: Audio) {
         currentAudio = audio
    }
    
    func updateAudioList() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            var newAudios = [Audio]()
            let startNumber = self.beginningPage * 10 + 1
            for audioNumber in startNumber...startNumber + 19 {
                let newAudio = Audio(id: 1000 + audioNumber, name: "AudioFile: \(audioNumber)", url: Constants.audioURL + "\(audioNumber).mp3")
                newAudios.append(newAudio)
            }
            
            self.beginningPage += 1
            self.audioList.append(contentsOf: newAudios)
            self.newAudioBatch.send(newAudios)
        }
    }
}
