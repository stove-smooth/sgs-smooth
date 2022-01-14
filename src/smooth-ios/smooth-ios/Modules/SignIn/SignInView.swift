//
//  SignInView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class SignInView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "돌아오신 것을 환영해요!"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "다시 만나다니 너무 반가워요!"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
    }

    let emailField = InputTextField().then {
        $0.placeholder = "이메일 또는 전화번호"
        $0.keyboardType = .emailAddress
        
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
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDartGray
        
        [
            titleLabel, titleDescriptionLabel,
            emailField, passwordField,
            loginButton
        ].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        emailField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(50)
            $0.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(emailField)
            
            $0.top.equalTo(emailField.snp.bottom).offset(15)
            $0.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(emailField)
            $0.trailing.equalTo(emailField)
            $0.top.equalTo(passwordField.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
    }
}

