//
//  FriendListView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/23.
//

import Foundation
import UIKit

class FriendListView: BaseView {
    let navigationView = UIView().then {
      $0.backgroundColor = .backgroundDarkGray
    }
    
    let requestButton = UIButton().then {
        $0.setImage(UIImage(named: "User+Add")?.resizeImage(size: CGSize(width: 25, height: 25)), for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "친구"
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .messageBarDarkGray
        $0.separatorStyle = .none
    }
    
    let loadingView = UIView().then {
        $0.backgroundColor = .blurple
    }
    
    let emptyView = FriendEmptyView()
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [
            navigationView, naviTitleLabel, requestButton,
            tableView
        ].forEach {
            self.addSubview($0)
        }
    }
    
    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        requestButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(naviTitleLabel)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView).offset(-10)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
        }
        
    }
    
    override func showLoading(isShow: Bool) {
        if isShow {
            addSubview(loadingView)
            loadingView.snp.makeConstraints {
                $0.edges.equalTo(0)
            }
        } else {
            loadingView.removeFromSuperview()
        }
    }
    
    func showEmpty(isShow: Bool) {
        if isShow {
            print("emptyView showing")
            addSubview(emptyView)
            emptyView.snp.makeConstraints {
                $0.top.right.left.bottom.edges.equalTo(0)
            }
        } else {
            emptyView.removeFromSuperview()
        }
    }
}
