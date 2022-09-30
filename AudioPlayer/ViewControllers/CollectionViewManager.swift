//
//  CollectionViewManager.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 19.06.2022.
//

import Foundation
import UIKit

protocol CollectionViewManagerDelegate: AnyObject {
    func handleViewModeChange()
}

final class CollectionViewManager {
    
    // MARK: - Public Properties
    public var viewMode: ViewMode = .usual {
        didSet {
            delegate?.handleViewModeChange()
        }
    }
    
    weak var delegate: CollectionViewManagerDelegate?
}
