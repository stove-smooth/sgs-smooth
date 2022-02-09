//
//  InviteServerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/27.
//

import Foundation
import RxSwift


class InviteServerViewController: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let inviteView = InviteServerView()
    private let viewModel: InviteServerViewModel
    
    init(serverId: Int) {
        self.viewModel = InviteServerViewModel(
            serverId: serverId,
            serverService: ServerService(),
            friendService: FriendService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(serverId: Int) -> InviteServerViewController {
        return InviteServerViewController(serverId: serverId)
    }
    
    
    override func loadView() {
        view = inviteView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coordinator?.modalNav.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func bindViewModel() {
        self.inviteView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.inviteView.inviteCodeButton.rx.tap
            .bind(onNext: {
                guard let code = self.viewModel.inviteCode else { return }
                UIPasteboard.general.string = code
                self.viewModel.output.pastedBoard.accept(())
            }).disposed(by: disposeBag)
        
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.inviteCode
            .bind(onNext: self.inviteView.bind(inviteCode:))
            .disposed(by: disposeBag)
        
        self.viewModel.output.frienSections
            .bind(onNext: self.inviteView.bindTable(sections:))
            .disposed(by: disposeBag)
        
        Observable.zip(
            self.inviteView.friendTableView.rx.itemSelected,
            self.inviteView.friendTableView.rx.modelSelected(FriendCellType.self)
        ).subscribe(onNext: { [weak self] (indexPath, cell) in
            switch cell {
            case .empty: break
            case .normal(let friend):
                self?.inviteView.friendTableView.deselectRow(at: indexPath, animated: true)
                self?.viewModel.output.invite.accept(friend)
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.goToMain()
    }
}
