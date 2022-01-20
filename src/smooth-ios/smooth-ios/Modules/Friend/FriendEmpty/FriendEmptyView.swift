//
//  FriendEmptyView.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit
import Then

class FriendEmptyView: BaseView {
    // MARK: - Empty View
    let emptyTextLabel = UILabel().then {
        $0.text = "Wumpus는 친구를 기다리고 있어요."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textColor = .white
    }
    
    let emptyImage = UIImageView().then {
        $0.image = UIImage(named: "empty-background")
        $0.contentMode = .scaleAspectFill
    }
    
    let friendButton = UIButton().then {
        $0.setTitle("친구 추가하기", for: .normal)
        $0.backgroundColor = .blurple
        $0.layer.cornerRadius = 5
        $0.contentEdgeInsets = UIEdgeInsets.symmetric(vertical: 5, horizontal: 8)
    }

    
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
         
        [
            emptyTextLabel, emptyImage, friendButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        
        emptyImage.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(50)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.height.equalTo(150)
        }
        
        emptyTextLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        friendButton.snp.makeConstraints {
            $0.top.equalTo(emptyTextLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            
        }
    }
}
