//
//  SignUpViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import RxSwift
import RxCocoa

class SignupViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let userService: UserServiceProtocol
    
    struct Input {
        let emailTextField = BehaviorRelay<String?>(value: nil)
        let emailValid = PublishSubject<Bool>()
        let tapNextButton = PublishSubject<Void>()
    }
    
    struct Output {
        let isVaild = PublishRelay<Bool>()
        let goToVerifyCode = PublishRelay<Void>()
    }
    
    init(
        userService: UserServiceProtocol
    ) {
        self.userService = userService
        super.init()
    }
    
    override func bind() {
        self.input.emailValid
            .bind(onNext: { valid in
                self.output.isVaild.accept(valid)
            })
            .disposed(by: disposeBag)
        
        self.input.tapNextButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.sendMail(email:  self.input.emailTextField.value!)
            })
            .disposed(by: disposeBag)
    }
    
    private func sendMail(email: String) {
        self.userService.sendMail(email) { response,_ in
            guard let response = response else {
                return
            }
            
            if response.isSuccess {
                self.output.goToVerifyCode.accept(())
            } else {
                self.showErrorMessage.accept(response.message)
            }
            
        }
    }
    
    func vaildEmail(email: String?) -> Bool {
        if email == nil {
            return false
        } else {
            return RegExUitils().email(email: email!)
        }
    }
}
