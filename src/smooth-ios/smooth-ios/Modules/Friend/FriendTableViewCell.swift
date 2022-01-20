//
//  FriendTableViewCell.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/15.
//

import UIKit
import Then
import SnapKit
import RxSwift

// TODO: - state가 친구인 경우, 메시지/미팅 버튼 노출

class FriendCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    static let identifier = "FriendCell"
    
    let profileImg: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        let imgCGValue = img.bounds.size.width/4
        img.center = CGPoint(x: imgView.bounds.size.width / 2 - imgCGValue, y: imgView.bounds.size.height / 2 - imgCGValue)
        
        img.image = UIImage(named: "Logo")
        img.contentMode = .scaleAspectFit
        imgView.addSubview(img)
    
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        
        return imgView
    }()
    
    let nameLabel = UILabel().then {
        $0.text = "두리짱"
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let stateLable = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 9, weight: .thin)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let acceptButton = UIButton().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.setImage(UIImage(systemName: "checkmark")?.withTintColor(.online!, renderingMode: .alwaysOriginal), for: .normal)
    
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    let rejectButton = UIButton().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.setImage(UIImage(systemName: "multiply")?.withTintColor(.red!, renderingMode: .alwaysOriginal), for: .normal)
    
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    let messageButton = UIButton().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.setImage(UIImage(systemName: "bubble.left.fill")?.withTintColor(.greyple!, renderingMode: .alwaysOriginal), for: .normal)
    
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    let callingButton = UIButton().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.setImage(UIImage(systemName: "phone.fill")?.withTintColor(.greyple!, renderingMode: .alwaysOriginal), for: .normal)

        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ui(friend: Friend) {
        nameLabel.text = friend.name
        profileImg.backgroundColor = UIColor.random(code: Int(friend.code) ?? 0)
        
        if (friend.profileImage != nil) {
            profileImg.setImage(URL(string: friend.profileImage!)!)
        }
        
        switch friend.state {
        case .wait:
            stateLable.text = "받은 친구 요청"
            
            self.messageButton.isHidden = true
            self.callingButton.isHidden = true
            
        case .request:
            stateLable.text = "보낸 친구 요청"
            
            self.acceptButton.isHidden = true
            self.messageButton.isHidden = true
            self.callingButton.isHidden = true
            
            
        // TODO: 친구 상태값(온라인, 오프라인, 자리비움 등등) 노출
        case .accept:
            self.rejectButton.isHidden = true
            self.acceptButton.isHidden = true
        case .ban:
            self.rejectButton.isHidden = true
            self.acceptButton.isHidden = true
        }
        
        self.textLabel?.textColor = .white
        self.backgroundColor = .clear
        self.tintColor = .white
        
        self.separatorInset = UIEdgeInsets.all(3)
        self.selectionStyle = .none
        
        // request(친구 요청 보낸 사람 - 수락 대기 중)
        // wait(친구 요청 응답 기다리는 중)
        
    }
    
    
    func layout() {
        [
            profileImg, nameLabel, stateLable,
            rejectButton, acceptButton,
            messageButton, callingButton
        ].forEach {
            self.contentView.addSubview($0)
        }
        
        profileImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImg.snp.trailing).offset(10)
        }
        
        stateLable.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        
        acceptButton.snp.makeConstraints {
            $0.right.equalTo(rejectButton.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        rejectButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        messageButton.snp.makeConstraints {
            $0.right.equalTo(callingButton.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        callingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
}
