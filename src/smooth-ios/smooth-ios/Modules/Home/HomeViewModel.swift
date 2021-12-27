//
//  HomeViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let tapLogOutButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToSignin = PublishRelay<Void>()
    }
    
    init(
        userDefaults: UserDefaultsUtil
    ) {
        self.userDefaults = userDefaults
        super.init()
    }
    
    override func bind() {
        self.input.tapLogOutButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.signOut()
            })
            .disposed(by: disposeBag)
    }
    
    private func signOut() {
        self.userDefaults.clear()
        self.output.goToSignin.accept(())
    }
    
}

