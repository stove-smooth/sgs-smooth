//
//  SignInView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class SignInView: BaseView {
    
    private let emailView = UIView().then {
           $0.layer.cornerRadius = 15
           $0.layer.borderWidth = 1
       }

    let emailField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요."
        $0.keyboardType = .emailAddress
        $0.textColor = .black
        $0.returnKeyType = .go
    }
    
    
    let passwordField = UITextField().then {
        $0.placeholder = "비밀번호를 입력하세요."
        $0.isSecureTextEntry = true
        $0.textColor = .black
        $0.returnKeyType = .done
    }
    
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDartGrey
        
        [emailField, passwordField, loginButton].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func bindConstraints() {
        // snp views
        
        emailField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
        }
        
        passwordField.snp.makeConstraints {
            $0.leading.equalTo(emailField)
            $0.top.equalTo(emailField.snp.bottom).offset(15)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.equalTo(emailField)
            $0.trailing.equalTo(emailField)
            $0.top.equalTo(passwordField.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
    }
}

