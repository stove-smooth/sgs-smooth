//
//  ServerView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ServerView: BaseView, UIScrollViewDelegate {
    let tableView = UITableView().then {
        $0.backgroundColor = nil
        $0.separatorStyle = .none
        $0.rowHeight = 80
        
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        $0.cellLayoutMarginsFollowReadableWidth = true
        $0.separatorInsetReference = .fromAutomaticInsets
        
        $0.register(ServerCell.self, forCellReuseIdentifier: ServerCell.identifier)
        $0.register(ServerButtonCell.self, forCellReuseIdentifier: ServerButtonCell.identifier)
    }
    
    let dataSource: serverDataSource = {
        let ds = serverDataSource(
            configureCell: { dataSource, tableView, indexPath, cellType in
                
                switch cellType {
                case .home:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerButtonCell.identifier, for: indexPath) as? ServerButtonCell else { return UITableViewCell() }
                    cell.bind(type: .home)
                    return cell
                case .normal(let server):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.identifier, for: indexPath) as? ServerCell else { return UITableViewCell() }
                    cell.bind(server: server)
                    return cell
                case .add:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerButtonCell.identifier, for: indexPath) as? ServerButtonCell else { return UITableViewCell() }
                    cell.bind(type: .add)
                    return cell
                }
            }
        )
        return ds
    }()
    
    override func setup() {
        self.addSubview(tableView)
    }
    
    override func bindConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(serverList: [Server]) {
        self.disposeBag = DisposeBag()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let cellSection = serverList.map { ServerCellType.normal($0) }
        
        let sections: [ServerSection] = [
            ServerSection(header: "direct", items: [ServerCellType.home]),
            ServerSection(header: "community", items: cellSection),
            ServerSection(header: "add", items: [ServerCellType.add])
        ]
       
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
