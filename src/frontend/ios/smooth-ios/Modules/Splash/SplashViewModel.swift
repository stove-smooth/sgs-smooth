//
//  SplashViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import RxCocoa
import RxSwift

class SplashViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapSignInButton = PublishSubject<Void>()
        let tapSignUpButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignIn = PublishRelay<Void>()
        let goToSignUp = PublishRelay<Void>()
    }
    
    override func bind() {
        self.input.tapSignInButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                ChatWebSocketService().register()
                self.output.goToSignIn.accept(())
            })
            .disposed(by: disposeBag)
        
        self.input.tapSignUpButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToSignUp.accept(())
            })
            .disposed(by: disposeBag)
    }
}
