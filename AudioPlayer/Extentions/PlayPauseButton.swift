//
//  PlayPauseButton.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 15.06.2022.
//

import Foundation
import UIKit

class PlayPauseButton: UIButton {
    
    func setIcon(isPlaying: Bool) {
        
        let image = UIImage(systemName: isPlaying ? "pause" : "play.fill")
        self.imageView?.contentMode = .scaleToFill
        self.setImage(image, for: .normal)
        
    }
}

