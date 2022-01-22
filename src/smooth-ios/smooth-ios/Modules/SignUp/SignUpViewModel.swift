//
//  SignUpViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import RxSwift
import RxCocoa

class SignUpViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let emailTextField = BehaviorRelay<String>(value: "")
        let tapNextButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToVerifyCode = PublishRelay<Void>()
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
        
        self.input.tapNextButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.sendMail(request: SendMailRequest(email: self.input.emailTextField.value))
            })
            .disposed(by: disposeBag)
    }
    
    private func sendMail(request: SendMailRequest) {
        UserRepository.sendMail(request) { response,_ in
            self.output.goToVerifyCode.accept(())
        }
        
    }
}