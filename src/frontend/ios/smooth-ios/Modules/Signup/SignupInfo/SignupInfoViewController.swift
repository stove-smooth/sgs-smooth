//
//  SignUpInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import Foundation
import RxSwift


class SignupInfoViewController: BaseViewController {
    weak var coordinator: SplashCoordinator?
    
    private let signupInfoView = SignupInfoView()
    private let viewModel: SignupInfoViewModel
    
    init(email: String) {
        self.viewModel = SignupInfoViewModel(
            email: email,
            userService: UserService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(email: String) -> SignupInfoViewController {
        return SignupInfoViewController(email: email)
    }
    
    
    override func loadView() {
        super.view = self.signupInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindEvent() {
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
                self.signupInfoView.initial()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        // input
        self.signupInfoView.nameField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(onNext: { name in
                self.viewModel.input.nameField.accept(name)
                self.viewModel.input.nameValid.onNext(name.count > 0)
            })
            .disposed(by: disposeBag)
        
        self.signupInfoView.passwordField.rx.text
            .distinctUntilChanged()
            .bind(onNext: { password in
                self.viewModel.input.passwordField.accept(password!)
                
                let valid = self.viewModel.vaildPassword(password: password)
                self.viewModel.input.passwordValid.onNext(valid)
            }).disposed(by: disposeBag)
        
        // output
        self.viewModel.output.isVaild
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { valid in
                if valid {
                    self.signupInfoView.registerButton.backgroundColor = .blurple
                } else {
                    self.signupInfoView.registerButton.backgroundColor = .blurple_disabled
                }
                
                self.signupInfoView.registerButton.isEnabled = valid
                self.signupInfoView.notiTextLabel.isHidden = valid
            }).disposed(by: disposeBag)
        
        self.signupInfoView.registerButton.rx.tap
            .bind(onNext: {
                self.viewModel.input.tapRegisterButton.onNext(())
                self.signupInfoView.loading()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToMain
            .delay(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: {
                self.goToMain()
            })
            .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        self.coordinator?.start()
    }
}
