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
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapSignInButton = PublishSubject<Void>()
        let tapSignUpButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignIn = PublishRelay<Void>()
        let goToSignUp = PublishRelay<Void>()
    }
    
    init(
        userDefaults: UserDefaultsUtil
    ) {
        self.userDefaults = userDefaults
        super.init()
    }
    
    func hasToken() {
        let token = self.userDefaults.getUserToken()
        
//        if self.hasTokenFromLocal(token: token) {
//            // 토큰 있을 때 - 토큰 서버처리
//            self.userService.fetchUserInfo()
//                .subscribe(onNext: { User in
//                    self.output.goToMain.accept(())
//                }, onError: { Error in
//                    // TODO showErrorAlert
//                    print(Error)
//                })
//                .disposed(by: disposeBag)
//        } else {
//            // 토큰 없을 떄
//            self.output.goToSignIn.accept(())
//        }
    }
    
    func hasTokenFromLocal(token: String) -> Bool {
        return !token.isEmpty
    }
    
    override func bind() {
        self.input.tapSignInButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
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
