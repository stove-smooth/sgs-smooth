//
//  ServerInviteListViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import RxSwift
import RxCocoa
import CoreAudio
import Foundation

class ServerInviteListViewController: BaseViewController {
    weak var coordinator: ServerSettingCoordinator?
    
    private var inviteView = ServerInviteListView()
    private let viewModel: ServerInviteListViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = ServerInviteListViewModel(server: server, serverRepository: ServerRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> ServerInviteListViewController {
        return ServerInviteListViewController(server: server)
    }
    
    private func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        super.view = self.inviteView
        //        inviteView.bind(server: self.server)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "초대"
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func bindViewModel() {
        self.viewModel.output.invitations
            .bind(to: self.inviteView.tableView.rx.items(cellIdentifier: ServerInviteCell.identifier)) {
                (index: Int, invite: Invitation, cell: ServerInviteCell) in
                cell.bind(inviteUser: invite)
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(self.inviteView.tableView.rx.itemSelected, self.inviteView.tableView.rx.modelSelected(Invitation.self))
            .subscribe(onNext: { indexPath, item in
                self.inviteView.tableView.deselectRow(at: indexPath, animated: true)
                self.viewModel.output.pastedBoard.accept(item)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
    }
}
