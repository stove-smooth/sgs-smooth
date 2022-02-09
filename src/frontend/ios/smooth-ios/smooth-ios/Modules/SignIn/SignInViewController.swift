//
//  SignInViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class SignInViewController: BaseViewController {
    private let authView = SignInView()
    private let viewModel = SignInViewModel(
        userDefaults: UserDefaultsUtil(),
        userService: UserService()
    )
    
    weak var coordinator: MainCoordinator?
    
    static func instance() -> SignInViewController {
        return SignInViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.authView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.backgroundDarkGray
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        self.authView.emailField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.emailTextField)
            .disposed(by: disposeBag)
        
        self.authView.passwordField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.passwordTextFiled)
            .disposed(by: disposeBag)
    
        self.authView.loginButton.rx.tap
            .bind(to: self.viewModel.input.tapLoginButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToMain
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToMain)
            .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        self.coordinator?.goToMain()
    }
    
}

