//
//  ChannelSettingViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ChannelSettingViewContrller: BaseViewController, UIScrollViewDelegate {
    weak var coordinator: ServerSettingCoordinator?
    
    private let channelView = ChannelSettingView()
    private let viewModel: ChannelSettingViewModel
    
    var channelDataSource: RxTableViewSectionedAnimatedDataSource<ChannelSection>!
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = ChannelSettingViewModel(
            server: server,
            serverRepository: ServerRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> ChannelSettingViewContrller {
        return ChannelSettingViewContrller(server: server)
    }
    
    override func loadView() {
        super.view = self.channelView
        self.setupTableView()
        title = "채널"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.modalNav.isNavigationBarHidden = true
    }
    
    override func bindViewModel() {
        // MARK: - initial
        self.viewModel.output.showEmpty
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.channelView.showEmpty(isShow:))
            .disposed(by: disposeBag)
        
        self.viewModel.output.section
            .bind(to: self.channelView.tableView.rx.items(dataSource: self.channelDataSource))
            .disposed(by: disposeBag)
        
        // MARK: - input
        
        
        // MARK: - output
        self.viewModel.output.showEditCateogory
            .observe(on: MainScheduler.instance)
            .bind(onNext: { category in
                self.coordinator?.showEditCategory(category: category)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupTableView() {
        self.channelView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.channelDataSource = RxTableViewSectionedAnimatedDataSource<ChannelSection>(
            configureCell: {
                (dataSource, tableView, indexPath, item) in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerSettingCell.identifier, for: indexPath)
                        as? ServerSettingCell else { return BaseTableViewCell() }
                print(item.type.self)
                
                switch item.type {
                case .text:
                    cell.bind(image: UIImage(named: "Channel+text")!, title: item.name)
                case .voice:
                    cell.bind(image: UIImage(named: "Channel+voice")!, title: item.name)
                }
                
                return cell
            }, titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
            }
        )
    }
    
}

extension ChannelSettingViewContrller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelSettingHeaderCell.identifier) as? ChannelSettingHeaderCell else { return UITableViewHeaderFooterView() }
        
        headerCell.editButton.rx.tap
            .bind(onNext: {
                let section = self.channelDataSource.sectionModels[section]
            
                self.viewModel.input.tapEditCategory
                    .accept(Category(id: section.id,
                                     name: section.header,
                                     channels: section.items)
                    )
            })
            .disposed(by: disposeBag)
        return headerCell
    }
}
