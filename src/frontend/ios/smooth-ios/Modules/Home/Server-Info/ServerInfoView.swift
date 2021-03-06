//
//  File.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import UIKit

class ServerInfoView: BaseView {
    let tapBackground = UITapGestureRecognizer()
    
    let containerView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        $0.backgroundColor = .serverListDarkGray
        
        $0.layoutMargins = UIEdgeInsets.symmetric(vertical: 0, horizontal: 10)
    }
    
    let profileImg = UIImageView().then{
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.backgroundColor = .blurple
    }
    
    let textView = UILabel().then {
        $0.textColor = .white
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
    }
    
    let buttonStackView = UIStackView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let inviteButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.alignment = .center
    }
    let inviteLabel = UILabel().then {
        $0.text = "초대"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    let inviteIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 20, height: 20)
        $0.image = UIImage(systemName: "person.fill.badge.plus")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    let notiButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.alignment = .center
    }
    let notiLabel = UILabel().then {
        $0.text = "알림"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    let notiIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 20, height: 20)
        $0.image = UIImage(systemName: "bell.fill")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    let settingButton = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.alignment = .center
        $0.isUserInteractionEnabled = false 
    }
    let settingLabel = UILabel().then {
        $0.text = "설정"
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    let settingIcon = UIImageView().then {
        $0.frame.size = CGSize(width: 20, height: 20)
        $0.image = UIImage(systemName: "gearshape.fill")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    let tableBackView = UIView().then {
        $0.backgroundColor = .channelListDarkGray
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 0, right: 0)
        $0.register(ServerInfoCell.self, forCellReuseIdentifier: ServerInfoCell.identifier)
        $0.layer.cornerRadius = 5
    }
    
    override func setup() {
        [inviteIcon, inviteLabel]
            .forEach { inviteButton.addArrangedSubview($0) }
        [notiIcon, notiLabel]
            .forEach { notiButton.addArrangedSubview($0) }
        [settingIcon, settingLabel]
            .forEach { settingButton.addArrangedSubview($0) }
        
        [inviteButton, notiButton, settingButton]
            .forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            profileImg, nameLabel,
            buttonStackView, tableBackView
        ].forEach {
            containerView.addSubview($0)
        }
        
        tableBackView.addSubview(tableView)
        profileImg.addSubview(textView)
        
        self.addSubview(containerView)
    }
    
    override func bindConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        profileImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(60)
        }
        
        textView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        
        inviteButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        notiButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        tableBackView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    func bind(server: Server, owner: Bool) {
        settingButton.isHidden = !owner
        
        nameLabel.text = server.name
        
        if server.icon != nil {
            profileImg.setImage(URL(string: server.icon!)!)
            textView.isHidden = true
        } else {
            textView.isHidden = false
            textView.text = "\(server.name)"
        }
    }
}
