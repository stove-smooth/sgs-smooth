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
    
    struct Input {
        let verifyCodeField = BehaviorRelay<String>(value: "")
        let tapNextButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignUpInfo = PublishRelay<Void>()
    }
    
    override init() {
        super.init()
    }
    
    override func bind() {
        self.input.verifyCodeField
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        self.input.tapNextButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.checkEmail(request: VerifyCodeRequest(key: self.input.verifyCodeField.value))
            })
            .disposed(by: disposeBag)
    }
    
    private func checkEmail(request: VerifyCodeRequest) {
        UserRepository.checkEmail(request) { response, _ in
            self.output.goToSignUpInfo.accept(())
        }
    }
}