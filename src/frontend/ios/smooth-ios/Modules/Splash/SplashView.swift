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
        $0.contentMode = .scaleAspectFit
        $0.setContentCompressionResistancePriority(UILayoutPriority(0), for: .vertical)
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
        $0.textColor = UIColor.textDescription
    }
    
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    let signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.iconsDarkGray
        $0.layer.cornerRadius = 5
    }
    
    let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.contentMode = .scaleAspectFit
        $0.spacing = 10
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        [
            logoImageView, splashImageView, titleLabel, titleDescriptionLabel, signUpButton, signInButton
        ].forEach {stackView.addArrangedSubview($0)}
        
        [
            stackView
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            $0.right.left.equalToSuperview().inset(30)
        }
        
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}
