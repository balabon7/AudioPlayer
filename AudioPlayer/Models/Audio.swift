//
//  Audio.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 14.06.2022.
//

import Foundation

struct Audio: Hashable, Codable, Identifiable, Equatable {
    
    let id: Int
    let name: String
    let url: String
    
}
