//
//  MakeChannelView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit

class MakeChannelView: BaseView {
    
    let channelNameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [
            channelNameLabel
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        
    }
}
