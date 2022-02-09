//
//  DirectView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class DirectView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "다이렉트 메시지"
        $0.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
        $0.textColor = .white
    }
    
    let emptyView = FriendEmptyView()
    
    override func setup() {
        self.backgroundColor = .channelListDarkGray
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [
            titleLabel, emptyView
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    func bind(directList: [String]) {
        self.disposeBag = DisposeBag()
    }
}
