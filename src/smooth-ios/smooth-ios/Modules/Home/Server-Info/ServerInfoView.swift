//
//  File.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import UIKit

class ServerInfoView: BaseView {
    let tapBackground = UITapGestureRecognizer()
    
    let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        $0.backgroundColor = .serverListDarkGray
        
        $0.layoutMargins = UIEdgeInsets.symmetric(vertical: 0, horizontal: 10)
    }
    
    let profileImg = UIImageView().then{
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.backgroundColor = .blurple
    }
    
    let nameLabel = UILabel().then {
        $0.text = "두리짱"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let inviteButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    let inviteLabel = UILabel().then { $0.text = "초대" }
    let inviteIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 30, height: 30)
        $0.image = UIImage(systemName: "person.fill.badge.plus")?.resizeImage(size: CGSize(width: 30, height: 30)).withTintColor(.white!, renderingMode: .alwaysOriginal)
    }
    
    let notiButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    let notiLabel = UILabel().then { $0.text = "알림" }
    let notiIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 30, height: 30)
        $0.image = UIImage(systemName: "bell.fill")?.resizeImage(size: CGSize(width: 30, height: 30)).withTintColor(.white!, renderingMode: .alwaysOriginal)
    }
    
    let settingButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    let settingLabel = UILabel().then { $0.text = "설정" }
    let settingIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 30, height: 30)
        $0.image = UIImage(systemName: "gearshape.fill")?.resizeImage(size: CGSize(width: 30, height: 30)).withTintColor(.white!, renderingMode: .alwaysOriginal)
    }
    
    override func setup() {
        [inviteIcon, inviteLabel]
            .forEach { inviteButton.addArrangedSubview($0) }
        [notiIcon, notiLabel]
            .forEach { notiButton.addArrangedSubview($0) }
        [settingIcon, settingLabel]
            .forEach { settingButton.addArrangedSubview($0) }
        
        [inviteButton, notiButton, settingButton]
            .forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            profileImg, nameLabel,
            buttonStackView
        ].forEach {
            containerView.addSubview($0)
        }
        
        self.addSubview(containerView)
    }
    
    override func bindConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        profileImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().offset(10)
            $0.height.equalTo(50)
        }
        
        inviteButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        notiButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
    }
    
    func bind(communityInfo: CommunityInfo) {
        print(communityInfo)
    }
}
