//
//  SigninViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa

class SigninViewController: BaseViewController {
    weak var coordinator: SplashCoordinator?
    
    private let signinView = SigninView()
    private let viewModel: SigninViewModel
    
    init() {
        self.viewModel = SigninViewModel(
            userDefaults: UserDefaultsUtil(),
            userService: UserService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> SigninViewController {
        return SigninViewController()
    }
    
    override func loadView() {
        super.view = self.signinView
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
        self.signinView.emailField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.emailTextField)
            .disposed(by: disposeBag)
        
        self.signinView.passwordField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.passwordTextFiled)
            .disposed(by: disposeBag)
        
        self.signinView.loginButton.rx.tap
            .bind(onNext: {
                self.viewModel.input.tapLoginButton.onNext(())
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToMain
            .delay(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: self.goToMain)
            .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        self.coordinator?.goToMain()
    }
    
}

