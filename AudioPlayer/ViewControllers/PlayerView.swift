//
//  PlayerView.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 20.06.2022.
//

import UIKit
import MediaPlayer
import SnapKit

class PlayerView: UIView {
    let playPauseButton = PlayPauseButton()
    let goBackButton = UIButton()
    let goForwardButton = UIButton()
    let slider = UISlider()
    let audioName = UILabel()
    let currentTime = UILabel()
    let audioLenght = UILabel()
    let volumeView = MPVolumeView()
    
    func setAudioName(_ name: String) {
        audioName.text = name
    }
    
    func setPlayPauseIcon(isPlaying: Bool) {
        playPauseButton.setIcon(isPlaying: isPlaying)
    }
    
    func setCurrentTime(_ time: Float, formatted: String) {
        currentTime.text = formatted
        slider.value = time
    }
    
    func setAudioLenght(_ lenght: Double, formatted: String) {
        audioLenght.text = formatted
        slider.maximumValue = Float(lenght)
    }
    
    func startSpinner() {
        audioLenght.alpha = 0.01
    }
    
    func stopSpinner() {
        audioLenght.alpha = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundColor()
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setBackgroundColor() {
        let darkMode = self.traitCollection.userInterfaceStyle == .dark
        backgroundColor = darkMode ? .black : .white
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setBackgroundColor()
    }
    
    private func setUpSubviews() {
        
        addSubviews([audioName, playPauseButton, goBackButton, goForwardButton, slider, currentTime,         audioLenght, volumeView])
        
        playPauseButton.setIcon(isPlaying: false)
        
        
        let goBackImage = UIImage(systemName: "gobackward.15")
        
        goBackButton.setImage(goBackImage, for: .normal)
        
        let goForwardImage = UIImage(systemName: "goforward.15")
        goForwardButton.setImage(goForwardImage, for: .normal)
    
        audioName.font = UIFont.systemFont(ofSize: 36)
        audioName.textAlignment = .center
        audioName.numberOfLines = 0
        audioName.text = "Undefined"
        
        currentTime.text = "0:00"
        currentTime.textAlignment = .right
        audioLenght.text = "0:00"
    }
    
    private func setUpConstraints() {
        
        // MARK: buttons
        playPauseButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
        playPauseButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(55)
        }
        
        goBackButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playPauseButton)
            make.right.equalTo(playPauseButton.snp.left).offset(-24)
        }
        
        goBackButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        
        goForwardButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playPauseButton)
            make.left.equalTo(playPauseButton.snp.right).offset(24)
        }
        
        goForwardButton.imageView?.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
        }
        
        /// Audio name
        audioName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(playPauseButton.snp.top).offset(-24)
        }
        
        /// slider
        currentTime.snp.makeConstraints { (make) in
            make.top.equalTo(playPauseButton.snp.bottom).offset(36)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        audioLenght.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTime)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentTime)
            make.left.equalTo(currentTime.snp.right).offset(16)
            make.right.equalTo(        audioLenght.snp.left).offset(-16)
        }
        
        /// volume view
        volumeView.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(slider)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

