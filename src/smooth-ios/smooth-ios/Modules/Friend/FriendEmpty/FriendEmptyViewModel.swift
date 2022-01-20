//
//  FriendEmptyViewModel.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/15.
//

import RxSwift
import RxCocoa

class FriendEmptyViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    struct Input {
        let tapRequestButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToRequest = PublishRelay<Void>()
    }

    override func bind() {
        self.input.tapRequestButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToRequest.accept(())
            })
            .disposed(by: disposeBag)
    }
}
