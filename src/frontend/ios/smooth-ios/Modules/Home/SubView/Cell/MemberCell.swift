//
//  MemberCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import UIKit

class MemberCell: BaseTableViewCell {
    static let identifier = "\(MemberCell.self)"
    
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
    
    let memberTextLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    let ownerImage = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        presenceView.isHidden = false
        
        presenceView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.tintColor = .white
        self.clipsToBounds = true
        self.selectionStyle = .none
        
        [iconView, presenceView, memberTextLabel, ownerImage]
            .forEach { self.addSubview($0) }
        
        self.iconView.bringSubviewToFront(presenceView)
    }
    
    override func bindConstraints() {
        iconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.left.equalToSuperview().offset(15)
        }
        
        presenceView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom).offset(2)
            $0.right.equalTo(iconView.snp.right).offset(2)
            $0.width.height.equalTo(15)
        }
        
        memberTextLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.centerY.right.equalToSuperview()
        }
        
        ownerImage.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.left.equalTo(memberTextLabel).offset(3)
        }
    }
    
    func bind(member: Member) {
        memberTextLabel.text = member.nickname
        
        if (member.profileImage != nil) {
            iconView.setImage(URL(string: member.profileImage!)!)
        }
        
        switch (member.status) {
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
        
        if (member.role == .owner) {
            ownerImage.isHidden = false
        } else {
            ownerImage.isHidden = true
        }
        
        self.separatorInset = UIEdgeInsets.symmetric(vertical: 15, horizontal: 0)
        
        self.layoutIfNeeded()
    }
}
