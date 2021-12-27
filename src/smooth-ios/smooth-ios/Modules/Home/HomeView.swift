//
//  HomeView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class HomeView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "Home View"
    }
    
    let logOutButton = UIButton().then {
        $0.setTitle("logOut", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
    }
    
    override func setup() {
        self.backgroundColor = .white
        
        [titleLabel, logOutButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.logOutButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.trailing.equalTo(titleLabel)
            $0.height.equalTo(50)
        }
    }
}

