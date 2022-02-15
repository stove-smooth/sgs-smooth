//
//  ProfileView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import UIKit

//class ProfileView: BaseView {
//
//    let backButton = UIButton().then {
//      $0.setImage(UIImage(named: "ic_back_white"), for: .normal)
//    }
//
//    let titleLabel = UILabel().then {
//      $0.text = "webRTC WebView"
//    }
//
//    let webView = WKWebView().then {
//        $0.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
//    }
//
//    override func setup() {
//        [ webView ].forEach { self.addSubview($0) }
//    }
//
//    override func bindConstraints() {
//        self.webView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//}


class ProfileView: BaseView {
    
    let containerView = UIView().then {
        $0.backgroundColor = .messageBarDarkGray
    }
    
    let profileColorView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let profileInfoView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .serverListDarkGray
    }
    
    let profileImg = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        $0.makeCircle()
        
        $0.layer.borderWidth = 5.0
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        
        $0.layer.masksToBounds = true
    }
    
    let presenceView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .online
        $0.layer.zPosition = 1
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        $0.layer.borderWidth = 3
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .white
    }
    
    let codeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .gray
    }
    
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let tableView = UITableView(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 0, right: 0)
        $0.separatorStyle = .none
        $0.register(ServerSettingCell.self, forCellReuseIdentifier: ServerSettingCell.identifier)
    }
    
    let tabBarView = TabBarView()
    
    override func setup() {
        [
            profileColorView, profileInfoView, presenceView,
            profileImg, nameLabel, codeLabel,
            logoutButton, tabBarView, tableView
        ].forEach{
            containerView.addSubview($0)
        }
        
        self.addSubview(containerView)
        self.addSubview(tabBarView)
        
        self.profileImg.bringSubviewToFront(presenceView)
    }
    
    override func bindConstraints() {
        containerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(tabBarView.snp.top)
        }
        
        profileColorView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.top.left.right.width.equalTo(containerView)
        }
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(profileColorView.snp.bottom)
            $0.width.equalTo(containerView)
            $0.height.equalTo(100)
        }
        
        profileImg.snp.makeConstraints {
            $0.centerY.equalTo(profileInfoView.snp.top)
            $0.left.equalTo(containerView).offset(30)
            $0.width.height.equalTo(100)
        }
        
        presenceView.snp.makeConstraints {
            $0.bottom.equalTo(profileImg.snp.bottom).offset(-10)
            $0.right.equalTo(profileImg.snp.right).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(5)
            $0.leading.equalTo(containerView).offset(30)
        }
        
        codeLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
        }
        
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalTo(tabBarView.snp.top).offset(-30)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(profileInfoView.snp.bottom).offset(30)
            $0.bottom.equalTo(logoutButton.snp.top).offset(-30)
        }
        
        tabBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    func bind(user: User) {
        profileColorView.backgroundColor = UIColor.random(code: Int(user.code) ?? 0)
        
        if (user.profileImage != nil) {
            profileImg.setImage(URL(string: user.profileImage!)!)
        } else {
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            img.image = UIImage(named: "Logo")
            img.contentMode = .scaleAspectFit
            
            img.center = CGPoint(x: profileImg.bounds.size.width / 2, y: profileImg.bounds.size.height / 2)
            
            profileImg.backgroundColor = UIColor.random(code: Int(user.code) ?? 0)
            profileImg.addSubview(img)
        }
        
        nameLabel.text = "\(user.name)#\(user.code)"
    }
}
