//
//  FriendRequestViewModel.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa

class FriendRequestViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    
    struct Input {
        let tapRequestButton = PublishSubject<Void>()
    }
    
    struct Output {
        
    }
    
    override func bind() {
        self.input.tapRequestButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                // 실제 네트워크로 요청 보내기
                print("todo - 실제 네트워크 요청 보내기(tapRequestButton)")
            })
            .disposed(by: disposeBag)
    }
}
