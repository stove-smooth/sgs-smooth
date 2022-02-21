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
    func swipe(_ chatName: String, destinationStatus: DestinationStatus)
}

class MenuViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: HomeCoordinator?
    
    weak var delegate: MenuViewControllerDelegate?
    
    private lazy var menuView = MenuView(frame: self.view.frame)
    private let viewModel: MenuViewModel
    
    init() {
        self.viewModel = MenuViewModel(serverService: ServerService(), userDefaults: UserDefaultsUtil())
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.viewModel.input.fetch.onNext(())
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
        self.menuView.channelView.serverInfoButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let indexPath = self.viewModel.model.selectedServerIndex
                
                self.showServerInfoModal(
                    server: self.viewModel.model.servers[indexPath.section-1][indexPath.row],
                    member: self.viewModel.model.user!
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
            self.menuView.directView.tableView.rx.itemSelected,
            self.menuView.directView.tableView.rx.modelSelected(Room.self)
        ).subscribe(onNext: { [weak self] (indexPath, room) in
            self?.menuView.directView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
            self?.delegate?.swipe(room.name,
                                  destinationStatus: .direct(room.id))
        })
            .disposed(by: disposeBag)
        
        Observable.zip(
            self.menuView.serverView.tableView.rx.itemSelected,
            self.menuView.serverView.tableView.rx.modelSelected(ServerCellType.self)
        ).subscribe(onNext: { [weak self] (indexPath, cellType) in
            
            self?.menuView.serverView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self?.viewModel.input.tapServer.onNext((indexPath, cellType))
        }).disposed(by: disposeBag)
        
        Observable.zip(
            self.menuView.channelView.tableView.rx.itemSelected,
            self.menuView.channelView.tableView.rx.modelSelected(Channel.self)
        ).bind{ (indexPath, channel) in
            self.viewModel.output.selectedChannel.accept(indexPath)
            
            switch channel.type {
            case .text:
                let serverId = self.viewModel.model.servers[self.viewModel.model.selectedServerIndex.section-1][self.viewModel.model.selectedServerIndex.row].id
                
                self.delegate?.swipe(channel.name, destinationStatus:  .community((serverId, channel.id, false)))
            case .voice:
                // webRTC webView
                let serverId = self.viewModel.model.servers[self.viewModel.model.selectedServerIndex.section-1][self.viewModel.model.selectedServerIndex.row].id
                self.delegate?.swipe(
                    channel.name,
                    destinationStatus: .community((serverId, channel.id, true))
                )
                break
            }
        }.disposed(by: disposeBag)
        
        // MARK: output
        self.viewModel.output.community
            .asDriver(onErrorJustReturn: Community.init(rooms: [], communities: []))
            .drive(self.menuView.rx.community)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(self.viewModel.output.communityInfo, self.viewModel.output.selectedChannel)
            .observe(on: MainScheduler.instance)
            .bind(to: self.menuView.rx.communityInfo)
            .disposed(by: disposeBag)
        
        self.viewModel.output.rooms
            .asDriver(onErrorJustReturn: nil)
            .drive(self.menuView.rx.rooms)
            .disposed(by: disposeBag)
        
        self.viewModel.output.selectedServer
            .asDriver(onErrorJustReturn: IndexPath(row: 0, section: 0))
            .drive(onNext: { indexPath in
                self.menuView.rx.selectedServer.onNext(indexPath)
                
                if (indexPath.section == 1) {
                    let room = self.viewModel.model.servers[0][indexPath.row]
                    self.delegate?.swipe(room.name, destinationStatus: .direct(room.id))
                } 
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.selectedRoom
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { roomInfo in
                guard let roomInfo = roomInfo else { return }
                self.delegate?.swipe(roomInfo.name, destinationStatus: .direct(roomInfo.id))
            }).disposed(by: disposeBag)
        
        self.viewModel.output.selectedChannel
            .bind(onNext: { indexPath in
                if (indexPath == nil) {
                    self.delegate?.swipe("채팅 없음", destinationStatus: .home)
                }
            }).disposed(by: disposeBag)
        
        // MARK: coordinator
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
