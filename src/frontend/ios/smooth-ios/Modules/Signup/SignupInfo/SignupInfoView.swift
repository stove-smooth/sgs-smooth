//
//  SignUpInfoView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import Then

class SignupInfoView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "가입하기"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .white
    }
    
    let nameLabel = UILabel().then {
        $0.text = "사용자명 정하기"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let nameField = InputTextField().then {
        $0.placeholder = "닉네임"
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let passwordField = InputTextField().then {
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .done
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let notiTextLabel = UILabel().then {
        $0.text = "영어, 숫자, 특수문자를 포함하여 8자리 이상을 입력해주세요."
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.isHidden = true
    }
    
    let registerButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    let indicator = UIActivityIndicatorView()
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [
            titleLabel, nameLabel, nameField, registerButton, passwordField, notiTextLabel
        ].forEach {
            self.addSubview($0)
        }
        
        registerButton.addSubview(indicator)
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        nameField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(nameField)
            $0.top.equalTo(nameField.snp.bottom).offset(15)
            $0.height.equalTo(50)
        }
        
        notiTextLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(2)
            $0.leading.equalTo(passwordField.snp.leading)
        }
        
        registerButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(passwordField.snp.leading)
            $0.top.equalTo(notiTextLabel.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func initial() {
        self.registerButton.isEnabled = false
        self.registerButton.backgroundColor = .blurple_disabled
        self.registerButton.setTitle("다음", for: .normal)
        
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
    }
    
    func loading() {
        self.registerButton.isEnabled = true
        self.registerButton.backgroundColor = .blurple_disabled
        self.registerButton.setTitle("", for: .normal)
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
}
