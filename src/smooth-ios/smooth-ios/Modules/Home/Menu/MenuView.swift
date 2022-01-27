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
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-49.0)
        }
        
        channelView.snp.makeConstraints {
            $0.left.equalTo(serverView.snp.right)
            $0.trailing.equalToSuperview().offset(-60)
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-49.0)
        }
    }
}


extension Reactive where Base: MenuView {
    var server: Binder<[Server]> {
        return Binder(self.base) { view, serverList in
            view.serverView.bind(serverList: serverList)
        }
    }
    
    var categories: Binder<[Category]> {
        return Binder(self.base) { view, categoryList in
            view.channelView.bind(categoryList: categoryList)
        }
    }
}
