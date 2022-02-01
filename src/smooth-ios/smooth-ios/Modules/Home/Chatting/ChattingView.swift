//
//  ChattingView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import UIKit
import RxSwift

class ChattingView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let menuButton = UIImageView().then {
        $0.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.white!, renderingMode: .alwaysOriginal)
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "일반"
    }
    
    let naviTitleIcon = UIImageView()
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [
            menuButton, naviTitleLabel, naviTitleIcon
        ].forEach {navigationView.addSubview($0)}
        
        [
            navigationView
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        menuButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(safeAreaLayoutGuide).offset(13)
            $0.width.height.equalTo(20)
        }
        
        naviTitleIcon.snp.makeConstraints {
            $0.left.equalTo(menuButton.snp.right).offset(25)
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(menuButton)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.left.equalTo(naviTitleIcon.snp.right).offset(5)
            $0.centerY.equalTo(menuButton)
        }
    }
    
    func bind(channel: Channel) {
        naviTitleLabel.text = "\(channel.name)"
        
        naviTitleIcon.image = UIImage(named: "Channel+\(channel.type.rawValue.lowercased())")
    }
}


