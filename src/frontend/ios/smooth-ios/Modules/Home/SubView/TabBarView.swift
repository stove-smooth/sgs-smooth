//
//  TabBarView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import UIKit

enum TabBarTag {
    case home
    case friend
    case profile
}

class TabBarView: BaseView {
    let containerView = UIView().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layoutMargins = UIEdgeInsets.symmetric(vertical: 0, horizontal: 10)
    }
    
    let buttonStackView = UIStackView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.alignment = .fill
    }
    
    let homeButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBar+Logo-selected")?.icon, for: .normal)
    }
    
    let friendButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBar+Friend-selected")?.icon, for: .normal)
    }
    
    let profileButton = UIButton().then {
        $0.setImage(UIImage(named: "TabBar+Logo-selected")?.icon, for: .normal)
    }
    
    override func setup() {
        [homeButton, friendButton, profileButton]
            .forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            buttonStackView
        ].forEach {
            containerView.addSubview($0)
        }
        
        self.addSubview(containerView)
    }
    
    override func bindConstraints() {
        
        containerView.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(containerView)
            $0.left.right.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
        
        homeButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        friendButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        profileButton.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
    }
    
    func setItem(tag: TabBarTag) {
        switch tag {
        case .home:
            self.homeButton.setImage(UIImage(named: "TabBar+Logo")?.icon, for: .normal)
        case .friend:
            self.friendButton.setImage(UIImage(named: "TabBar+Friend")?.icon, for: .normal)
        case .profile:
            break
        }
    }
}
