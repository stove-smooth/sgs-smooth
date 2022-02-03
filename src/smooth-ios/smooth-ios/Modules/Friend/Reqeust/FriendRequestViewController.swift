//
//  FriendRequestViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import UIKit
import Then
import RxSwift
import RxCocoa

protocol FriendRequestDelegate: AnyObject {
    func onClose()
}

class FriendRequestViewController: BaseViewController {
    
    weak var delegate: FriendRequestDelegate?
    
    private let requestView = FriendRequestView()
    private let viewModel: FriendRequestViewModel
    
    
    init() {
        self.viewModel = FriendRequestViewModel(friendService: FriendService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> UINavigationController {
        let friendVC = FriendRequestViewController()
        
        return UINavigationController(rootViewController: friendVC).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.isNavigationBarHidden = true
        }
    }
    

    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.view = self.requestView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onClose()
    }
    
    override func bindViewModel() {
        self.requestView.requestButton.rx.tap
            .bind(to: self.viewModel.input.tapRequestButton)
            .disposed(by: disposeBag)
        
        self.requestView.userField.rx.text
            .orEmpty
            .bind(to: viewModel.input.userTextField)
            .disposed(by: disposeBag)
        
        self.requestView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.viewModel.output.dismiss
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        // MARK: 토스트 팝업 처리
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
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
