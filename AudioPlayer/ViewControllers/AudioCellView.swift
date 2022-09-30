//
//  AudioCellView.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 20.06.2022.
//

import UIKit
import SnapKit

class AudioCellView: UIView {
    
    let playPauseButton = PlayPauseButton()
    private let audioName = UILabel()
    private let spinner = UIActivityIndicatorView()
    
    /// controls
    func putContent(on parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func setAudioName(_ name: String) {
        audioName.text = name
    }
    
    func setPlayPauseIcon(isPlaying: Bool) {
        playPauseButton.setIcon(isPlaying: isPlaying)
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    // MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        
        addSubviews([playPauseButton, audioName, spinner])
        
        playPauseButton.setIcon(isPlaying: false)
        
        spinner.hidesWhenStopped = true
        spinner.style = .medium
        
    }
    
    private func setUpConstraints() {
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        
        playPauseButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(32)
        }
        
        playPauseButton.imageView?.snp.makeConstraints { (make) in
            make.height.width.equalTo(32)
        }
        
        audioName.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(playPauseButton.snp.right).offset(16)
            make.right.equalTo(spinner.snp.left).offset(16)
        }
        
        spinner.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

