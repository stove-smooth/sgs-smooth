//
//  ChannelEmptyView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit

class ChannelEmptyView: BaseView {
    let emptyImage = UIImageView().then {
        $0.image = UIImage(named: "empty-message")
        $0.contentMode = .scaleAspectFill
    }
    
    let emptyTextLabel = UILabel().then {
        $0.text = "채팅 채널 없음"
        $0.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
        $0.textColor = .iconDefault
    }
    
    let emptyDescriptionLabel = UILabel().then {
        $0.text = "난처한 상황에 처하셨군요. 채팅 채널 사용 권한이 업석나 서버에 채팅 채널이 없네요."
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: UIFont.labelFontSize-2, weight: .light)
        $0.textColor = .iconDefault
    }

    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [
            emptyImage, emptyTextLabel, emptyDescriptionLabel
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        emptyImage.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(emptyTextLabel.snp.top).offset(-20)
            $0.height.equalTo(150)
        }
        
        emptyTextLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyTextLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
    }
}
