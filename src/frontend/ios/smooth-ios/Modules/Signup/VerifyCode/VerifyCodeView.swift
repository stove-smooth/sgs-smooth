//
//  VerifyCodeView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import UIKit
import Then

class VerifyCodeView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.text = "이메일 인증번호를 입력해주세요"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .white
    }
    
    let verifyCodeLabel = UILabel().then {
        $0.text = "인증번호"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let verifyCodeField = InputTextField().then {
        $0.placeholder = "인증번호"
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
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
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [
            titleLabel, verifyCodeLabel, verifyCodeField, nextButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        verifyCodeLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        verifyCodeField.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(verifyCodeLabel.snp.leading)
            $0.top.equalTo(verifyCodeLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(verifyCodeLabel.snp.leading)
            $0.top.equalTo(verifyCodeField.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
    }
}
