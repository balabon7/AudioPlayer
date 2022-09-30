//
//  ExtensionUIView.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 16.06.2022.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
