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
    let userRepository: UserRepositoryProtocol
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapSignInButton = PublishSubject<Void>()
        let tapSignUpButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignIn = PublishRelay<Void>()
        let goToSignUp = PublishRelay<Void>()
        let goToMain = PublishRelay<Void>()
    }
    
    init(
        userDefaults: UserDefaultsUtil,
        userRepository: UserRepositoryProtocol
    ) {
        self.userDefaults = userDefaults
        self.userRepository = userRepository
        super.init()
    }
    
    func hasToken() {
        let token = self.userDefaults.getUserToken()
        if self.hasTokenFromLocal(token: token) {
            // 토큰 있을 때 - 토큰 서버처리
            self.userRepository.fetchUserInfo { user, _ in
                guard let user = user else {
                    return
                }

                self.userDefaults.setUserToken(token: token)
                self.userDefaults.setUserInfo(user: user)
                self.output.goToMain.accept(())
            }
        }
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
        
        self.output.goToMain
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToMain.accept(())
            })
            .disposed(by: disposeBag)
    }
}
