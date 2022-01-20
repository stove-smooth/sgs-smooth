//
//  FriendView.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/15.
//

import UIKit
import Then
import RxDataSources
import RxSwift
import RxCocoa

class FriendView: BaseView {
    typealias friendDataSource = RxTableViewSectionedReloadDataSource<FriendSection>
    
    let tableView = UITableView().then {
        $0.backgroundColor = .messageBarDarkGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.cellLayoutMarginsFollowReadableWidth = true
        
        $0.register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
//        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    let dataSoruce: friendDataSource = {
        let ds = friendDataSource(
            configureCell: { dataSource, tableView, indexPath, friend ->
                UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell else { return UITableViewCell() }

                cell.backgroundColor = .messageBarDarkGray
//                cell.textLabel?.text = "\(dataSource[indexPath])"
                cell.textLabel?.text = "\(indexPath)"
                cell.textLabel?.textColor = .white
                cell.tintColor = .white
                return cell
            }
        )

        ds.titleForHeaderInSection = { dataSource, index in
            return "header - \(index)"
        }

        ds.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }

        ds.canMoveRowAtIndexPath = { dataSource, indexPath in
            return true
        }

        return ds
    }()
    
    let Labael = UILabel().then {
        $0.text = "table view"
    }
    
    override func setup() {
        self.backgroundColor = .messageBarDarkGray
        
        [
            tableView
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
//        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        
//        Labael.snp.makeConstraints {
//            $0.center.centerY.equalToSuperview()
//        }
    }
}
