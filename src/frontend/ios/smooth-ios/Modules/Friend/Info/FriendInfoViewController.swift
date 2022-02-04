//
//  FriendInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import Foundation
import PanModal

class FriendInfoViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    private lazy var infoView = FriendInfoView(frame: self.view.frame)
    private let viewModel: FriendInfoViewModel
    
    private let friend: Friend
    
    let actions: [UIAlertController.AlertAction] = [
        .action(title: "차단하기", style: .destructive),
        .action(title: "친구 삭제하기", style: .default),
        .action(title: "취소", style: .cancel)
    ]
    
    init(friend: Friend) {
        self.friend = friend
        self.viewModel = FriendInfoViewModel(
            friendService: FriendService(),
            friend: friend
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(friend: Friend) -> FriendInfoViewController {
        return FriendInfoViewController(friend: friend).then {
            $0.modalPresentationStyle = .overCurrentContext
        }
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = infoView
        infoView.bind(friend: friend)
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func bindViewModel() {
        self.infoView.settingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                UIAlertController.present(
                    in: self,
                    title: nil,
                    message: nil,
                    style: .actionSheet,
                    actions: self.actions
                ).subscribe(onNext: { index in
                    switch index {
                    case 0:
                        print("차단하기 \(self.friend)")
                        self.viewModel.input.tapBanButton.accept(())
                    case 1:
                        print("삭제하기 \(self.friend)")
                        self.viewModel.input.tapDeleteButton.accept(())
                    default:
                        break
                    }
                    }).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.dismiss
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
    }
}
