//
//  SignUpInfoView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import Then

class SignUpInfoView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "가입하기"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .white
    }
    
    let nickNameLabel = UILabel().then {
        $0.text = "사용자명 정하기"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let nickNameField = InputTextField().then {
        $0.placeholder = "닉네임"
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDartGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let passwordField = InputTextField().then {
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDartGray
        
        $0.returnKeyType = .done
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDartGray
        
        [
            titleLabel, nickNameLabel, nickNameField, nextButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        nickNameField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(nickNameField)
            $0.top.equalTo(nickNameField.snp.bottom).offset(15)
            $0.height.equalTo(50)
        }
        
//        nextButton.snp.makeConstraints {
//            $0.right.left.equalToSuperview().inset(30)
//            
//            $0.leading.equalTo(passwordField.snp.leading)
//            $0.top.equalTo(passwordField.snp.bottom).offset(30)
//        }
    }
}
