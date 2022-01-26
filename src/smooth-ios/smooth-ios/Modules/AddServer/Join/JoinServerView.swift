//
//  JoinServerView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit

class JoinServerView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "서버 참가하기"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "아래에 있는 초대 코드를 입력하여 서버에 참가하세요."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let joinLinkLabel = UILabel().then {
        $0.text = "초대 링크"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let joinLinkField = InputTextField().then {
        $0.placeholder = "https://yoloyolo.org/invite/B"
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let joinButton = UIButton().then {
        $0.setTitle("서버 참가하기", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        self.backgroundColor = .backgroundDarkGray
        
        [
            joinLinkLabel, joinButton, joinLinkField,
            titleDescriptionLabel, titleLabel
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        joinLinkLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(10)
        }
        
        joinLinkField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(joinLinkLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(joinLinkField.snp.bottom).offset(15)
            $0.right.left.equalToSuperview().inset(15)
            $0.height.equalTo(50)
        }
        
    }
}
