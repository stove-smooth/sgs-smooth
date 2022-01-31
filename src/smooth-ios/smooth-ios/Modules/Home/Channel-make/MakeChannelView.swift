//
//  MakeChannelView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit

class MakeChannelView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "채널 만들기"
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
    }
    
    let makeButton = UIButton().then {
        $0.setTitle("만들기", for: .normal)
        $0.tintColor = .white
    }

    let channelNameLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.text = "채널이름"
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let channelNameInput = InputTextField().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.textColor = .white
        $0.tintColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let channelTypeLabel = UILabel().then {
        $0.text = "채널 유형"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
    }
    
    let chattingTypeView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let chattingTypeTitle = UILabel().then {
        $0.text = "채팅 채널"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    let chattingTypeSubTitle = UILabel().then {
        $0.text = "이미지, GIF, 스티커, 의견, 농담을 올려보세요"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize-2, weight: .light)
    }
    let chattingButton = UIButton().then {
        $0.setImage(UIImage(named: "Radio-selected"), for: .normal)
    }

    let voiceButton = UIButton().then {
        $0.setImage(UIImage(named: "Radio"), for: .normal)
    }
    
    let chattingTypeIcon = UIImageView().then {
        $0.image = UIImage(named: "Channel+text")
    }
    
    let voiceTypeIcon = UIImageView().then {
        $0.image = UIImage(named: "Channel+voice")
    }
    
    let voiceTypeView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let voiceTypeTitle = UILabel().then {
        $0.text = "음성 채널"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    let voiceTypeSubTitle = UILabel().then {
        $0.text = "라이브 오디오로 여러 명과 대화하세요"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize-2, weight: .light)
    }
    
    let accessView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let accessIcon = UIImageView().then {
        $0.image = UIImage(systemName: "lock.fill")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    let accessLabel = UILabel().then {
        $0.text = "비공개 채널"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    let accessButton = UISwitch().then {
        $0.onTintColor = .lightBlurple
        $0.isOn = false
    }
    
    let accessDescription = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "채널을 비공개로 만들면 선택한 멤버들과 역할만 이 채널을 볼 수 있어요."
        $0.textAlignment = .justified
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        $0.textColor = .iconDefault
    }
    
    override func setup() {
        self.backgroundColor = UIColor.messageBarDarkGray
        
        [closeButton, naviTitleLabel, makeButton].forEach { navigationView.addSubview($0) }
        
        [
            accessIcon, accessLabel, accessButton
        ].forEach { accessView.addSubview($0) }
        
        [
            chattingTypeIcon, chattingTypeTitle, chattingTypeSubTitle, chattingButton
        ].forEach { chattingTypeView.addSubview($0) }
        
        [
            voiceTypeIcon, voiceTypeTitle, voiceTypeSubTitle, voiceButton
        ].forEach { voiceTypeView.addSubview($0) }
        
        
        [
            navigationView,
            channelNameLabel, channelNameInput,
            channelTypeLabel, chattingTypeView, voiceTypeView,
            accessView, accessDescription
        ].forEach {self.addSubview($0)}
        
    }

    override func bindConstraints() {
        // MARK: navi
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton)
        }
        
        makeButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        // MARK: name
        channelNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
        }
        
        channelNameInput.snp.makeConstraints {
            $0.top.equalTo(channelNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        
        channelTypeLabel.snp.makeConstraints {
            $0.top.equalTo(channelNameInput.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(15)
        }
        
        // MARK: chat
        chattingTypeView.snp.makeConstraints {
            $0.top.equalTo(channelTypeLabel.snp.bottom).offset(5)
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview()
        }
        
        chattingTypeIcon.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        chattingTypeTitle.snp.makeConstraints {
            $0.left.equalTo(chattingTypeIcon.snp.right).offset(15)
            $0.bottom.equalTo(chattingTypeView.snp.centerY)
        }
        
        chattingTypeSubTitle.snp.makeConstraints {
            $0.top.equalTo(chattingTypeTitle.snp.bottom).offset(1)
            $0.left.equalTo(chattingTypeTitle)
        }
        
        chattingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.width.height.equalTo(30)
        }
        
        // MARK: voice
        voiceTypeView.snp.makeConstraints {
            $0.top.equalTo(chattingTypeView.snp.bottom)
            $0.height.equalTo(60)
            $0.left.right.equalToSuperview()
        }
        
        voiceTypeIcon.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        voiceTypeTitle.snp.makeConstraints {
            $0.left.equalTo(voiceTypeIcon.snp.right).offset(15)
            $0.bottom.equalTo(voiceTypeView.snp.centerY)
        }
        
        voiceTypeSubTitle.snp.makeConstraints {
            $0.top.equalTo(voiceTypeTitle.snp.bottom).offset(1)
            $0.left.equalTo(voiceTypeTitle)
        }
        
        voiceButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.width.height.equalTo(30)
        }
        
        // MARK: access
        accessView.snp.makeConstraints {
            $0.top.equalTo(voiceTypeView.snp.bottom).offset(15)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        
        accessIcon.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        accessLabel.snp.makeConstraints {
            $0.left.equalTo(accessIcon.snp.right).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        accessButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
        accessDescription.snp.makeConstraints {
            $0.top.equalTo(accessView.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
    }
    
    func setType(chat: Bool) {
        if chat { // 채널을 선택한 경우
            chattingButton.setImage(UIImage(named: "Radio-selected"), for: .normal)
            voiceButton.setImage(UIImage(named: "Radio"), for: .normal)
        } else {
            chattingButton.setImage(UIImage(named: "Radio"), for: .normal)
            voiceButton.setImage(UIImage(named: "Radio-selected"), for: .normal)
        }
    }
}
