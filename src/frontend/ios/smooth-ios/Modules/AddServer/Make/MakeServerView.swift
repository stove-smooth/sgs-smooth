//
//  MakeServerView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit

class MakeServerView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "이 서버에 대해 더 자세히 말해주세요"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "설정을 돕고자 질문을 드려요. 혹시 서버가 친구 몇 명만을 위한 서버인가요, 아니면 더 큰 커뮤니티를 위한 서버인가요?"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let privateButton = UIButton().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layer.cornerRadius = 5
        $0.contentHorizontalAlignment = .left
        
        $0.setTitle("나와 친구들을 위한 서버", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(UIImage(named: "Server+Private")?.resizeImage(size: CGSize(width: 40, height: 40)), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    let publicButton = UIButton().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layer.cornerRadius = 5
        $0.contentHorizontalAlignment = .left
        
        $0.setTitle("클럽,혹은 커뮤니티용 서버", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(UIImage(named: "Server+Public")?.resizeImage(size: CGSize(width: 40, height: 40)), for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    override func setup() {
        self.backgroundColor = .backgroundDarkGray
        
        [
            titleLabel, titleDescriptionLabel, privateButton, publicButton
            
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        privateButton.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(15)
            $0.right.left.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        publicButton.snp.makeConstraints {
            $0.top.equalTo(privateButton.snp.bottom).offset(15)
            $0.right.left.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
    }
}
