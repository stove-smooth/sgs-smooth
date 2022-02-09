//
//  SignUpInfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import RxSwift
import RxCocoa

class SignUpInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    struct Input {
        let tapNextButton = PublishSubject<Void>()
        let nickNameField = BehaviorRelay<String>(value: "")
        let passwordField = BehaviorRelay<String>(value: "")
    }
    
    struct Output {
        let goToMain = PublishRelay<Void>()
    }
    
    
    override init() {
        super.init()
    }
    
    
    override func bind() {
        self.input.tapNextButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToMain.accept(())
            })
            .disposed(by: disposeBag)
        
        self.input.nickNameField
            .subscribe(onNext: {
                print($0)
                // TODO: 닉네임 정규식에 따라 UI 변화 알려주기
            })
            .disposed(by: disposeBag)
        
    }
}
