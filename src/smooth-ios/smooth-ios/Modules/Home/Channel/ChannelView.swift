//
//  ChannelView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ChannelView: BaseView {
    let tableView = UITableView().then {
        $0.backgroundColor = .messageBarDarkGray
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.cellLayoutMarginsFollowReadableWidth = true
        $0.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)
    }
    
    let dataSource: channelDataSource = {
        let ds = channelDataSource(
            configureCell: { dataSource, tableView, indexPath, channel -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
                cell.backgroundColor = .messageBarDarkGray
                cell.textLabel?.text = "\(dataSource[indexPath].name)"
                cell.textLabel?.textColor = .white
                cell.tintColor = .white
                
                return cell
            }
        )
        
        ds.titleForHeaderInSection = { dataSource, index in
            return "channel - \(dataSource.sectionModels[index].header)"
        }
        
        ds.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        ds.canMoveRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        return ds
    }()
    
    override func setup() {
        self.backgroundColor = .channelListDarkGray
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.addSubview(tableView)
    }
    
    override func bindConstraints() {
   
    }
    
    func bind(channels: [ChannelSection]) {
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        Observable.just(channels)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Channel.self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { model in
                // TODO: - contentView Bindign
//                self.goToContainer(channel: model)
            })
            .disposed(by: disposeBag)
        
    }
}
