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
    
    fileprivate let section = PublishSubject<ChannelSection>()
    
    let serverInfoIcon = UIImageView().then {
        $0.image = UIImage(systemName: "ellipsis")?.withTintColor(.white!, renderingMode: .alwaysOriginal)
    }
    
    let serverInfoButton = UIButton().then {
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.textAlignment = .left
        $0.contentHorizontalAlignment = .left
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .white
        
        $0.dragInteractionEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.cellLayoutMarginsFollowReadableWidth = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
        
        $0.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)
        $0.register(ChannelCategoryCell.self, forHeaderFooterViewReuseIdentifier: ChannelCategoryCell.identifier)
    }
    
    let dataSource: channelDataSource = {
        let ds = channelDataSource(
            configureCell: { dataSource, tableView, indexPath, channel -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
                cell.bind(channel: dataSource[indexPath])
                
                return cell
            }
        )
        
        ds.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
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
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [
            tableView,
            serverInfoButton
        ].forEach { self.addSubview($0) }
        
        serverInfoButton.addSubview(serverInfoIcon)
    }
    
    override func bindConstraints() {
        serverInfoButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        serverInfoIcon.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(serverInfoButton.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
        }
    }
    
    func bind(communityInfo: CommunityInfo) {
        self.disposeBag = DisposeBag()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // MARK: title
        self.serverInfoButton.setTitle(communityInfo.name, for: .normal)
        
        // MARK: tableView
        let categoryList = communityInfo.categories
        
        var channelSection: [ChannelSection] = []
        if (communityInfo.categories != nil) {
            channelSection = categoryList!.compactMap {
                ChannelSection(header: $0.name, id: $0.id, items: $0.channels ?? [])
            }
        }
        Observable.just(channelSection)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func selected(indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
    }

}

extension ChannelView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelCategoryCell.identifier) as? ChannelCategoryCell else { return UITableViewHeaderFooterView() }
        
        headerCell.addButton.rx.tap
            .bind(onNext: {
                //  채널 생성
                self.section.onNext(self.dataSource[section])
            }).disposed(by: disposeBag)
        
        return headerCell
    }
    
    /* *💄 tableView headerView custom 하는 다른 방법*
     
     tableView.rx.delegate.methodInvoked(#selector(tableView.delegate?.tableView(_:willDisplayHeaderView:forSection:)))
     .take(until: tableView.rx.deallocated)
     .subscribe(onNext: { event in
     guard let headerView = event[1] as? UITableViewHeaderFooterView else { return }
     
     for view in headerView.subviews {
     view.backgroundColor = .clear
     }
     
     headerView.textLabel?.textColor = .white
     headerView.textLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
     
     })
     .disposed(by: disposeBag)
     */
}

extension Reactive where Base: ChannelView {
    var tapAddButon: ControlEvent<ChannelSection> {
        return ControlEvent(events: base.section)
    }
}
