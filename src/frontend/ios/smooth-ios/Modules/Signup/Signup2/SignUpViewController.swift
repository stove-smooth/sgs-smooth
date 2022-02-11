//
//  SignUpViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: BaseViewController {
    weak var coordinator: MainCoordinator?
    
    private let signupView = SignupView()
    private let viewModel = SignupViewModel(userService: UserService())
    
    static func instance() -> SignupViewController {
        return SignupViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.signupView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.signupView.initial()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.signupView.indicator.stopAnimating()
    }
    
    override func bindEvent() {
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
                self.signupView.initial()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        // input
        self.signupView.emailField.rx.text
            .distinctUntilChanged()
            .bind(onNext: { email in
                self.viewModel.input.emailTextField.accept(email!)
                
                let valid = self.viewModel.vaildEmail(email: email)
                self.viewModel.input.emailValid.onNext(valid)
            }).disposed(by: disposeBag)
        
        self.signupView.nextButton.rx.tap
            .bind(onNext: {
                self.viewModel.input.tapNextButton.onNext(())
                
                // loading 처리
                self.signupView.loading()
            })
            .disposed(by: disposeBag)
        
        // output
        self.viewModel.output.isVaild
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { valid in
                if valid {
                    self.signupView.nextButton.backgroundColor = .blurple
                } else {
                    self.signupView.nextButton.backgroundColor = .blurple_disabled
                }
                
                self.signupView.nextButton.isEnabled = valid
                self.signupView.notiTextLabel.isHidden = valid
                
            }).disposed(by: disposeBag)
        
        self.viewModel.output.goToVerifyCode
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToVerifyCode)
            .disposed(by: disposeBag)
    }
    
    private func goToVerifyCode() {
        self.coordinator?.goToVerifyCode()
    }
}
