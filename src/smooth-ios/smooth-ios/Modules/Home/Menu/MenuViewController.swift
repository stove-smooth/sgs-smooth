//
//  MeneViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol MenuViewControllerDelegate: AnyObject {
    func swipe(channel: Channel?, communityId: Int)
}

class MenuViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: HomeCoordinator?
    weak var delegate: MenuViewControllerDelegate?
    
    private lazy var menuView = MenuView(frame: self.view.frame)
    private let viewModel: MenuViewModel
    
    init() {
        self.viewModel = MenuViewModel(
            serverService: ServerService(),
            userDefaults: UserDefaultsUtil()
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> MenuViewController {
        return MenuViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.viewModel.input.fetch.onNext(())
        
        let selectedServerIndex = self.viewModel.model.selectedServerIndex
        // 선택한 서버가 있는 경우
        if selectedServerIndex == nil {
            self.viewModel.input.tapServer.onNext(IndexPath(row: 0, section: 0))
        } else {
            self.viewModel.input.tapServer.onNext(IndexPath(row: 0, section: selectedServerIndex!))
        }
        
    }
    
    override func viewDidLoad() {
        self.view = menuView
        super.viewDidLoad()
    }
    
    override func bindEvent() {
        // MARK: event
        self.menuView.channelView.rx.tapAddButon.bind(onNext: {
            section in
            print("event \(section)")
            self.coordinator?.showMakeChannel(categoryId: section.id)
        })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        // MARK: input
        self.menuView.serverView.tableView.rx.itemSelected
            .map { $0 }
            .bind(to: self.viewModel.input.tapServer)
            .disposed(by: disposeBag)
        
        self.menuView.channelView.serverInfoButton
            .rx.tap
            .asDriver()
            .drive(onNext: {
                guard let index = self.viewModel.model.selectedServerIndex else { return }
                
                self.showServerInfoModal(
                    server: self.viewModel.model.servers![index],
                    member: self.viewModel.model.me!
                )
            })
            .disposed(by: disposeBag)
        
        self.menuView.directView.emptyView.requestButton
            .rx.tap.asDriver()
            .drive(onNext: {
                self.coordinator?.goToFriend()
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            self.menuView.channelView.tableView.rx.itemSelected,
            self.menuView.channelView.tableView.rx.modelSelected(Channel.self)
        ).bind{ [weak self] (indexPath, channel) in
            guard let self = self else { return }
            
            self.menuView.channelView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            print("selected \(channel)")
            
            switch channel.type {
            case .text :
                let server = self.viewModel.model.servers![self.viewModel.model.selectedServerIndex!]
                
                self.delegate?.swipe(channel: channel, communityId: server.id)
            case .voice:
                #warning("웹알티씨 연결하기")
            }
        }.disposed(by: disposeBag)
        
        // MARK: output
        self.viewModel.output.servers
            .asDriver(onErrorJustReturn: [])
            .drive(self.menuView.rx.server)
            .disposed(by: disposeBag)
        
        self.viewModel.output.communityInfo
            .asDriver(onErrorJustReturn: CommunityInfo())
            .drive(self.menuView.rx.communityInfo)
            .disposed(by: disposeBag)
        
        self.viewModel.output.directs
            .asDriver(onErrorJustReturn: [])
            .drive(self.menuView.rx.direct)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToAddServer
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToAddServer)
            .disposed(by: disposeBag)
        
    }
    
    func goToAddServer() {
        self.coordinator?.goToAddServer()
    }
    
    func showServerInfoModal(server: Server, member: Member) {
        self.coordinator?.showServerInfoModal(server: server, member: member)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}

