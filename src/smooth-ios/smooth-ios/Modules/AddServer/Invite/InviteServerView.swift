//
//  InviteServerView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class InviteServerView: BaseView {
    let closeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.tintColor = .white
    }
    
    let titleLabel = UILabel().then {
        $0.text = "사람 추가하기"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "서버를 최대한 활용하려면 친구가 좀 더 필요할 거예요."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let inviteCodeButton = UIButton().then {
        $0.backgroundColor = .serverListDarkGray
        $0.layer.cornerRadius = 5
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.textAlignment = .left
        
        $0.setImage(UIImage(systemName: "link")?.withTintColor(.white!, renderingMode: .alwaysOriginal), for: .normal)
        
        $0.contentHorizontalAlignment = .leading
    }
    
    let friendTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = InviteFriendListCell.height
        $0.register(InviteFriendListCell.self, forCellReuseIdentifier: InviteFriendListCell.identifier)
    }
    
    let dataSource: friendDataSource = {
        let ds = friendDataSource(
            configureCell: { dataSource, tableView, indexPath, cellType in
                switch cellType {
                case .empty:
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.identifier, for: indexPath)
                    return cell
                    
                case .normal(let friend):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendListCell.identifier, for: indexPath) as? InviteFriendListCell else {
                        return UITableViewCell()
                    }
                    
                    cell.bind(friend: friend)
                    return cell
                }
            }
        )
        return ds
    }()
    
    override func setup() {
        self.backgroundColor = .backgroundDarkGray
        
        [
            closeButton, titleLabel, titleDescriptionLabel,
            inviteCodeButton, friendTableView
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        closeButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        inviteCodeButton.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(15)
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        friendTableView.snp.makeConstraints {
            $0.top.equalTo(inviteCodeButton.snp.bottom).offset(10)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            // $0.height.equalTo(0)
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    func bind(inviteCode: String) {
        self.inviteCodeButton.setTitle(inviteCode, for: .normal)
    }
    
    func bindTable(sections: [FriendSection]) {
        Observable.just(sections)
            .bind(to: self.friendTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
