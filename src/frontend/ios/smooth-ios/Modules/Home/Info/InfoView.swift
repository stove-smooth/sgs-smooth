//
//  InfoView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import UIKit
import RxSwift

class InfoView: BaseView, UIScrollViewDelegate {
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .singleLine
        
        $0.register(MemberCell.self, forCellReuseIdentifier: MemberCell.identifier)
    }
    
    let dataSource: memberDataSource = {
        let ds = memberDataSource(
            configureCell: { dataSource, tableView, indexPath, cellType in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberCell.identifier, for: indexPath) as? MemberCell else { return UITableViewCell() }
                
                switch cellType {
                case .online(let member):
                    cell.bind(member: member)
                case .offline(let member):
                    cell.bind(member: member)
                }
                
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                "\(dataSource.sectionModels[index].header) - \(dataSource.sectionModels[index].items.count)"
            }
        )
        
        return ds
    }()
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [tableView].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
    }
    
    func bind(members: [Member]) {
        self.disposeBag = DisposeBag()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        let onlineSectionList = members.filter {$0.status == .online}
            .map { MemberCellType.online($0) }
        
        let offlineSectionList = members.filter {$0.status == .offline}
            .map { MemberCellType.offline($0) }
        
        let sections: [MemberSection] = [
            MemberSection(header: "온라인", items: onlineSectionList),
            MemberSection(header: "오프라인", items: offlineSectionList)
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension InfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = .white
    }
}
