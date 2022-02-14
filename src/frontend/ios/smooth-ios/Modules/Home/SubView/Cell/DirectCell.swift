//
//  DirectCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import UIKit

class DirectCell: BaseTableViewCell {
    static let identifier = "\(DirectCell.self)"
    
    let iconView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let roomTextLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    let roomInfoLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 11)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.tintColor = .white
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        [iconView, stackView].forEach { self.addSubview($0) }
        
        [roomTextLabel, roomInfoLabel ].forEach {  stackView.addArrangedSubview($0) }
        
        roomInfoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        roomInfoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        roomInfoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        roomInfoLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    override func bindConstraints() {
        iconView.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.height.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(5)
        }
        
        roomTextLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        roomInfoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
    
    func bind(room: Room) {
        roomTextLabel.text = room.name
        
        if (room.icon != nil) {
            iconView.setImage(URL(string: room.icon!)!)
        } else {
            iconView.image = UIImage(named: "profile-\((room.id % 5)+1)")
            iconView.backgroundColor = .blurple
        }
        
        if (room.name.split(separator: ",").count>2) {
            roomInfoLabel.text = "멤버 \(room.name.split(separator: ",").count)명"
        } else {
            roomInfoLabel.isHidden = true
        }
        
        self.setNeedsUpdateConstraints()
    }
}
