//
//  CustomCollectionViewCell.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 20.06.2022.
//

import SnapKit
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    let label: UILabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 6 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSelected = false
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func initialize() {
        
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}

