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
    private let viewModel = VerifyCodeViewModel(userService: UserService())
    
    static func instance() -> VerifyCodeViewController {
        return VerifyCodeViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.verifyCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindEvent() {
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
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToSignUpInfo)
            .disposed(by: disposeBag)
        
    }
    
    private func goToSignUpInfo() {
        self.coordinator?.goToSignUpInfo()
    }
    
}
