//
//  SignInViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import RxSwift
import RxCocoa

class SignInViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let tapLoginButton = PublishSubject<Void>()
        let emailTextField = BehaviorRelay<String>(value: "")
        let passwordTextFiled = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let goToMain = PublishRelay<Void>()
        // TODO 회원가입으로 가기 만들기
    }
    
    
    init(
        userDefaults: UserDefaultsUtil
    ) {
        self.userDefaults = userDefaults
        super.init()
    }
    
    override func bind() {
        self.input.emailTextField
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        self.input.passwordTextFiled
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        self.input.tapLoginButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.signIn(request: SignInRequest(
                    email: self.input.emailTextField.value,
                    password: self.input.passwordTextFiled.value
                ))
            })
            .disposed(by: disposeBag)
    }
    
    private func signIn(request: SignInRequest) {
        UserRepository.signIn(request) { response, error in
            if error == nil {
                self.output.goToMain.accept(())
            } else {
                print("🆘 error!")
            }
        }
    }
}
