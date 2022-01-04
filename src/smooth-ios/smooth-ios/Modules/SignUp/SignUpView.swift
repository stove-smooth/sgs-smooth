//
//  SignUpView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import Then

class SignUpView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "이메일을 입력하세요"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .white
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let emailField = InputTextField().then {
        $0.placeholder = "이메일"
        $0.keyboardType = .emailAddress
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDartGrey
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDartGrey
        
        [
            titleLabel, emailLabel, emailField, nextButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        emailLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        emailField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(emailLabel.snp.leading)
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            
            $0.leading.equalTo(emailLabel.snp.leading)
            $0.top.equalTo(emailField.snp.bottom).offset(30)
        }
    }
}
