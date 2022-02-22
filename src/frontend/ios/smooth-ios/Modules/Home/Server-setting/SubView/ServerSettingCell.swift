//
//  ServerSettingCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerSettingCell: BaseTableViewCell {
    static let identifier = "\(ServerSettingCell.self)"
    
    let iconImageView = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.text = "일반"
        $0.textColor = .iconDefault
    }
    
    let rightArrow = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    override func setup() {
        backgroundColor = .backgroundDarkGray
        self.selectionStyle = .none
        
        [
            iconImageView, titleLabel, rightArrow
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        self.iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.iconImageView)
            $0.left.equalTo(self.iconImageView.snp.right).offset(8)
        }
        
        self.rightArrow.snp.makeConstraints {
            $0.centerY.equalTo(self.iconImageView.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func bind(image: UIImage, title: String) {
        self.iconImageView.image = image
        self.titleLabel.text = title
    }
}
