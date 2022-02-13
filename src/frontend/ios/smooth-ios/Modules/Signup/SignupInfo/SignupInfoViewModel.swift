//
//  SignUpInfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import RxSwift
import RxCocoa

class SignupInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let email: String
    let userService: UserServiceProtocol
    
    struct Input {
        let tapRegisterButton = PublishSubject<Void>()
        
        let nameField = BehaviorRelay<String>(value: "")
        let nameValid = PublishSubject<Bool>()
        
        let passwordField = BehaviorRelay<String>(value: "")
        let passwordValid = PublishSubject<Bool>()
    }
    
    struct Output {
        let isVaild = PublishRelay<Bool>()
        let goToMain = PublishRelay<Void>()
    }
    
    init(
        email: String,
        userService: UserServiceProtocol
    ) {
        self.email = email
        self.userService = userService
        super.init()
    }
    
    
    override func bind() {
        Observable.combineLatest(self.input.nameValid, self.input.passwordValid)
            .bind(onNext: { (name, password) in
                if (name && password ){
                    self.output.isVaild.accept(true)
                } else {
                    self.output.isVaild.accept(false)
                }
            }).disposed(by: disposeBag)
        
        self.input.tapRegisterButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.signup(password: self.input.passwordField.value,
                            name: self.input.nameField.value)
            })
            .disposed(by: disposeBag)
    }
    
    func vaildPassword(password: String?) -> Bool {
        if password == nil {
            return false
        } else {
            return RegExUitils().password(password: password!)
        }
    }
    
    private func signup(password: String, name: String) {
        self.userService.signUp(email: self.email, password: password, name: name) { response,_ in
            guard let response = response else {
                return
            }
            
            if response.isSuccess {
                self.showToastMessage.accept("가입 완료")
                self.output.goToMain.accept(())
            } else {
                self.showErrorMessage.accept(response.message)
            }
            
        }
    }
}
