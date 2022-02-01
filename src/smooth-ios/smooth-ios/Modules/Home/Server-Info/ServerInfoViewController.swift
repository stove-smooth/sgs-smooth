//
//  ServerInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import Foundation
import PanModal
import UIKit
import RxGesture

class ServerInfoViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    weak var coordinator: HomeCoordinator?
    
    private lazy var serverInfoView = ServerInfoView(frame: self.view.frame)
    private let viewModel: ServerInfoViewModel
    
    let server: Server
    let member: Member
    
    init(
        server: Server,
        member: Member
    ) {
        self.server = server
        self.member = member
        
        self.viewModel = ServerInfoViewModel(
            server: server,
            member: member,
            serverRepository: ServerRepository()
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server, member: Member) -> ServerInfoViewController {
        return ServerInfoViewController(server: server, member: member).then {
            $0.modalPresentationStyle = .overCurrentContext
        }
    }
    
    var shortFormHeight: PanModalHeight {
        let half = view.bounds.height/2
        return .contentHeight(half)
    }
    
    var longFormHeight: PanModalHeight {
        let row = view.bounds.height/8
        return .contentHeight(row*7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = serverInfoView
        serverInfoView.bind(
            server: self.server,
            owner: member.role == .owner
        )
        self.setTableView()
    }
    
    private func setTableView() {
        self.serverInfoView.tableView.delegate = self
        self.serverInfoView.tableView.dataSource = self
    }
    
    override func bindViewModel() {
        self.viewModel.output.leaveServer
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
                self.coordinator?.goToMenu()
            })
            .disposed(by: disposeBag)
        
        self.serverInfoView.settingButton.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: { _ in
                self.goToServerInfo(server: self.server)
            })
            .disposed(by: disposeBag)
    }
    
    private func showMakeChannel() {
        print("showMakeChannel")
    }
    
    private func showMakeCategory() {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.showMakeCategory(server: self.server)
    }
    
    private func showLeaveServer() {
        AlertUtils.showWithCancel(
            controller: self,
            title: "서버 퇴장",
            message: "이 서버에서 나가면 다시 초대를 받아야하는데 정말 나갈건가요?"
        ) {
            self.viewModel.input.tapLeaveServer.onNext(())
        }
    }
    
    private func goToServerInfo(server: Server) {
        self.dismiss(animated: true, completion: nil)
//        self.coordinator?.goToServerInfo(server: self.server)
        self.coordinator?.goToServerSetting(server: self.server)
    }
}


extension ServerInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerInfoCell.identifier,
            for: indexPath
        ) as? ServerInfoCell else { return BaseTableViewCell() }
        
        if indexPath.section == 0 {
            
            if(indexPath.row == 0) {
                cell.titleLabel.text = "채널 만들기"
            } else {
                cell.titleLabel.text = "카테고리 만들기"
            }
            
        } else {
            cell.titleLabel.textColor = .red
            cell.titleLabel.text = "서버 나가기"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.showMakeChannel()
            } else {
                self.showMakeCategory()
            }
        } else {
            self.showLeaveServer()
        }
    }
}
