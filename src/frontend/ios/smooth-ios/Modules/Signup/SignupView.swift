//
//  SignUpView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import Then

class SignupView: BaseView {
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
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    let notiTextLabel = UILabel().then {
        $0.text = "이메일 주소에 @를 포함해주세요."
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.isHidden = true
    }
    
    let nextButton = UIButton().then {
        $0.layer.cornerRadius = 5
    }
    
    let indicator = UIActivityIndicatorView()
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [
            titleLabel, emailLabel, emailField, notiTextLabel, nextButton
        ].forEach {
            self.addSubview($0)
        }
        
        nextButton.addSubview(indicator)
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
        
        notiTextLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(2)
            $0.leading.equalTo(emailLabel.snp.leading)
        }
        
        nextButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.leading.equalTo(emailLabel.snp.leading)
            $0.top.equalTo(notiTextLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func initial() {
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = .blurple_disabled
        self.nextButton.setTitle("다음", for: .normal)
        
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
    }
    
    func loading() {
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = .blurple_disabled
        self.nextButton.setTitle("", for: .normal)
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
}
