//
//  ServerInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import Foundation
import PanModal
import UIKit

class ServerInfoViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    weak var coordinator: HomeCoordinator?
    
    private lazy var serverInfoView = ServerInfoView(frame: self.view.frame)
    private let viewModel: ServerInfoViewModel
    
    let communityInfo: CommunityInfo
    
    init(communityInfo: CommunityInfo) {
        self.communityInfo = communityInfo
        self.viewModel = ServerInfoViewModel(
            communityInfo: communityInfo,
            serverRepository: ServerRepository()
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(communityInfo: CommunityInfo) -> ServerInfoViewController {
        return ServerInfoViewController(communityInfo: communityInfo).then {
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
        serverInfoView.bind(communityInfo: self.communityInfo)
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
    }
    
    private func showMakeChannel() {
        print("showMakeChannel")
    }
    
    private func showMakeCategory() {
        print("showMakeCategory")
    }
    
    private func showLeaveServer() {
        print("showLeaveServer")
        AlertUtils.showWithCancel(
            controller: self,
            title: "서버 퇴장",
            message: "이 서버에서 나가면 다시 초대를 받아야하는데 정말 \(self.communityInfo.name)에서 나갈건가요?"
        ) {
            self.viewModel.input.tapLeaveServer.onNext(())
       }
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
