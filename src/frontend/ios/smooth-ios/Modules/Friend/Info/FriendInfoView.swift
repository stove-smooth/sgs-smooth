//
//  FriendInfoView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import Foundation
import UIKit

class FriendInfoView: BaseView {
    let tapBackground = UITapGestureRecognizer()
    
    let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        $0.backgroundColor = .serverListDarkGray
    }

    let profileColorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let profileInfoView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let profileImg: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imgView.makeCircle()
        
        imgView.layer.borderWidth = 5.0
        imgView.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        
        imgView.layer.masksToBounds = true
        
        return imgView
    }()
    
    let nameLabel = UILabel().then {
        $0.text = "두리짱"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .white
    }
    
    let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis")?.withTintColor(.white!, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    override func setup() {
        [
            profileColorView, profileInfoView,
            profileImg, settingButton, nameLabel
        ].forEach{
            containerView.addSubview($0)
        }
        
        self.addSubview(containerView)
        
    }
    
    override func bindConstraints() {
        
        containerView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        profileColorView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(containerView)
            $0.top.equalTo(containerView)
        }
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(profileColorView.snp.bottom)
            $0.width.equalTo(containerView)
        }
        
        settingButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.right.equalTo(containerView).offset(-10)
            $0.top.equalTo(containerView).offset(10)
        }
        
        profileImg.snp.makeConstraints {
            $0.centerY.equalTo(containerView)
            $0.leading.equalTo(containerView).offset(30)
            $0.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(5)
            $0.leading.equalTo(containerView).offset(30)
        }
    }
    
    func bind(friend: Friend) {
        print("bind friend \(friend)")
        
        profileColorView.backgroundColor = UIColor.random(code: Int(friend.code) ?? 0)
        
        if (friend.profileImage != nil) {
            profileImg.setImage(URL(string: friend.profileImage!)!)
        } else {
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            img.image = UIImage(named: "Logo")
            img.contentMode = .scaleAspectFit
            
            img.center = CGPoint(x: profileImg.bounds.size.width / 2, y: profileImg.bounds.size.height / 2)

            profileImg.backgroundColor = UIColor.random(code: Int(friend.code) ?? 0)
            profileImg.addSubview(img)
        }
        
        nameLabel.text = "\(friend.name)#\(friend.code)"
    }
}
