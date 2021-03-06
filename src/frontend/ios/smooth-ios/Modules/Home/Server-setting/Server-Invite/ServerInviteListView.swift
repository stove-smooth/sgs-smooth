//
//  ServerInviteList.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerInviteListView: BaseView {
    
    let emptyView = ServerInviteEmptyView()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 12.5, left: 0, bottom: 0, right: 0)
        $0.separatorStyle = .none
        
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.register(ServerInviteCell.self, forCellReuseIdentifier: ServerInviteCell.identifier)
    }
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        self.addSubview(tableView)
        
    }
     
    override func bindConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showEmpty(isShow: Bool) {
        if isShow {
            addSubview(emptyView)
            emptyView.snp.makeConstraints {
                $0.top.right.left.bottom.edges.equalTo(0)
            }
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
}
