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

class DirectView: BaseView, UIScrollViewDelegate {
    let titleLabel = UILabel().then {
        $0.text = "다이렉트 메시지"
        $0.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
        $0.textColor = .white
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .white
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.rowHeight = 50
        
        $0.register(DirectCell.self, forCellReuseIdentifier: DirectCell.identifier)
    }
    
    let emptyView = FriendEmptyView()
    
    override func setup() {
        self.backgroundColor = .channelListDarkGray
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [
            titleLabel, tableView
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    func bind(directList: [Room]) {
        self.disposeBag = DisposeBag()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        Observable.of(directList)
            .bind(to: tableView.rx.items) { tableView, index, room in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectCell.identifier) as? DirectCell else { return UITableViewCell() }
                cell.bind(room: room)
                
                return cell
            }.disposed(by: disposeBag)
        
        func showEmpty(isShow: Bool) {
            if isShow {
                addSubview(emptyView)
                emptyView.snp.makeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                    $0.bottom.equalToSuperview()
                    $0.left.right.equalToSuperview().inset(15)
                }
            } else {
                emptyView.removeFromSuperview()
            }
        }
    }
}
