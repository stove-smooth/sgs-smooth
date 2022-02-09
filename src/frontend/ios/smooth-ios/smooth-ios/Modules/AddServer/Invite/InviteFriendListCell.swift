//
//  InviteFriendListCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/27.
//

import UIKit

class InviteFriendListCell: BaseTableViewCell {
    static let identifier = "\(InviteFriendListCell.self)"
    static let height: CGFloat = 60
    
    let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        
    }
    
    let profileImg = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .white
    }
    
    let codeLabel = UILabel().then {
        $0.textColor = .messageBarLightGray
    }
    
    let inviteButton = UIButton().then {
        $0.backgroundColor = .iconsDarkGray
        $0.titleLabel?.textColor = .white
        $0.setTitle("초대하기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets.all(3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.infoStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.profileImg.subviews.forEach {$0.removeFromSuperview()}
        
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            profileImg, nameLabel, codeLabel,
            infoStackView, inviteButton
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        profileImg.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(profileImg.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        codeLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.right)
            $0.centerY.equalToSuperview()
        }
        
        inviteButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(friend: Friend) {
        nameLabel.text = friend.name
        codeLabel.text = "#\(friend.code)"
        
        profileImg.backgroundColor = UIColor.random(code: Int(friend.code) ?? 0)
        
        if (friend.profileImage != nil) {
            profileImg.setImage(URL(string: friend.profileImage!)!)
        } else {
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            
            img.center = CGPoint(x: 15 , y: 15)
            
            img.image = UIImage(named: "Logo")
            img.contentMode = .scaleAspectFit
            
            profileImg.addSubview(img)
        }
    }
}
