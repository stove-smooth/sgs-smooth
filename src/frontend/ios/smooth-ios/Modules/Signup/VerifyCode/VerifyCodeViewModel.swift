//
//  VerifyCodeViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import RxSwift
import RxCocoa

class VerifyCodeViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let userService: UserServiceProtocol
    
    struct Input {
        let verifyCodeField = BehaviorRelay<String>(value: "")
        let tapNextButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignUpInfo = PublishRelay<Void>()
    }
    
    init(
        userService: UserServiceProtocol
    ) {
        self.userService = userService
        super.init()
    }
    
    override func bind() {
        self.input.tapNextButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.checkEmail(key: self.input.verifyCodeField.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkEmail(key: String) {
        self.userService.checkEmail(key) { response, _ in
            guard let response = response else {
                return
            }

            if response.isSuccess {
                self.output.goToSignUpInfo.accept(())
            } else {
                self.showErrorMessage.accept(response.message)
            }
        }
    }
}
