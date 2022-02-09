//
//  FriendRequestView.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit
import Then

class FriendRequestView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "친구 추가하기"
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Discord에 친구 추가하기"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "사용자명과 태그가 모두 필요해요. 사용자명은 대소문자를 구별해야 해요."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let userLabel = UILabel().then {
        $0.text = "사용자명으로 추가"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let userField = InputTextField().then {
        $0.placeholder = "사용자명#0000"
        $0.keyboardType = .emailAddress
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let myUserLabel = UILabel().then {
        $0.text = "내 사용자명: "
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let userNameLabel = UILabel().then {
        $0.text = "두리#1234"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = .white
    }
    
    let requestButton = UIButton().then {
        $0.setTitle("친구 요청 보내기", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [
            navigationView, closeButton, naviTitleLabel,
            titleLabel, titleDescriptionLabel,
            userLabel, userField,
            myUserLabel, userNameLabel,
            requestButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalTo(naviTitleLabel)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView).offset(-10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        userLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(20)
        }
        
        userField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(userLabel.snp.leading)
            $0.top.equalTo(userLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        myUserLabel.snp.makeConstraints {
            $0.left.equalTo(userField)
            $0.top.equalTo(userField.snp.bottom).offset(10)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(myUserLabel)
            $0.leading.equalTo(myUserLabel.snp.trailing)
        }
        
        requestButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.top.equalTo(myUserLabel).offset(30)
            $0.height.equalTo(50)
        }
    }
}
