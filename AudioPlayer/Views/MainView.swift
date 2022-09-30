//
//  MainView.swift
//  AudioPlayer
//
//  Created by Oleksandr Balabon on 14.06.2022.
//

import UIKit
import SnapKit

final class MainView: UIView {
    
    let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        
        addSubview(tableView)
    }
    
    private func setUpConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

