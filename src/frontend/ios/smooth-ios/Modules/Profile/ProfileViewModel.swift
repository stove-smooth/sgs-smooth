//
//  ProfileViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let userService: UserServiceProtocol
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let fetch = PublishSubject<Void>()
    }
    
    struct Output {
        let user = PublishRelay<User>()
    }
    
    struct Model {
        var user: User?
    }
    
    init(
        userService: UserServiceProtocol,
        userDefaults: UserDefaultsUtil
    ) {
        self.userService = userService
        self.userDefaults = userDefaults
        
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .bind(onNext: {
                let user = self.userDefaults.getUserInfo()
                self.output.user.accept(user!)
                self.model.user = user
            }).disposed(by: disposeBag)
    }
}
