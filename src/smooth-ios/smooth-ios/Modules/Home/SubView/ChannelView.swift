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
            return "\(dataSource.sectionModels[index].header)"
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
        let categoryList = communityInfo.categories
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        // MARK: title
        self.serverInfoButton.setTitle(communityInfo.name, for: .normal)
        
        // MARK: tableView
        var channelSection: [ChannelSection] = []
        channelSection = categoryList.compactMap {
            ChannelSection(header: $0.name, id: $0.id, items: $0.channels ?? [])
        }
        
        Observable.just(channelSection)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath)
            })
            .disposed(by: disposeBag)
        
        //
        //        tableView.rx.modelSelected(Channel.self)
        //            .observe(on: MainScheduler.instance)
        //            .bind(onNext: { model in
        //                // TODO: - contentView Bindign
        ////                self.goToContainer(channel: model)
        //            })
        //            .disposed(by: disposeBag)
        
    }
}

extension ChannelView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}
