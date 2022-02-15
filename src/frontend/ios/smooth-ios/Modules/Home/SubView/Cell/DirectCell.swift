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
    
    let presenceView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.layer.zPosition = 1
        $0.layer.borderColor = UIColor.channelListDarkGray?.cgColor
        $0.layer.borderWidth = 3
    }
    
    let roomTextLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    let roomInfoLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: 11)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roomTextLabel.isHidden = false
        presenceView.isHidden = false
        
        presenceView.subviews.forEach { $0.removeFromSuperview() }
        roomInfoLabel.removeFromSuperview()
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.tintColor = .white
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        [iconView, presenceView, roomTextLabel]
            .forEach { self.addSubview($0) }
        
        self.iconView.bringSubviewToFront(presenceView)
    }
    
    override func bindConstraints() {
        iconView.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        presenceView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom).offset(2)
            $0.right.equalTo(iconView.snp.right).offset(2)
            $0.width.height.equalTo(15)
        }
        
        roomTextLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview()
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
            self.addSubview(roomInfoLabel)
            
            roomInfoLabel.text = "멤버 \(room.name.split(separator: ",").count)명"
            
            roomInfoLabel.snp.makeConstraints {
                $0.left.right.equalTo(roomTextLabel)
                $0.top.equalTo(roomTextLabel.snp.bottom)
            }
            roomTextLabel.snp.makeConstraints {
                $0.bottom.equalTo(contentView.snp.centerY)
            }
        } else {
            roomInfoLabel.removeFromSuperview()
            roomTextLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        if (room.state != nil) {
            switch (room.state!) {
            case .online:
                presenceView.backgroundColor = .online
            case .offline:
                presenceView.backgroundColor = .offline
                
                let offlineView = UIView().then {
                    $0.backgroundColor = .channelListDarkGray
                    $0.layer.cornerRadius = 2.5
                    $0.layer.masksToBounds = true
                    $0.clipsToBounds = true
                }
                presenceView.addSubview(offlineView)
                
                offlineView.snp.makeConstraints {
                    $0.centerX.centerY.equalToSuperview()
                    $0.width.height.equalTo(5)
                }
            case .unknown:
                presenceView.isHidden = true
            }
        } else {
            presenceView.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
}
