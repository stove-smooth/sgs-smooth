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
    let model: Model
    
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
    
    struct Model {
        let deviceToken: String
    }
    
    init(
        deviceToken: String,
        userDefaults: UserDefaultsUtil,
        userService: UserServiceProtocol
    ) {
        self.model = Model(deviceToken: deviceToken)
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
                    password: self.input.passwordTextFiled.value,
                    deviceToken: self.model.deviceToken
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func signIn(email: String, password: String, deviceToken: String) {
        self.userService.signIn(email: email, password: password, deviceToken: deviceToken) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.userDefaults.setUserToken(token: response!.accessToken)
                self.userDefaults.setChatURL(url: response!.url)
                
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
