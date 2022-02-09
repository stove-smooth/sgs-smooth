//
//  ServerSettingView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerSettingView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "서버 설정"
    }
    
    let tableView = UITableView(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 0, right: 0)
        
        $0.register(ServerSettingCell.self, forCellReuseIdentifier: ServerSettingCell.identifier)
        $0.register(ServerSettingHeaderCell.self, forHeaderFooterViewReuseIdentifier: ServerSettingHeaderCell.identifier)
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [closeButton, naviTitleLabel].forEach {navigationView.addSubview($0)}
        
        [
            navigationView, tableView
        ].forEach {self.addSubview($0)}
        
    }

    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview()
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
        }
    }
}
