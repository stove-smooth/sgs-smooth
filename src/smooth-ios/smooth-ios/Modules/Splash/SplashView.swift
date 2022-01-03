//
//  SplashView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import SnapKit

class SplashView: BaseView {
    
    let titleLabel = UILabel()
    
    override func setup() {
        titleLabel.text = "Splash View"
        titleLabel.textColor = .white
        
        self.addSubview(titleLabel)
    }
    
    override func bindConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

