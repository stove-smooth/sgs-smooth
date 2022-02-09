//
//  MenuView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import UIKit
import RxSwift

class MenuView: BaseView {
    
    let serverView = ServerView()
    let channelView = ChannelView().then { $0.isHidden = true }
    let directView = DirectView().then { $0.isHidden = true }
    
    override func setup() {
        self.backgroundColor = .serverListDarkGray
        
        [
            serverView, channelView, directView
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        serverView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.left.equalToSuperview()
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        channelView.snp.makeConstraints {
            $0.left.equalTo(serverView.snp.right)
            $0.trailing.equalToSuperview().offset(-60)
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        directView.snp.makeConstraints {
            $0.left.equalTo(serverView.snp.right)
            $0.trailing.equalToSuperview().offset(-60)
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}


extension Reactive where Base: MenuView {
    var server: Binder<[Server]> {
        return Binder(self.base) { view, serverList in
            view.serverView.bind(serverList: serverList)
        }
    }
    
    var selectedServer: Binder<Int?> {
        return Binder(self.base) { view, selectedServer in
            if (selectedServer == nil) {
                view.serverView.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
            } else {
                view.serverView.tableView.selectRow(at: IndexPath(row: selectedServer!, section: 1), animated: false, scrollPosition: .none)
            }
        }
    }

    var communityInfo: Binder<(CommunityInfo, IndexPath?)> {
        return Binder(self.base) { view, communityInfo in
            view.channelView.isHidden = false
            view.directView.isHidden = true
            view.channelView.bind(communityInfo: communityInfo.0, selectedChannel: communityInfo.1)
        }
    }
    
    var selectedChannel: Binder<IndexPath?> {
        return Binder(self.base) { view, selectedChannel in
            view.channelView.tableView.selectRow(at: selectedChannel, animated: true, scrollPosition: .none)
        }
    }
    
    var direct: Binder<[String]> {
        return Binder(self.base) { view, directList in
            view.channelView.isHidden = true
            view.directView.isHidden = false
            
            view.directView.bind(directList: directList)
        }
    }
}


