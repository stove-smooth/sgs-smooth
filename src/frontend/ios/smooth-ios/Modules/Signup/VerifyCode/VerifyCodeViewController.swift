//
//  VerifyCodeViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyCodeViewController: BaseViewController {
    weak var coordinator: MainCoordinator?
    
    private let verifyCodeView = VerifyCodeView()
    private let viewModel: VerifyCodeViewModel
    
    init(email: String) {
        self.viewModel = VerifyCodeViewModel(
            email: email,
            userService: UserService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(email: String) -> VerifyCodeViewController {
        return VerifyCodeViewController(email: email)
    }
    
    override func loadView() {
        super.view = self.verifyCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindEvent() {
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        // input
        self.verifyCodeView.verifyCodeField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: self.viewModel.input.verifyCodeField)
            .disposed(by: disposeBag)
        
        self.verifyCodeView.nextButton.rx.tap
            .bind(to: self.viewModel.input.tapNextButton)
            .disposed(by: disposeBag)
        
        // output
        self.viewModel.output.goToSignUpInfo
            .delay(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { email in
                self.goToSignUpInfo(email: email)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func goToSignUpInfo(email: String) {
        self.coordinator?.goToSignUpInfo(email: email)
    }
    
}
