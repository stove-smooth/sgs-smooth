//
//  ChannelReorderCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import UIKit

class ChannelReorderCell: BaseTableViewCell {
    static let identifier = "\(ChannelReorderCell.self)"
    
    let iconImageView = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.textColor = .iconDefault
    }
    
    let rightButton = UIImageView().then {
        $0.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }

    override func setup() {
        self.backgroundColor = .serverListDarkGray
        self.selectionStyle = .none
        
        [iconImageView, titleLabel, rightButton].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.iconImageView)
            $0.left.equalTo(self.iconImageView.snp.right).offset(8)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func bind(channel: Channel) {
        self.iconImageView.image = UIImage(named: "Channel+\(channel.type.rawValue.lowercased())")
        self.titleLabel.text = channel.name
    }
}
