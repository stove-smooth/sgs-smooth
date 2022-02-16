//
//  InputBarAccessory.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/16.
//

import UIKit


class EditInputBarAccessoryView: BaseView {
    let editInputBarAccessoryView = UIButton().then {
        $0.setTitle("메시지 수정 중", for: .normal)
        $0.backgroundColor = .serverListDarkGray
        $0.setTitleColor(.iconDefault, for: .normal)
        
        $0.backgroundColor = .serverListDarkGray
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        $0.layer.borderWidth = 0.3
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setup() {
        self.addSubview(editInputBarAccessoryView)
    }
}



