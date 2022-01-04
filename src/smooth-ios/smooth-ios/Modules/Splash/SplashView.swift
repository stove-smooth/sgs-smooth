//
//  SplashView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import SnapKit
import Then

class SplashView: BaseView {
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Logo+Title")
        $0.contentMode = .scaleAspectFit
    }
    
    let splashImageView = UIImageView().then {
        $0.image = UIImage(named: "Splash+Main")
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Discord에 오신 걸 환영합니다"
        $0.textAlignment = .center
        $0.font = UIFont.GintoNord(type: .Bold, size: 20)
        $0.textColor = UIColor.white
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "1억명 이상의 전 세계 커뮤니티와 친구들이 모이는 Discord에서 함께 대화를 나눠보세요."
        $0.textAlignment = .center
        $0.font = UIFont.GintoNord(type: .Medium, size: 15)
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "0xB1B1B1")
    }
    
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = UIColor.blurple
    }
    
    let signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.iconsDarkGrey
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDartGrey
        
        [
            logoImageView, splashImageView,
            titleLabel, titleDescriptionLabel,
            signUpButton, signInButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        logoImageView.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(50)
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(60)
        }
        
        splashImageView.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(50)
            $0.top.equalTo(logoImageView.snp.bottom).offset(150)
            $0.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(splashImageView.snp.bottom).offset(150)
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        signUpButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(30)
        }
        
        signInButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(30)
            $0.top.equalTo(signUpButton.snp.bottom).offset(10)
        }
    }
}
