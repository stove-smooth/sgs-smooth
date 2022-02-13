//
//  SignInViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import RxSwift
import RxCocoa

class SigninViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let userDefaults: UserDefaultsUtil
    let userService: UserServiceProtocol
    
    struct Input {
        let tapLoginButton = PublishSubject<Void>()
        let emailTextField = BehaviorRelay<String>(value: "")
        let passwordTextFiled = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let goToMain = PublishRelay<Void>()
    }
    
    init(
        userDefaults: UserDefaultsUtil,
        userService: UserServiceProtocol
    ) {
        self.userDefaults = userDefaults
        self.userService = userService
        super.init()
    }
    
    override func bind() {
        self.input.tapLoginButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.signIn(
                    email: self.input.emailTextField.value,
                    password: self.input.passwordTextFiled.value
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func signIn(email: String, password: String) {
        self.userService.signIn(email: email, password: password) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.userDefaults.setUserToken(token: response!.accessToken)
                self.fetchUserInfo()
                self.showToastMessage.accept("로그인 성공")
                
                self.output.goToMain.accept(())
            }
        }
    }
    
    private func fetchUserInfo() {
        self.userService.fetchUserInfo { user, error in
            
            guard let user = user else {
                return
            }
            
            self.userDefaults.setUserInfo(user: user)
        }
    }
}
