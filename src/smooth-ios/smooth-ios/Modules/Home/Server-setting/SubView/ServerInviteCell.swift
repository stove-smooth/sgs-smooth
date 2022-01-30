//
//  ServerInviteCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import RxSwift

class ServerInviteCell: BaseTableViewCell {
    static let identifier = "\(ServerInviteCell.self)"
    
    let profileImg = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let userNameLabel = UILabel().then {
        $0.textColor = .white
    }
    
    let userCodeLabel = UILabel().then {
        $0.textColor = .iconDefault
    }
    
    let inviteCodeLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .bold)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userNameLabel.text = nil
        self.userCodeLabel.text = nil
        self.profileImg.image = nil
        self.profileImg.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        self.disposeBag = DisposeBag()
    }
    
    override func setup() {
        backgroundColor = .serverListDarkGray
        self.separatorInset = UIEdgeInsets.symmetric(vertical: 5, horizontal: 0)
        self.selectionStyle = .gray
        
        self.selectionStyle = .gray
        
        [
            profileImg, userNameLabel, userCodeLabel, inviteCodeLabel
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        profileImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImg)
            $0.left.equalTo(profileImg.snp.right).offset(8)
        }
        
        userCodeLabel.snp.makeConstraints {
            $0.centerY.equalTo(userNameLabel)
            $0.left.equalTo(userNameLabel.snp.right)
        }
        
        inviteCodeLabel.snp.makeConstraints {
            $0.centerY.equalTo(userNameLabel)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func bind(inviteUser: Invitation) {
        self.userNameLabel.text = inviteUser.nickname
        self.userCodeLabel.text = "#\(inviteUser.userCode)"
        self.inviteCodeLabel.text = inviteUser.inviteCode
        
        if (inviteUser.profileImage != nil) {
            profileImg.setImage(URL(string: inviteUser.profileImage!)!)
        } else {
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            
            img.center = CGPoint(x: 15 , y: 15)
            
            img.image = UIImage(named: "Logo")
            profileImg.backgroundColor = UIColor.random(code: Int(inviteUser.userCode) ?? 0)
            
            img.contentMode = .scaleAspectFit
            
            profileImg.addSubview(img)
        }
        
    }
}
