//
//  ServerInfoCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerInfoCell: BaseTableViewCell {
    static let identifier = "\(ServerInfoCell.self)"
    
    let titleLabel = UILabel().then {
        $0.text = "텍스트"
        $0.textColor = .white
    }
    
    override func setup() {
        backgroundColor = UIColor(hex: "0x35393E")
        selectionStyle = .none
        addSubview(titleLabel)
    }
    
    override func bindConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func bind(title: String) {
        self.titleLabel.text = title
    }
}
