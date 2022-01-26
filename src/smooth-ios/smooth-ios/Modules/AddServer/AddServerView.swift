//
//  AddServerView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit

class AddServerView: BaseView {
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.tintColor = .white
    }
    
    let titleLabel = UILabel().then {
        $0.text = "서버를 만들어보세요"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "서버는 나와 친구들이 함께 어울리는 공간입니다.\n내 서버를 만들고 대화를 시작해보세요."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let makeButton = UIButton().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layer.cornerRadius = 5
        $0.contentHorizontalAlignment = .left
        
        $0.setTitle("직접 만들기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(UIImage(named: "Server+Generate")?.resizeImage(size: CGSize(width: 40, height: 40)), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    let joinButton = UIButton().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layer.cornerRadius = 5
        $0.contentHorizontalAlignment = .left
        
        $0.setTitle("서버 참여하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(UIImage(named: "Server+Join")?.resizeImage(size: CGSize(width: 40, height: 40)), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    }
    
    override func setup() {
        self.backgroundColor = .backgroundDarkGray
        
        [
            closeButton, titleLabel, titleDescriptionLabel,
            makeButton, joinButton
            
        ].forEach { self.addSubview($0) }
    }
    
    
    override func bindConstraints() {
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(safeAreaLayoutGuide).offset(-15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        makeButton.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(15)
            $0.right.left.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(makeButton.snp.bottom).offset(15)
            $0.right.left.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
    }
}
