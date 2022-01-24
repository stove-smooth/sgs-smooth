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
    let channelView = ChannelView()
    
    override func setup() {
        self.backgroundColor = .serverListDarkGray
        
        [serverView, channelView].forEach { self.addSubview($0) }
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
    }
}


extension Reactive where Base: MenuView {
    var server: Binder<[Server]> {
        return Binder(self.base) { view, serverList in
            view.serverView.bind(serverList: serverList)
        }
    }
}
